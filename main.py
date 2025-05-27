from codebase_rag import CodebaseRAG
from rag_config import PROJECT_PATH, DB_PATH

rag = CodebaseRAG(PROJECT_PATH, DB_PATH)
rag.create_embeddings_and_store()   # Run this once
rag.query_rag_system()
