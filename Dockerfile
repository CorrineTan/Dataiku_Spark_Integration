FROM centos:7

MAINTAINER Corrine Tan <tenglunt@gmail.com>

ARG dssVersion=9.0.4

ENV DSS_VERSION="$dssVersion" \
    DSS_DATADIR="/home/dataiku/dss" \
    DSS_PORT=10000

# Dataiku account and data dir setup
RUN useradd dataiku \
    && mkdir -p /home/dataiku ${DSS_DATADIR} \
    && chown -Rh dataiku:dataiku /home/dataiku ${DSS_DATADIR}

# System dependencies
RUN yum install -y -q \
        epel-release \
    && yum install -y -q \
        wget \
        file \
        acl \
        expat \
        git \
        nginx \
        unzip \
        zip \
        java-1.8.0-openjdk \
        python3 \
        freetype \
        libgfortran \
        libgomp \
        R-core-devel \
        libicu-devel \
        libcurl-devel \
        openssl-devel \
        libxml2-devel \
        python-devel \
        python3-devel \
    && yum clean all

# Download and extract DSS kit
RUN DSSKIT="dataiku-dss-$DSS_VERSION" \
    && cd /home/dataiku \
    && echo "+ Downloading kit" \
    && curl -OsS "https://cdn.downloads.dataiku.com/public/studio/$DSS_VERSION/$DSSKIT.tar.gz" \
    && echo "+ Extracting kit" \
    && tar xf "$DSSKIT.tar.gz" \
    && rm "$DSSKIT.tar.gz" \
    && "$DSSKIT"/scripts/install/installdir-postinstall.sh "$DSSKIT" \
    && chown -Rh dataiku:dataiku "$DSSKIT"

# Install required R packages
RUN mkdir -p /usr/local/lib/R/site-library \
    && R --slave --no-restore --quiet \
        -e "install.packages( \
            c('httr', 'RJSONIO', 'dplyr', 'curl', 'IRkernel', 'sparklyr', 'ggplot2', 'gtools', 'tidyr', \
            'rmarkdown', 'base64enc', 'filelock'), \
            '/usr/local/lib/R/site-library', \
            repos='http://cloud.r-project.org')"

USER root

ENV SPARK_ARCHIVE "spark-3.0.1-bin-hadoop3.2.tgz"
ENV SPARK_URL "https://archive.apache.org/dist/spark/spark-3.0.1/${SPARK_ARCHIVE}"
ENV HADOOP_ARCHIVE "dataiku-dss-hadoop-standalone-libs-generic-hadoop3-9.0.4.tar.gz"
ENV HADOOP_URL "https://downloads.dataiku.com/public/dss/9.0.4/${HADOOP_ARCHIVE}"
ENV SPARK_HOME /opt/spark

# Downlaod hadoop standalone archive and spark pre-build binaries
RUN wget -nv "$HADOOP_URL" 

RUN wget -nv "$SPARK_URL" \
    && mkdir -p $SPARK_HOME \
    && tar -xzf "$SPARK_ARCHIVE" -C $SPARK_HOME --strip-components=1 \
    && rm "$SPARK_ARCHIVE"

WORKDIR /home/dataiku
USER dataiku

# ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre/
ENV PATH $PATH:$SPARK_HOME/bin
ENV DKU_DIR /home/dataiku

COPY run.sh /home/dataiku/

EXPOSE $DSS_PORT

ENTRYPOINT [ "/home/dataiku/run.sh" ]