#!/bin/bash

DSS_INSTALLDIR="/home/dataiku/dataiku-dss-$DSS_VERSION"
DSS_DATADIR="/home/dataiku/dss"
DKU_DIR="/home/dataiku"
SPARK_HOME="/opt/spark"

echo "Running DSS Now!"
"$DKU_DIR"/run.sh &

echo "Waiting for everything setting up"
sleep 10

echo "Copy JDBC jars and dependencies"
mkdir -p "$DSS_DATADIR"/lib/jdbc
cp "$DKU_DIR"/lib/* "$DSS_DATADIR"/lib/jdbc

echo "DSS stop now"
"$DSS_DATADIR"/bin/dss stop

echo "Setting up Spark Integration"
"$DSS_DATADIR"/bin/dssadmin install-spark-integration -sparkHome "$SPARK_HOME"

# Wait for spark setup
sleep 10

"$DSS_DATADIR"/bin/dss start
echo "DSS restart now"

# Keep the container running
tail -f /dev/null
