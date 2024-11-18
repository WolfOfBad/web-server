#!/bin/bash

wait -n
docker build -t webserver -f Dockerfile.nginx .
docker run -it --rm -d -p 8080:80 --name web webserver