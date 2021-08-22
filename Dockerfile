FROM dataiku/dss:8.0.2

MAINTAINER Corrine Tan <tenglunt@gmail.com>

USER root

RUN yum update -y && yum install -y wget

ENV SPARK_HOME /opt/spark
ENV HADOOP_HOME /etc/hadoop
ENV LIB_HOME /home/dataiku/lib/
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV HIVE_CONF_DIR /etc/hadoop/conf
ENV HADOOP_LIB_EXEC /etc/hadoop/libexec/
ENV PATH $PATH:$HADOOP_HOME/bin/:$HADOOP_HOME/sbin:$SPARK_HOME/bin

RUN wget http://apache.mirrors.tds.net/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz && \
      mkdir -p $HADOOP_HOME && \
      tar -xzf hadoop-3.2.1.tar.gz -C $HADOOP_HOME --strip-components=1

RUN wget https://archive.apache.org/dist/spark/spark-3.0.2/spark-3.0.2-bin-hadoop3.2.tgz && \
    mkdir -p $SPARK_HOME && \
    tar -xzf spark-3.0.2-bin-hadoop3.2.tgz -C $SPARK_HOME --strip-components=1

COPY run-dataiku.sh /home/dataiku
RUN chown dataiku:dataiku /home/dataiku/run-dataiku.sh && \
    chmod 777 /home/dataiku/run-dataiku.sh

USER dataiku

RUN mkdir /home/dataiku/lib/
RUN wget https://repo1.maven.org/maven2/org/apache/hive/hive-common/3.1.2/hive-common-3.1.2.jar -P $LIB_HOME && \
    wget https://repo1.maven.org/maven2/org/apache/hive/hive-jdbc/3.0.0/hive-jdbc-3.0.0.jar -P $LIB_HOME && \
    wget https://repo1.maven.org/maven2/org/apache/hive/hive-service/3.0.0/hive-service-3.0.0.jar -P $LIB_HOME && \
    wget https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.6/httpclient-4.5.6.jar -P $LIB_HOME && \
    wget https://repo1.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.10/httpcore-4.4.10.jar -P $LIB_HOME && \
    wget https://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.12.0/libthrift-0.12.0.jar -P $LIB_HOME

ENTRYPOINT ["/home/dataiku/run-dataiku.sh"]