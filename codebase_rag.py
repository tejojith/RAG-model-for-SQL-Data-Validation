import os
from langchain.vectorstores import FAISS
#from langchain_community.embeddings import OllamaEmbeddings
#from langchain_community.llms import Ollama
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import DirectoryLoader
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import TextLoader
#from :class:`~langchain_ollama import OllamaLLM`
from langchain_ollama.embeddings import OllamaEmbeddings
from langchain_ollama.llms import OllamaLLM

from multiprocessing import Pool
from langchain_community.document_loaders import (TextLoader, PythonLoader, 
                                                        JSONLoader, BSHTMLLoader)


from langchain.prompts import PromptTemplate

VALIDATION_PROMPT = PromptTemplate.from_template("""
You are a SQL schema validator. When given a request for SQL schema validation:

1. Return ONLY the raw SQL validation code in the language specified by the user.
2. No explanations, no markdown formatting, no comments
3. Just the pure SQL statements that would validate the schema.
4. If the request is for Python or Java, return the code that would validate the SQL schema.

Context: {context}

User Request: {question}

SQL Validation Code:

""")

#Output Mode: {mode}


class CodebaseRAG:
    def __init__(self, project_path, db_path):
        self.project_path = project_path
        self.db_path = db_path
        self.embed_model = "nomic-embed-text"  # or mxbai-embed-large for code
        self.embedding = OllamaEmbeddings(model=self.embed_model)
        self.vector_db = None

    def save_to_file(self, answer):
        output_format = input("Choose a format to save results (e.g. sql, py): ").strip().lower()
        valid_formats = ["txt", "sql", "py", "java"]
        if output_format not in valid_formats:
            print(f"Invalid format. Defaulting to 'txt'")
            output_format = "txt"


        output_file = f"rag_output.{output_format}"
        with open(output_file, "w", encoding="utf-8") as f:
            if output_format == "txt":
                f.write(f"{answer}\n{'-'*40}\n")
            elif output_format == "sql":
                if '```sql' in answer:
                    sql_code = answer.split('```sql')[1].split('```')[0].strip()
                else:
                    sql_code = answer.strip()
                
                
                f.write(sql_code)
                print("Validation SQL saved to rag_output.sql")
                
            elif output_format == "py":
                if '```python' in answer:
                    code = answer.split('```python')[1].split('```')[0].strip()
                else:
                    code = answer.strip()
                f.write(code)
                f.write(f"{answer}\n{'#'*40}\n")
            elif output_format == "java":
                if '```java' in answer:
                    code = answer.split('```java')[1].split('```')[0].strip()
                else:
                    code = answer.strip()
                f.write(code)
                f.write(f"{answer}\n{'/'*40}\n")

        
    # def create_embeddings_and_store(self):
    #     loader = DirectoryLoader(self.project_path, glob="**/*.*", loader_cls=TextLoader)
    #     documents = loader.load()
    #     if not documents:
    #         return
    #     splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    #     chunks = splitter.split_documents(documents)

    #     self.vector_db = FAISS.from_documents(chunks, self.embedding)
    #     self.vector_db.save_local(self.db_path) 
     # Add file type filtering and parallel processing
        
    def get_loader(file_path):
        if file_path.endswith('.py'):
            return PythonLoader(file_path)
        elif file_path.endswith('.json'):
            return JSONLoader(file_path)
        elif file_path.endswith('.html'):
            return BSHTMLLoader(file_path)
        else:
            return TextLoader(file_path)

    def create_embeddings_and_store(self):
        # Load documents (optimized version)
        relevant_extensions = ['.py', '.sql', '.txt', '.json', '.html', '.md']
        documents = []
        for root, _, files in os.walk(self.project_path):
            for file in files:
                if any(file.endswith(ext) for ext in relevant_extensions):
                    try:
                        loader = TextLoader(os.path.join(root, file))
                        documents.extend(loader.load())
                    except Exception as e:
                        print(f"Error loading {file}: {e}")
        
        # Split documents
        splitter = RecursiveCharacterTextSplitter(
            chunk_size=500,  # Reduced from 1000 for better performance
            chunk_overlap=50,
            length_function=len,
            is_separator_regex=False
        )
        chunks = splitter.split_documents(documents)
        
        # Create FAISS index with optimized parameters
        self.vector_db = FAISS.from_documents(
            documents=chunks,
            embedding=self.embedding,
            distance_strategy="METRIC_INNER_PRODUCT"  # Faster than L2 for many cases
        )
        
        # Save the index
        self.vector_db.save_local(self.db_path)



    def load_vector_db(self):
        self.vector_db = FAISS.load_local(
            folder_path=self.db_path,
            embeddings=self.embedding,
            allow_dangerous_deserialization=True  # Only if you trust the source
        )
    

    def query_rag_system(self):
        if not self.vector_db:
            self.load_vector_db()
        retriever = self.vector_db.as_retriever()
        
        llm = OllamaLLM(model="mistral",
                        temperature=0.1,  # Less randomness
                        top_k=10,  # Faster sampling
                        repeat_penalty=1.1  # Prevent repetition
                        )  # Use any: mistral, wizardcoder, codellama
        qa = RetrievalQA.from_chain_type(llm=llm, retriever=retriever, return_source_documents=True,chain_type_kwargs={"prompt": VALIDATION_PROMPT} )

        



        while True:
            query = input("\n🔍 Enter your question (or type 'exit'): ")
            if query.lower() in ["exit", "quit"]:
                break
            
            result = qa(query)
            answer = result["result"]
            print("\n🧠 Answer:\n", answer)

            ch = input("Do you want to save the result to file? (0 for yes, 1 for terminal): ").strip().lower()

            if ch == '0':
                self.save_to_file(answer)
            else:
                pass
