FROM denvazh/scala:2.11.8-openjdk8

ARG FLINK_VERSION=1.10.0
ARG SCALA_BINARY_VERSION=2.11

ENV FLINK_INSTALL_PATH /opt
ENV FLINK_HOME $FLINK_INSTALL_PATH/flink
ENV PATH $PATH:$FLINK_HOME/bin

RUN set -x && \
    mkdir -p ${FLINK_INSTALL_PATH} && \
    apk --update add --virtual curl
ADD flink-${FLINK_VERSION}-bin-scala_${SCALA_BINARY_VERSION}.tgz ${FLINK_INSTALL_PATH}
RUN set -x && ln -s ${FLINK_INSTALL_PATH}/flink-${FLINK_VERSION} ${FLINK_HOME} && \
    #curl $(curl -s https://www.apache.org/dyn/closer.cgi/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_${SCALA_BINARY_VERSION}.tgz\?preferred\=true)flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_${SCALA_BINARY_VERSION}.tgz | \
    #tar xz -C ${FLINK_INSTALL_PATH} && \
    #ln -s ${FLINK_INSTALL_PATH}/flink-${FLINK_VERSION} ${FLINK_HOME} && \
    sed -i -e "s/echo \$mypid >> \$pid/echo \$mypid >> \$pid \&\& wait/g" ${FLINK_HOME}/bin/flink-daemon.sh && \
    sed -i -e "s/ > \"\$out\" 2>&1 < \/dev\/null//g" ${FLINK_HOME}/bin/flink-daemon.sh && \
    rm -rf /var/cache/apk/* && \
    echo Installed Flink ${FLINK_VERSION} to ${FLINK_HOME}

ADD docker-entrypoint.sh ${FLINK_HOME}/bin/
# Additional output to console, allows gettings logs with 'docker-compose logs'
ADD log4j.properties ${FLINK_HOME}/conf/

ENTRYPOINT /bin/bash
#ENTRYPOINT ["docker-entrypoint.sh"]
#CMD ["sh", "-c"]
