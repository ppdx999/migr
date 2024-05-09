# migr
small command to migrate rdb schema written in posix shellscript.

# Quickstart

Suppose that you use postgres

Initialize migr by `migr-init` command.

```
$ migr-init psql --dbname=testdb
```

Create new migraiton file and edit the file.

```
$ migr-new create_user
create new user table at ./migr/1715215123-9o7di3gts3-create_user-up.sql
create new user table at ./migr/1715215123-9o7di3gts3-create_user-down.sql

$ vim ./migr/1715215123-9o7di3gts3-create_user-up.sql
CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Update your database according to the master file

```
$ migr-up psql -dbname=testdb
apply new migrations
1715215123 9o7di3gts3 create_user ................ ok
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

```txt
migr-init     ........................ initial setup for migr
migr-new      ........................ create new migration file
migr-up       ........................ upgrade your database to the latest
migr-cancel   ........................ cancel the most latest migration
migr-status   ........................ print migr's status
```

# Install

copy `migr-init` `migr-new` `migr-up` `migr-cancel` and `migr-status` to your project

# Warning

`migr` only support postgresql for now

# Requirement

This software run on posix environment

# License

Complete Public-Domain Software (CC0)

It means that all of the people can use this for any purposes with no restrictions at all. By the way, We are fed up with the side effects which are brought about by the major licenses.