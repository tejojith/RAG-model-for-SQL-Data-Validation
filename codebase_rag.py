import os
from langchain_community.vectorstores import FAISS
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

import time
from langchain.prompts import PromptTemplate
from chunking import EnhancedChunker


VALIDATION_PROMPT = PromptTemplate.from_template("""
You are a SQL validation script generator.

Given any SQL CREATE TABLE statement, your task is to generate a validation test SQL script that performs the following:

1. Use transactions (START TRANSACTION/ROLLBACK) for each test case
2. Include explicit verification SELECTs after each operation
3. Test all constraints (UNIQUE on all applicable columns)
4. Verify DEFAULT values work correctly
5. Include data type specific tests (DATE, TIMESTAMP, etc.)
6. Drops the table if it already exists.
7. Recreates the table exactly as provided.
8. Inserts a valid row with values for all NOT NULL fields.
9. Attempts to insert a row that violates any UNIQUE constraint (e.g., same username or email).
10. Attempts to insert a row that violates any NOT NULL constraint (by omitting a NOT NULL field or inserting NULL).
11. Inserts a second valid row with minimal fields (if defaults are present).
12. Includes a SELECT query to verify that default values (e.g., timestamps, booleans) are applied.
13. Ends with a SELECT * query to show the current state of the table.
14. Follows this exact structure:
                                                              
-- Test Case [N]: [Description]
START TRANSACTION;
[Test SQL]
[Verification SQL]
ROLLBACK;

For each test case:
- Include comments explaining the test
- Use ON DUPLICATE KEY UPDATE for expected failures
- Output a clear pass/fail message
- Keep tests independent

Special requirements:
- MySQL syntax
- Test all columns systematically
- Include edge cases

Important:
- Output must be **pure SQL only**.
- Do **not include** any explanations, comments, or markdown.
- Output must be executable in MySQL or compatible engines.

Here is the SQL table definition:
{context}

User Query:
{question}
                              

Now generate the full SQL test script as per the above instructions.


""")

#Output Mode: {mode}


class CodebaseRAG:
    def __init__(self, project_path, db_path):
        self.project_path = project_path
        self.db_path = db_path
        self.embed_model = "nomic-embed-text"  # or mxbai-embed-large for code
        
        self.embedding = OllamaEmbeddings(model=self.embed_model)
         # imported all the chunking functions
        self.chunker = EnhancedChunker(self.embedding)
        self.vector_db = None

    def save_to_file(self, answer):
        output_format = input("Choose a format to save results (e.g. sql, py): ").strip().lower()
        valid_formats = ["txt", "sql", "py", "java"]
        if output_format not in valid_formats:
            print(f"Invalid format. Defaulting to 'txt'")
            output_format = "txt"


        name = input("Enter a name for the output file (without extension): ").strip()
        if not name:
            output_file = f"rag_output.{output_format}"
        else:
            output_file = f"{name}_rag_output.{output_format}"

        with open(output_file, "w", encoding="utf-8") as f:
            if output_format == "txt":
                f.write(f"{answer}\n{'-'*40}\n")
            elif output_format == "sql":
                if '```sql' in answer:
                    sql_code = answer.split('```sql')[1].split('```')[0].strip()
                else:
                    sql_code = answer.strip()
                
                
                f.write(sql_code)
                print(f"{name}_rag_output.{output_format}")
                
            elif output_format == "py":
                if '```python' in answer:
                    code = answer.split('```python')[1].split('```')[0].strip()
                else:
                    code = answer.strip()
                f.write(code)
            elif output_format == "java":
                if '```java' in answer:
                    code = answer.split('```java')[1].split('```')[0].strip()
                else:
                    code = answer.strip()
                f.write(code)
        
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
                        file_path = os.path.join(root, file)
                        loader = TextLoader(file_path)
                        loaded_docs = loader.load()
                        
                        for doc in loaded_docs:
                            doc.metadata["source_file"] = os.path.basename(file_path)
                            doc.metadata["file_extension"] = os.path.splitext(file_path)[1]
                        
                        documents.extend(loaded_docs)
                    except Exception as e:
                        print(f"Error loading {file}: {e}")

        
        # Split documents
        # splitter = RecursiveCharacterTextSplitter(
        #     chunk_size=500,  # Reduced from 1000 for better performance
        #     chunk_overlap=50,
        #     length_function=len,
        #     is_separator_regex=False
        # )
        # chunks = splitter.split_documents(documents)

        #updated splitting and chunking

        chunks = self.chunker.smart_chunk_documents(documents)
        
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
    def select_llm_for_query(query: str):
        if "code" in query.lower() or "sql" in query.lower() or "generate" in query.lower():
            return "codellama"
        elif len(query) > 300 or "explain" in query.lower():
            return "llama3"
        else:
            return "mistral"    

    def query_rag_system(self):
        if not self.vector_db:
            self.load_vector_db()
        retriever = self.vector_db.as_retriever()
        llm = OllamaLLM(model="codellama:7b",
                        temperature=0.1,  # Less randomness
                        top_k=10,  # Faster sampling
                        repeat_penalty=1.1  # Prevent repetition
                        )  # Use any: mistral, wizardcoder, codellama
        qa = RetrievalQA.from_chain_type(llm=llm, retriever=retriever, return_source_documents=True,chain_type_kwargs={"prompt": VALIDATION_PROMPT} )





        while True:
            query = input("\n🔍 Enter your question (or type 'exit'): ")
            if query.lower() in ["exit", "quit"]:
                break

            start_time = time.time()
            
            result = qa(query)
            answer = result["result"]
            print("\n🧠 Answer:\n", answer)
            end_time = time.time()
            elapsed_time = end_time - start_time
            print(f"Time taken: {elapsed_time:.4f} seconds")

            ch = input("Do you want to save the result to file? (0 for yes, 1 for terminal): ").strip().lower()

            if ch == '0':
                self.save_to_file(answer)
            else:
                pass
