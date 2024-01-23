#!/usr/bin/env bash 

if [ -z "$2" ]; then
  echo "usage: mdbexport <service> <collection>"
  exit 1;
fi

mongoUris=$(docker service inspect -f "{{json .Spec.TaskTemplate.ContainerSpec.Env}}" $1 | jq | grep mongoUris | sed -E 's/.*=(.+)",/\1/')

if [ -z "$mongoUris" ]; then
  echo "no mongoUris found"
  exit 1;
fi

container_name="$(hostname)-export"
container_id=$(command docker ps -f "name=$container_name" --format "{{.ID}}")

echo $container_id

if [ ! -z "$container_id" ]; then
  echo "stop existing container"
  docker stop $container_id
fi

docker run --rm -i --name $container_name mongo:4.4 mongoexport --uri=$mongoUris --collection $2 --quiet
