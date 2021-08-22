#!/bin/bash

DSS_INSTALLDIR="/home/dataiku/dataiku-dss-$DSS_VERSION"

# Run dataiku so that it creates /home/dataiku/dss folder and setup everything
echo "Running DSS"
/home/dataiku/run.sh &

# wait a few sec to be sure everything runs fine
sleep 30

# Copy JDBC jars and dependencies
mkdir -p /home/dataiku/dss/lib/jdbc
cp /home/dataiku/lib/* /home/dataiku/dss/lib/jdbc

# stop DSS
"$DSS_DATADIR"/bin/dss stop

# setting up spark
"$DSS_DATADIR"/bin/dssadmin install-spark-integration -sparkHome /opt/spark

# wait a few sec
sleep 15

# start DSS
# /home/dataiku/run.sh
"$DSS_DATADIR"/bin/dss start

# keep the container running with this hack...
tail -f /dev/null
