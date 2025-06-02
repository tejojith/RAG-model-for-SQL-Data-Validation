import sqlalchemy as sa
from sqlalchemy.dialects import mysql

metadata = sa.MetaData()
users = metadata.table('users', autoload_with=sa.inspect(engine))

validation = sa.checkconstraint(
    'username LIKE \'[a-zA-Z0-9_\-\]+$\'', 'users.username'
)
validation &= sa.checkconstraint(
    'password_hash LIKE \'[a-zA-Z0-9!@#$%^&*(),.?+-=]{8,}\'', 'users.password_hash'
)
validation &= sa.checkconstraint(
    'email LIKE \'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\'', 'users.email'
)

users.primary_key = sa.Column('user_id', sa.Integer, autoincrement=True)
users.columns['username'].unique = True
users.columns['email'].unique = True
users.columns['password_hash'].nullable = False
users.columns['first_name'].nullable = True
users.columns['last_name'].nullable = True
users.columns['date_of_birth'].nullable = True
users.columns['created_at'].default = sa.func.current_timestamp()
users.columns['last_login'].nullable = True
users.columns['is_active'].default = True
users.foreign_keys['addresses_user_id_fk'] = sa.ForeignKey('addresses.address_id')

metadata.create_all(engine)
``` ```python
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

metadata = sa.MetaData()
users = metadata.table('users', autoload_with=sa.inspect(engine))

validation = sa.checkconstraint(
    'username LIKE \'[a-zA-Z0-9_\-\]+$\'', 'users.username'
)
validation &= sa.checkconstraint(
    'password_hash LIKE \'[a-zA-Z0-9!@#$%^&*(),.?+-=]{8,}\'', 'users.password_hash'
)
validation &= sa.checkconstraint(
    'email LIKE \'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\'', 'users.email'
)

users.primary_key = sa.Column('user_id', sa.Integer, autoincrement=True)
users.columns['username'].unique = True
users.columns['email'].unique = True
users.columns['password_hash'].nullable = False
users.columns['first_name'].nullable = True
users.columns['last_name'].nullable = True
users.columns['date_of_birth'].nullable = True
users.columns['created_at'].default = sa.func.current_timestamp()
users.columns['last_login'].nullable = True
users.columns['is_active'].default = True
users.foreign_keys['addresses_user_id_fk'] = sa.ForeignKey('addresses.address_id')

metadata.create_all(engine)
```
########################################
