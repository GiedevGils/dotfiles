#!usr/bin/env bash

if [ -z "$3" ]; then
  echo "usage: mdbimport <service> <collection> <filename>"
  exit 1;
fi

mongoUris=$(docker service inspect -f "{{json .Spec.TaskTemplate.ContainerSpec.Env}}" $1 | jq | grep mongoUris | sed -E 's/.*=(.+)",/\1/')

if [ -z "$mongoUris"]; then
  echo "no mongoUris found"
  exit 1;
fi

container_name="$(hostname)-import"
container_id=$(command docker ps -f "name=$container_name" --format "{{.ID}}")
echo "id: $container_id"

if [ ! -z "$container_id" ]; then
  echo "stop existing container"
  docker stop $container_id
fi

read -p "remove all documents from  collection '$2' (y/n) " yn
if [ $yn = "y" ]; then
  docker run --rm -t --name $container_name mongo:4.4 mongo $mongoUris --eval "db.$2.remove({})" 
fi

read -p "import documents from file '$3' into collection '$2' (yn) " yn
if [ "$yn" = "y" ]; then
docker run --rm -i --name $container_name mongo:4.4 mongoimport --uri=$mongoUris --collection $2 < $3
fi

