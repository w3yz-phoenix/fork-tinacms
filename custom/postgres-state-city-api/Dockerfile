FROM alpine AS git

RUN apk add --no-cache git \
  && mkdir -p /temp/export \
  && git clone https://github.com/dr5hn/countries-states-cities-database.git --depth=1 \
  && mv countries-states-cities-database/psql /temp/export \
  && rm -rf countries-states-cities-database

FROM postgres:alpine

RUN mkdir -p /temp/workspace
COPY --from=git /temp/export/psql/ /temp/workspace
COPY ./initdb.sh /docker-entrypoint-initdb.d/initdb.sh

USER postgres
