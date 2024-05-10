FROM node:alpine

WORKDIR /usr/src/app

ENV DATABASE_URL=

CMD ["npx", "pgl@beta", "-P", "pgl/amber", "-e", "-c", "${DATABASE_URL}"]
