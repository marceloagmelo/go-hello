#!/usr/bin/env bash

source setenv.sh

echo "Criando imagem $DOCKER_REGISTRY/$CONTAINER_NAME"
docker build -t $DOCKER_REGISTRY/$CONTAINER_NAME .
