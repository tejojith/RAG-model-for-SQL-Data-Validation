SELECT COUNT(*) FROM information_schema.columns
   WHERE table_name = 'users' AND column_name IN ('user_id', 'username', 'email', 'password_hash', 'first_name', 'last_name', 'date_of_birth', 'created_at', 'last_login', 'is_active');

   SELECT COUNT(*) FROM information_schema.keys WHERE table_name = 'users' AND column_name = 'user_id';

   SELECT COUNT(*) FROM information_schema.constraints WHERE table_name = 'users' AND constraint_type IN ('UNIQUE');

   SELECT COUNT(DISTINCT t1.constraint_name) FROM information_schema.table_constraints AS t1
   JOIN information_schema.key_column_usage AS t2 ON t1.constraint_name = t2.constraint_name AND t1.table_name = t2.table_name
   WHERE t1.table_name = 'users' AND t2.column_name IN ('username', 'email');

   SELECT COUNT(*) FROM information_schema.foreign_keys WHERE referenced_table_name = 'users';

   -- For application-level validations, these cannot be checked with SQL alone and would require additional validation logic in the application code. SELECT COUNT(*) FROM information_schema.columns
   WHERE table_name = 'users' AND column_name IN ('user_id', 'username', 'email', 'password_hash', 'first_name', 'last_name', 'date_of_birth', 'created_at', 'last_login', 'is_active');

   SELECT COUNT(*) FROM information_schema.keys WHERE table_name = 'users' AND column_name = 'user_id';

   SELECT COUNT(*) FROM information_schema.constraints WHERE table_name = 'users' AND constraint_type IN ('UNIQUE');

   SELECT COUNT(DISTINCT t1.constraint_name) FROM information_schema.table_constraints AS t1
   JOIN information_schema.key_column_usage AS t2 ON t1.constraint_name = t2.constraint_name AND t1.table_name = t2.table_name
   WHERE t1.table_name = 'users' AND t2.column_name IN ('username', 'email');

   SELECT COUNT(*) FROM information_schema.foreign_keys WHERE referenced_table_name = 'users';

   -- For application-level validations, these cannot be checked with SQL alone and would require additional validation logic in the application code.
########################################
