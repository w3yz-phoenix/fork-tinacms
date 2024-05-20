#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<- EOSQL
    CREATE DATABASE ferretdb;
    CREATE DATABASE saleor;
EOSQL

curl https://gist.githubusercontent.com/yasinuslu/753779df923b1ff70134abcd78ab99bf/raw/38b411b8a982fd12a6c963c874b2aa5fc637d438/gistfile1.txt -o /tmp/saleor-dump.sql

# replace API_FQDN with $API_FQDN
sed -i "s/API_FQDN/$API_FQDN/g" /tmp/saleor-dump.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname saleor < /tmp/saleor-dump.sql
