#!/bin/bash


export SPARK_HOME=${SPARK_HOME:-/opt/spark}

echo SPARK_HISTORY_FS_LOG_DIRECTORY = ${SPARK_HISTORY_FS_LOG_DIRECTORY}
mkdir -p $SPARK_LOG_DIR
mkdir -p $SPARK_HISTORY_FS_LOG_DIRECTORY
touch $SPARK_HOME/conf/spark-defaults.conf
echo spark.eventLog.enabled ${SPARK_EVENTLOG_ENABLED} >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.fs.logDirectory ${SPARK_HISTORY_FS_LOG_DIRECTORY}  >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.eventLog.dir ${SPARK_HISTORY_FS_LOG_DIRECTORY}  >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.store.maxDiskUsage ${SPARK_HISTORY_STORE_MAXDIXUSAGE} >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.ui.port ${SPARK_HISTORY_UI_PORT}  >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.fs.cleaner.enabled ${SPARK_HISTORY_FS_CLEANER_ENABLED} >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.fs.cleaner.maxAge ${SPARK_HISTORY_FS_CLEANER_MAXAGE} >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.fs.update.interval ${SPARK_HISTORY_FS_UPDATE_INTERVAL} >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.retainedApplications ${SPARK_HISTORY_RETAINED_APPLICATIONS} >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.history.ui.maxApplications ${SPARK_HISTORY_UI_MAXAPPLICATIONS} >> ${SPARK_HOME}/conf/spark-defaults.conf
echo AQUIIIII
echo spark.ui.enabled true >> ${SPARK_HOME}/conf/spark-defaults.conf
echo spark.ui.port 4040 >> ${SPARK_HOME}/conf/spark-defaults.conf

cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
echo "SPARK_DAEMON_MEMORY=${SPARK_DAEMON_MEMORY}" >>$SPARK_HOME/conf/spark-env.sh

export HEAP_DUMP_PATH=$SPARK_LOG_DIR/HistoryHeapDump_$SPARK_HISTORY_UI_PORT
export LOG_GC_PATH=$SPARK_LOG_DIR/SparkHistoryServer_GC_$SPARK_HISTORY_UI_PORT.log

export SPARK_HISTORY_OPTS="${SPARK_HISTORY_OPTS} -XX:+IgnoreUnrecognizedVMOptions -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$HEAP_DUMP_PATH -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:$LOG_GC_PATH"
echo "SPARK_ROLE: $SPARK_ROLE"

if [ "$SPARK_ROLE" == "master" ];
then
    /bin/bash /start-hdfs.sh
    echo "*****Después de iniciar hdfs"
    until hdfs dfsadmin -safemode get | grep -q "Safe mode is OFF"; do
      echo "Esperando a que HDFS esté listo..."
      sleep 5
    done
	  /opt/spark/sbin/start-master.sh -p 7077 
    echo "*****Después de iniciar spark-master"
    /opt/spark/sbin/start-history-server.sh 
    echo "*****Después de iniciar history-server"
elif [ "$SPARK_ROLE" == "worker" ];
then
  echo "antes de iniciar el worker"
  /opt/spark/sbin/start-worker.sh spark://spark-master:7077 
  hdfs datanode
  echo "después de iniciar el worker"
elif [ "$SPARK_ROLE" == "history" ]
then
  /opt/spark/sbin/start-history-server.sh 
fi

while true; do
  sleep 60
done