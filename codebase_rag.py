import os
from langchain_community.vectorstores import Chroma
#from langchain_community.embeddings import OllamaEmbeddings
#from langchain_community.llms import Ollama
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import DirectoryLoader
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import TextLoader
#from :class:`~langchain_ollama import OllamaLLM`
from langchain_ollama.embeddings import OllamaEmbeddings
from langchain_ollama.llms import OllamaLLM

import sqlglot


from langchain.prompts import PromptTemplate

VALIDATION_PROMPT = PromptTemplate.from_template("""
You are a SQL schema validator. When given a request for SQL schema validation:

1. Return ONLY the raw SQL validation code
2. No explanations, no markdown formatting, no comments
3. Just the pure SQL statements that would validate the schema

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
        with open(output_file, "a", encoding="utf-8") as f:
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
                if '```pyhton' in answer:
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

    def create_embeddings_and_store(self):
        loader = DirectoryLoader(self.project_path, glob="**/*.*", loader_cls=TextLoader) #changed to include all files
        documents = loader.load()
        splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
        chunks = splitter.split_documents(documents)
        
        self.vector_db = Chroma.from_documents(chunks, self.embedding, persist_directory=self.db_path)
        

    def load_vector_db(self):
        self.vector_db = Chroma(persist_directory=self.db_path, embedding_function=self.embedding)
    

    def query_rag_system(self):
        if not self.vector_db:
            self.load_vector_db()
        retriever = self.vector_db.as_retriever()
        
        llm = OllamaLLM(model="mistral")  # Use any: mistral, wizardcoder, codellama
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
