FROM dataiku/dss:8.0.2

USER root

ENV ENABLE_INIT_DAEMON true
ENV INIT_DAEMON_BASE_URI http://identifier/init-daemon
ENV INIT_DAEMON_STEP spark_master_init
ENV SPARK_VERSION "3.1.1"
ENV HADOOP_VERSION "3.2"
ENV SPARK_ARCHIVE "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
ENV SPARK_URL "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

COPY wait-for-step.sh /
COPY execute-step.sh /
COPY finish-step.sh /


RUN apk add --no-cache curl bash openjdk8-jre python3 py-pip nss libc6-compat \
      && ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2 \
      && chmod +x *.sh \
      && wget ${SPARK_URL}
      && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && cd /

RUN chmod +x /wait-for-step.sh && chmod +x /execute-step.sh && chmod +x /finish-step.sh
ENV PYTHONHASHSEED 1


RUN yum install wget -y
RUN wget $SPARK_URL


WORKDIR /home/dataiku
USER dataiku

COPY run.sh /home/dataiku/

EXPOSE $DSS_PORT

USER root
RUN chmod +x /home/dataiku/run.sh

USER dataiku
CMD [ "/home/dataiku/run.sh" ]