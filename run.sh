#!/bin/bash -e

DSS_INSTALLDIR="/home/dataiku/dataiku-dss-$DSS_VERSION"

if [ ! -f "$DSS_DATADIR"/bin/env-default.sh ]; then
	echo "Initialize new data directory"
	"$DSS_INSTALLDIR"/installer.sh -d "$DSS_DATADIR" -p "$DSS_PORT"
	echo "Integration with R"
	"$DSS_DATADIR"/bin/dssadmin install-R-integration
	echo "Integration with Spark"
	"$DSS_DATADIR"/bin/dssadmin install-spark-integration -sparkHome "$SPARK_HOME"
	echo "Integration with Hadoop"
	"$DSS_DATADIR"/bin/dssadmin install-hadoop-integration -standaloneArchive "$DKU_DIR"/"$HADOOP_ARCHIVE"
	echo "dku.registration.channel=docker-image" >>"$DSS_DATADIR"/config/dip.properties

elif [ $(bash -c 'source "$DSS_DATADIR"/bin/env-default.sh && echo "$DKU_INSTALLDIR"') != "$DSS_INSTALLDIR" ]; then
	echo "Upgrade existing data directory"
	"$DSS_INSTALLDIR"/installer.sh -d "$DSS_DATADIR" -u -y
	echo "Integration with R"
	"$DSS_DATADIR"/bin/dssadmin install-R-integration
	echo "Integration with Spark"
	"$DSS_DATADIR"/bin/dssadmin install-spark-integration -sparkHome "$SPARK_HOME"
	echo "Integration with Hadoop"
	"$DSS_DATADIR"/bin/dssadmin install-hadoop-integration -standaloneArchive "$DKU_DIR"/"$HADOOP_ARCHIVE"

fi

exec "$DSS_DATADIR"/bin/dss run
