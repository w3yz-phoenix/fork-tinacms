#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<- EOSQL
    CREATE DATABASE ferretdb;
    CREATE DATABASE saleor;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname saleor < /tmp/saleor-dump.sql
