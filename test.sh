#!/bin/sh

# --- Initialize -----------------------------------------------------
set -u
umask 0022
export LC_ALL=C
export PATH="$(command -p getconf PATH 2>/dev/null)${PATH+:}${PATH-}"
case $PATH in :*) PATH=${PATH#?};; esac
export UNIX_STD=2003  # to make HP-UX conform to POSIX

ok() { echo "ok" ; }
ng() { echo "ng" ; exit 1 ; }

host=localhost
port=5432
dbname=test_migr
user=$(whoami)

# reset-table
PGPASSWORD=password \
psql  -U $user --host=localhost --port=5432 -d test_migr -c 'drop table migr;'

# remove the directory
rm -rf migr

printf "=============================================================\n"
printf "Testing migr-init\n"
printf "=============================================================\n"

printf "Execute migr-init... "

./migr-init \
    psql \
    --host=$host \
    --port=$port \
    --dbname=$dbname \
    --user=$user \
    --password=password 2>/dev/null 1>/dev/null

[ $? -eq 1 ] || ng ; ok

printf "Checking if the table migr exists in the database... "

count=$(PGPASSWORD=password psql \
    -Atq \
    -U $user \
    --host=$host \
    --port=$port \
    -d $dbname \
    -c 'SELECT count(*) FROM information_schema.tables WHERE table_name = '\''migr'\'';' )

[ $count -eq 1 ] || ng ; ok


printf "Checking if the table migr has the columns id, is_applied and created_at... "

count=$(PGPASSWORD=password psql \
    -Atq \
    -U $user \
    --host=$host \
    --port=$port \
    -d $dbname \
    -c 'SELECT count(*) FROM information_schema.columns WHERE table_name = '\''migr'\'' AND column_name = '\''id'\'';' )

[ $count -eq 1 ] || ng


count=$(PGPASSWORD=password psql \
    -Atq \
    -U $user \
    --host=$host \
    --port=$port \
    -d $dbname \
    -c 'SELECT count(*) FROM information_schema.columns WHERE table_name = '\''migr'\'' AND column_name = '\''is_applied'\'';' )

[ $count -eq 1 ] || ng

count=$(PGPASSWORD=password psql \
    -Atq \
    -U $user \
    --host=$host \
    --port=$port \
    -d $dbname \
    -c 'SELECT count(*) FROM information_schema.columns WHERE table_name = '\''migr'\'' AND column_name = '\''created_at'\'';' )

[ $count -eq 1 ] || ng ; ok


printf "Checking if the directory migr exists... "

[ -d migr ] || ng ; ok

printf "=============================================================\n"
printf "Testing migr-new\n"
printf "=============================================================\n"

printf "Execute migr-new... "

create_user_mig_files=$(./migr-new create_user)

ok

printf "Checking if the up and down migration files exist... "

create_user_up_mig_files=$(echo $create_user_mig_files | awk '{print $1}')
create_user_down_mig_files=$(echo $create_user_mig_files | awk '{print $2}')


[ -f $create_user_up_mig_files ]   || ng
[ -f $create_user_down_mig_files ] || ng

ok