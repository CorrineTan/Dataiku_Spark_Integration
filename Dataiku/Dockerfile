FROM dataiku/dss:8.0.2

USER root

ENV SPARK_ARCHIVE = "dataiku-dss-spark-standalone-8.0.7-2.4.5-generic-hadoop3.tar.gz"
ENV SPARK_URL = "https://downloads.dataiku.com/public/dss/8.0.7/$SPARK_ARCHIVE"

RUN wget $SPARK_URL

WORKDIR /home/dataiku
USER dataiku

ENV SPARK_HOME = "home/dataiku/dss/bin"
ENV DKU_ADMIN = "/home/dataiku/dss/bin/dssadmin"

RUN $DKU_ADMIN install-spark-integration -sparkHome $SPARK_HOME -standaloneArchive $SPARK_ARCHIVE

COPY run.sh /home/dataiku/

EXPOSE $DSS_PORT

CMD [ "/home/dataiku/run.sh" ]