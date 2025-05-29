import os

def check_for_file():
    def is_sqlite3_file(filepath):
        if not os.path.isfile(filepath):
            return False
        try:
            with open(filepath, 'rb') as f:
                header = f.read(16)
                return header == b'SQLite format 3\x00'
        except Exception:
            return False

    def find_sqlite_files_loop(base_dir):
        sqlite_files = []
        dirs_to_check = [base_dir]

        while dirs_to_check:
            current_dir = dirs_to_check.pop(0)
            try:
                for entry in os.listdir(current_dir):
                    full_path = os.path.join(current_dir, entry)
                    if os.path.isdir(full_path):
                        dirs_to_check.append(full_path)
                    elif is_sqlite3_file(full_path):
                        sqlite_files.append(full_path)
            except Exception as e:
                print(f"Error accessing {current_dir}: {e}")
        
        return sqlite_files

    # Usage
    directory_to_search = '.'  # or any specific path
    found_files = find_sqlite_files_loop(directory_to_search)

    def create_new_db():
        print("Creating a new one.")
        name = input("Enter the name of the new DB: ")
        DB_PATH = name
        return DB_PATH

    flag = True
    number = 1
    while(flag):
        if len(found_files) > 0:
            print("Found existing DB: " + found_files[0])
            number = 0
            flag = False

        else:
            print("No existing DB found")
            flag = False


    if number == 0:
        print("do you want to continue with the existing DB? (y/n)")
        if input().lower() == 'y':
            DB_PATH = found_files[0].split('\\')[1]
        else:
            DB_PATH = create_new_db()
    else:
        DB_PATH = create_new_db()

    PROJECT_PATH = "schemas"

    return PROJECT_PATH, DB_PATH

