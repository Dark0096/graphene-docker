FROM gradle:5.5.1-jdk8

#################################
#         Program version       #
#################################
ENV GRAPHENE_VERSION=1.0.9
ENV CONFD_VERSION=0.11.0

#################################
#         Utility tools         #
#################################
WORKDIR /bin

RUN wget https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -O confd && \
    chmod +x confd

##################################
##    Graphene binary install    #
##################################
WORKDIR /tmp

RUN git clone https://github.com/Dark0096/graphene

##################################
##         Graphene build        #
##################################
WORKDIR /tmp/graphene/graphene-reader

RUN gradle bootjar
##################################
##  Config & Entrypoint script   #
##################################
WORKDIR /woowa

ADD scripts/ /bin/
ADD confd /etc/confd

ENTRYPOINT ["/bin/entrypoint.sh"]
