> [!WARNING]
> This project is working on progress.

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

# Why?
Currently, there are numerous database migration tools available, such as [MyBatis Migration](https://github.com/mybatis/migrations), [liquibase](https://github.com/liquibase/liquibase), [Flyway](https://github.com/flyway/flyway), [phpmig](https://github.com/davedevelopment/phpmig), [migrate](https://github.com/golang-migrate/migrate) ...

All these projects boast impressive features like supporting multiple databases, defining original DSL, and schema auto-generation, among others. So why would I create a new, less-featured, slow, and clumsy migration tool?

To address this question, let me pose a few of my own:

- How long do you expect your data to remain relevant? More than 10 years? 50 years? Perhaps even a century? If so, can you confidently affirm that these migration tools will endure beyond the lifespan of your data?
- Should the maintainers of these tools abandon the project, are you equipped to step in and manage it independently to ensure the continuity of your data for future migrations?
- Is your project truly in need of these advanced features?

If your response to all these inquiries is a resounding "yes," then migr might not be the most suitable option for you. Instead, you might want to consider opting for more comprehensive and high-quality migration tools. However, if not, migr could present itself as a viable choice due to its simplicity and ease of personal maintenance.

# Usage

migr have 4 basic operation commands.

```txt
migr-init    ......................... initial setup for migr
migr-new     ......................... create new migration file
migr-up      ......................... upgrade your database to the latest
migr-redo    ......................... redo latest migration
```

## migr-init

- create migration management table to your database.
- create a dir locally to store migration files.

## migr-new

- create new migration file
- its file name structure is `{timestamp}_{id}_{up|down}_{title}.sql`

## migr-up

- upgrade your database to the latest

## migr-redo

- apply latest down-migration, then apply latest up-migration