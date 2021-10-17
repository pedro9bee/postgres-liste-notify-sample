Postgres Communication

This sample application shows two ways to Postgres communicate outside with node.js

The first one use Listen and Notify feature with pg-listen package.

The second one show how to create one simple Postgres Function to call one HTTP request.

sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Docker image

docker run -p 5433:5432 -d \
-e POSTGRES_USER="objectrocket" \
-e POSTGRES_PASSWORD="1234" \
-e POSTGRES_DB="some_db" \
-v ${PWD}/pg-data:/var/lib/postgresql/data \
--name pg-container \
postgres

# To List All Dockers

docker ps

# Connect to the docker

docker exec -it 1e6 bin/bash

REFERENCES:
https://tapoueh.org/blog/2018/06/postgresql-concurrency-data-modification-language/
https://tapoueh.org/blog/2018/07/computing-and-caching/
https://tapoueh.org/blog/2018/07/postgresql-listen-notify/
https://imasters.com.br/back-end/construindo-um-cliente-http-em-postgresql-com-plpython
