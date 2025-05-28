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

# VALIDATION_PROMPT = PromptTemplate.from_template("""
# """)


class CodebaseRAG:
    def __init__(self, project_path, db_path):
        self.project_path = project_path
        self.db_path = db_path
        self.embed_model = "nomic-embed-text"  # or mxbai-embed-large for code
        self.embedding = OllamaEmbeddings(model=self.embed_model)
        self.vector_db = None

    def create_embeddings_and_store(self):
        loader = DirectoryLoader(self.project_path, glob="**/*.*", loader_cls=TextLoader) #changed to include all files
        documents = loader.load()
        splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
        chunks = splitter.split_documents(documents)
        
        self.vector_db = Chroma.from_documents(chunks, self.embedding, persist_directory=self.db_path)
        

    def load_vector_db(self):
        self.vector_db = Chroma(persist_directory=self.db_path, embedding_function=self.embedding)
    
    # def validate_sql_files(self):
    #     print("\n🔍 Running schema validation using sqlglot:\n")

    #     for root, _, files in os.walk(self.project_path):
    #         for file in files:
    #             if file.endswith(".sql"):
    #                 file_path = os.path.join(root, file)
    #                 with open(file_path, "r", encoding="utf-8") as f:
    #                     sql_code = f.read()

    #                 try:
    #                     parsed = sqlglot.parse_one(sql_code, read="mysql")
    #                     has_primary_key = False

    #                     if "PRIMARY KEY" in sql_code.upper():
    #                         has_primary_key = True
    #                     else:
    #                         # More thorough check of parsed structure
    #                         for pk in parsed.find_all(sqlglot.expressions.PrimaryKey):
    #                             has_primary_key = True
    #                             break

    #                     if has_primary_key:
    #                         print(f"{file} — VALID (PRIMARY KEY present)")
    #                     else:
    #                         print(f"{file} — INVALID (No PRIMARY KEY found)")
    #                 except Exception as e:
    #                     print(f"⚠️ {file} — PARSE ERROR: {str(e)}")

    


    def query_rag_system(self):
        if not self.vector_db:
            self.load_vector_db()
        retriever = self.vector_db.as_retriever()
        
        llm = OllamaLLM(model="mistral")  # Use any: mistral, wizardcoder, codellama
        qa = RetrievalQA.from_chain_type(llm=llm, retriever=retriever, return_source_documents=True)

        #,chain_type_kwargs={"prompt": VALIDATION_PROMPT} this is for prompt template
        
        while True:
            query = input("\n🔍 Enter your question (or type 'exit'): ")
            if query.lower() in ["exit", "quit"]:
                break
            result = qa(query)
            print("\n🧠 Answer:", result["result"])
