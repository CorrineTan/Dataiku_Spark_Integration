FROM dataiku/dss:8.0.2

USER root

ENV SPARK_ARCHIVE "dataiku-dss-spark-standalone-8.0.7-2.4.5-generic-hadoop3.tar.gz"
ENV SPARK_URL "https://downloads.dataiku.com/public/dss/8.0.7/${SPARK_ARCHIVE}"


RUN yum install wget -y
RUN wget $SPARK_URL

WORKDIR /home/dataiku
USER dataiku

COPY run.sh /home/dataiku/

EXPOSE $DSS_PORT

RUN chmod +x /home/dataiku/run.sh
CMD [ "/home/dataiku/run.sh" ]