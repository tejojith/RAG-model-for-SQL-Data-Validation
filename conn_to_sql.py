import subprocess
import mysql.connector
from mysql.connector import errorcode

class MySQLValidator:
    def __init__(self, host, user, password, database):
        self.db_config = {
            'host': host,
            'user': user,
            'password': password,
            'database': database
        }
        self.connection = None

    def connect(self):
        try:
            self.connection = mysql.connector.connect(**self.db_config)
            return True
        except mysql.connector.Error as err:
            print(f"Database connection failed: {err}")
            return False

    def execute_validation_script(self, script_path):
        if not self.connect():
            return False
            
        try:
            with open(script_path, 'r') as file:
                sql_script = file.read()
            
            cursor = self.connection.cursor(dictionary=True)
            
            # Split into individual statements
            statements = [stmt.strip() for stmt in sql_script.split(';') if stmt.strip()]
            
            results = []
            for stmt in statements:
                try:
                    cursor.execute(stmt)
                    if stmt.lstrip().upper().startswith(('SELECT', 'SHOW', 'DESCRIBE')):
                        results.append(cursor.fetchall())
                except mysql.connector.Error as err:
                    results.append(f"ERROR: {err.msg}")
            
            return results
        finally:
            if self.connection:
                self.connection.close()

    def validate_schema(self, test_script_path):
        results = self.execute_validation_script(test_script_path)
        
        # Parse results
        validation_report = {
            'total_tests': 0,
            'passed': 0,
            'failed': 0,
            'details': []
        }
        
        for result in results:
            if isinstance(result, list):
                for row in result:
                    if 'PASS:' in str(row):
                        validation_report['passed'] += 1
                        validation_report['total_tests'] += 1
                    elif 'FAIL:' in str(row):
                        validation_report['failed'] += 1
                        validation_report['total_tests'] += 1
                    validation_report['details'].append(row)
        
        return validation_report