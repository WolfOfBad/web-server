#!/bin/bash

wait -n
docker stop web
docker rmi webserver