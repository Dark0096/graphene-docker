#!/bin/bash

#################################
#       Set program name        #
#################################
export PROGRAM_NAME=graphene-reader

#################################
#   Resolve confd template      #
#################################
mkdir -p /etc/${PROGRAM_NAME}
confd --onetime --backend env

##################################
##    Make graphene directory    #
##################################
export GRAPHENE_CONF_DIR=${GRAPHENE_CONF_DIR:-"/graphene/conf"}
export GRAPHENE_DATA_DIR=${GRAPHENE_DATA_DIR:-"/graphene/data"}
export GRAPHENE_LOG_DIR=${GRAPHENE_LOG_DIR:-"/graphene/log"}
export GRAPHENE_PROGRAM_DIR=${GRAPHENE_PROGRAM_DIR:-"/graphene/program"}

mkdir -p ${GRAPHENE_CONF_DIR}
mkdir -p ${GRAPHENE_DATA_DIR}
mkdir -p ${GRAPHENE_LOG_DIR}
mkdir -p ${GRAPHENE_PROGRAM_DIR}

#################################
#   Move to graphene directory  #
#################################
mv /etc/graphene-reader/application.yml ${GRAPHENE_CONF_DIR}/application.yml
mv /tmp/graphene/graphene-reader/build/libs/graphene-reader-${GRAPHENE_VERSION}.jar ${GRAPHENE_PROGRAM_DIR}/

#################################
#        Resolve HOST IP        #
#################################
export HOST_IP=$(curl --silent --connect-timeout 3 "http://169.254.169.254/latest/meta-data/local-ipv4")

if [ $? -ne 0 ]; then
    HOST_IP="127.0.0.1"
fi

#################################
#         Resolve HOST NAME     #
#################################
export HOST_NAME=$(curl --silent --connect-timeout 3 "http://169.254.169.254/latest/meta-data/instance-id")

if [ $? -ne 0 ]; then
    HOST_NAME="localhost"
fi

#################################
#         Set Heap Option       #
#################################
export GRAPHENE_HEAP_OPTS=${GRAPHENE_HEAP_OPTS:-"-Xmx1G -Xms1G"}

#################################
#   Execute graphene process    #
#################################
if [[ -z "$1" ]];
then
  # https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html
  exec java $GRAPHENE_HEAP_OPTS -jar ${GRAPHENE_PROGRAM_DIR}/${PROGRAM_NAME}-${GRAPHENE_VERSION}.jar --spring.config.location=file:${GRAPHENE_CONF_DIR}/application.yml >> ${GRAPHENE_LOG_DIR}/${PROGRAM_NAME}.log 2>&1
else
  exec "$@"
fi
