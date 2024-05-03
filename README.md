# migr
small command to migrate rdb schema written in posix shellscript.

# Quickstart

Suppose that you use postgres

Initialize migr by `migr-init` command.

```
$ migr-init -u postgres -d testdb -p 5432 -h localhost
```

Create new migraiton file and edit the file.

```
$ migr-new   create-user-table
create new user table at ./migr/migrations/cakstjdq2a-create-user-table.sql

$ vim ./migr/migrations/cakstjdq2a-create-user-table.sql
CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Commit the new migration file to master file.

```
$ migr-commit cakstjdq2a
```

Update your database according to the master file

```
$ migr-apply -u postgres -d testdb -p 5432 -h localhost
apply new migrations
cakstjdq2a create-user-table.sql ................. ok
```

# Usage

migr have 4 basic operation commands.

```txt
migr-init    ......................... initial setup for migr
migr-new     ......................... create new migration file
migr-commit  ......................... register new migration file to the master file
migr-apply   ......................... upgrade your database to the latest
```

TODO: Describe the each command details.