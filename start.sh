#!/bin/bash

if [ ! -z ${NETWORK+x} ]
then
    COMMAND="docker network create $NETWORK"
    echo $COMMAND
    $COMMAND >/dev/null
    COMMAND="docker-compose -f docker-compose.yml up --build"
    echo $COMMAND
    $COMMAND
else
    echo "env NETWORK is undefined"
fi