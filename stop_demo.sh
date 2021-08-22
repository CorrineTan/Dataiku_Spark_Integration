#!/bin/bash

DOCKER_COMPOSE_FILE=docker-compose.yml

SCRIPT_PATH=$(cd `dirname $0`; pwd)
echo SCRIPT_PATH
docker-compose -f ${SCRIPT_PATH}/${DOCKER_COMPOSE_FILE} down

