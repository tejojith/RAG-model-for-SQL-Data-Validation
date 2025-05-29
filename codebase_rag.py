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
You are a helpful assistant that answers developer queries using schema and document context.
You need to provide accurate and concise answers based on the provided context.
You will be given a context that includes code snippets, documentation, and other relevant information.
Your task is to give test case validation based on the context and the user's question.
You will be provided with a context and a question.

Follow these strict rules:
- Give only the schema and no context, until it is explicitly asked for.                                                 
- If the output is for the terminal, include a clear answer and reasoning.
- If the output is for a file (e.g., .py, .sql, .java), return only the raw code/content the user asked for. No greetings, no explanations, no comments unless the user asked for them.
- Be concise and return only what is necessary for the selected mode.

---

Context:
{context}

---

User Query:
{question}


Your response:

""")


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
                f.write(f"{answer}\n{'-'*40}\n")
            elif output_format == "py":
                f.write(f"{answer}\n{'#'*40}\n")
            elif output_format == "java":
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
            ch = input("Do you want to save the results or show it here? (0/1): ").strip().lower()
            if(ch == '0'):
                answer = result["result"]
                self.save_to_file(result["result"])
            else:    
                print("\n🧠 Answer:", result["result"])

