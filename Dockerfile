# Utilizamos Debian 11 como imagen base
FROM debian:12

# Actualizamos el sistema y instalamos las dependencias necesarias
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    curl \
    gpg \
    nano \
    python3 \
    procps \
    && apt-get clean


ARG USERNAME=jupyter
ARG GROUPNAME=jupyter
ARG UID=1001
ARG GID=1001
    
# Hadoop
ARG HADOOP_VERSION=3.3.6
ARG HADOOP_URL=https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ARG HADOOP_FILE=hadoop-$HADOOP_VERSION.tar.gz
ARG HADOOP_HOME=/opt/hadoop
RUN echo Hadoop URL: $HADOOP_URL && echo Hadoop file: $HADOOP_FILE
RUN wget -q $HADOOP_URL \
    && mkdir $HADOOP_HOME \
    && tar -xzf $HADOOP_FILE -C $HADOOP_HOME --strip-components 1 \
    && mkdir $HADOOP_HOME/logs \ 
    && rm $HADOOP_FILE

# RUN set -x \
# && curl -fsSL https://archive.apache.org/dist/hadoop/common/KEYS -o /tmp/hadoop-KEYS \
#  && gpg --import /tmp/hadoop-KEYS \
#  && sudo mkdir $HADOOP_HOME  \
#  && sudo chown $USERNAME:$GROUPNAME -R $HADOOP_HOME \
#  && curl -fsSL $HADOOP_URL -o /tmp/hadoop.tar.gz \
#  && curl -fsSL $HADOOP_URL.asc -o /tmp/hadoop.tar.gz.asc \
# && gpg --verify /tmp/hadoop.tar.gz.asc \
# && tar -xf /tmp/hadoop.tar.gz -C $HADOOP_HOME --strip-components 1 \
# && mkdir $HADOOP_HOME/logs \
#  && rm /tmp/hadoop*



# Spark 
ARG SPARK_VERSION=3.5.5
ARG SPARK_FILE=spark-3.5.5-bin-hadoop3.tgz
ARG SPARK_URL=https://downloads.apache.org/spark/spark-$SPARK_VERSION/$SPARK_FILE
ARG SPARK_HOME=/opt/spark
RUN wget -q $SPARK_URL   && \
    mkdir $SPARK_HOME && \
    tar -xzf $SPARK_FILE   -C $SPARK_HOME --strip-components 1 && \
    rm $SPARK_FILE

# variables de entorno
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 
ENV SPARK_HOME=/opt/spark 
ENV SPARK_VERSION=3.5.0
ENV SPARK_CONF=${SPARK_HOME}/conf 
ENV SPARK_LOG_DIR=/var/log/spark 
ENV SPARK_HISTORY_UI_PORT=18080 
ENV SPARK_EVENTLOG_ENABLED=true 
ENV SPARK_HISTORY_FS_LOG_DIRECTORY=/opt/spark/logs/history 
ENV SPARK_EVENT_LOG_DIR=$SPARK_HISTORY_FS_LOG_DIRECTORY 
ENV SPARK_DAEMON_MEMORY=10g 
ENV SPARK_HISTORY_FS_CLEANER_ENABLED=true 
ENV SPARK_HISTORY_STORE_MAXDISKUSAGE=100g 
ENV SPARK_HISTORY_FS_CLEANER_INTERVAL=8h 
ENV SPARK_HISTORY_FS_CLEANER_MAXAGE=5d 
ENV SPARK_HISTORY_FS_UPDATE_INTERVAL=10s 
ENV SPARK_HISTORY_RETAINED_APPLICATIONS=100 
ENV SPARK_HISTORY_UI_MAXAPPLICATIONS=500
ENV PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH 

ENV SPARK_ROLE=master
# Exponemos el puerto de la interfaz web de Spark (8080)
EXPOSE 8080
EXPOSE 4040
EXPOSE 7077
EXPOSE 18080 
EXPOSE 9870
EXPOSE 8088




# Config
#COPY --chown=$USERNAME:$GROUPNAME conf/core-site.xml $HADOOP_CONF_DIR/
#COPY --chown=$USERNAME:$GROUPNAME conf/hdfs-site.xml $HADOOP_CONF_DIR/
#COPY --chown=$USERNAME:$GROUPNAME conf/yarn-site.xml $HADOOP_CONF_DIR/
#COPY --chown=$USERNAME:$GROUPNAME conf/mapred-site.xml $HADOOP_CONF_DIR/
#COPY --chown=$USERNAME:$GROUPNAME conf/workers $HADOOP_CONF_DIR/
#COPY --chown=$USERNAME:$GROUPNAME conf/spark-defaults.conf $SPARK_CONF/
#COPY --chown=$USERNAME:$GROUPNAME conf/log4j.properties $SPARK_CONF/


RUN ln $HADOOP_CONF_DIR/workers $SPARK_CONF/ 

# Directorio de salida para el servidor de historial
RUN mkdir -p /opt/spark/logs/history
RUN chmod a+w /opt/spark/logs/history

# Copiamos los scripts de entrada a la imagen
COPY ./entrypoint.sh /

# Concedemos permisos de ejecución al script de entrada
RUN chmod +x /entrypoint.sh

# Directorio de trabajo
WORKDIR /opt/spark

# Comando por defecto al iniciar el contenedor (puedes cambiarlo según tus necesidades)
CMD /bin/bash -c '/entrypoint.sh'

#CMD /bin/bash -c yes
