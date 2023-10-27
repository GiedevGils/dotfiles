#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "usage: mdbd <service>"
fi


mongoUris=$(docker service inspect -f "{{json .Spec.TaskTemplate.ContainerSpec.Env}}" $1 | jq | grep mongoUris | sed -E 's/.*=(.+)",/\1/')

container_id=$(command docker ps -f "name=$(hostname)" --format "{{.ID}}")

if [ -z "$container_id" ]; then
  echo "starting new container"
  echo "detach with C-p,C-q"
  docker run --rm -it --name $(hostname) rtsp/mongosh:latest mongosh $mongoUris
else
  echo "attach to existing container"
  echo "detach with C-p,C-q"
  docker attach "$container_id"
fi

