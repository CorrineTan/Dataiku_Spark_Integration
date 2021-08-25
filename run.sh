#!/bin/bash -e

DSS_INSTALLDIR="/home/dataiku/dataiku-dss-$DSS_VERSION"

if [ ! -f "$DSS_DATADIR"/bin/env-default.sh ]; then
	# Initialize new data directory
	"$DSS_INSTALLDIR"/installer.sh -d "$DSS_DATADIR" -p "$DSS_PORT"
	"$DSS_DATADIR"/bin/dssadmin install-R-integration
	"$DSS_DATADIR"/bin/dssadmin install-spark-integration -standaloneArchive "$DKU_DIR"/"$SPARK_ARCHIVE"
	"$DSS_DATADIR"/bin/dssadmin install-hadoop-integration -standaloneArchive "$DKU_DIR"/"$HADOOP_ARCHIVE"
	echo "dku.registration.channel=docker-image" >>"$DSS_DATADIR"/config/dip.properties

elif [ $(bash -c 'source "$DSS_DATADIR"/bin/env-default.sh && echo "$DKUINSTALLDIR"') != "$DSS_INSTALLDIR" ]; then
	# Upgrade existing data directory
	"$DSS_INSTALLDIR"/installer.sh -d "$DSS_DATADIR" -u -y
	"$DSS_DATADIR"/bin/dssadmin install-R-integration
	"$DSS_DATADIR"/bin/dssadmin install-spark-integration -standaloneArchive "$DKU_DIR"/"$SPARK_ARCHIVE"
	"$DSS_DATADIR"/bin/dssadmin install-hadoop-integration -standaloneArchive "$DKU_DIR"/"$HADOOP_ARCHIVE"

fi

exec "$DSS_DATADIR"/bin/dss run
