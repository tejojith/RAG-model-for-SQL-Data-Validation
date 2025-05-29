from codebase_rag import CodebaseRAG
from rag_config import check_for_file

PROJECT_PATH, DB_PATH = check_for_file()

rag = CodebaseRAG(PROJECT_PATH, DB_PATH)


# # Validate SQL schemas
# rag.validate_sql_files()

rag.create_embeddings_and_store()   
rag.query_rag_system()

# tests = rag.generate_schema_tests("users")
# print(tests)
