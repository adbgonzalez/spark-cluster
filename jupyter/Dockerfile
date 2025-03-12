# Usamos tu imagen base con Spark y Hadoop
FROM adbgonzalez/hadoop-spark:3.5

# Instalamos dependencias adicionales para Jupyter
RUN apt-get update && apt-get install -y \
    python3-pip \
    && apt-get clean

# Instalamos JupyterLab y PySpark 3.5.5
RUN pip install --upgrade pip && \
    pip install jupyterlab pyspark==3.5.5 

# Creamos un usuario jovyan para Jupyter con permisos adecuados
RUN useradd -m -s /bin/bash jovyan && \
    mkdir -p /home/jovyan/work && \
    chown -R jovyan:jovyan /home/jovyan



    # Configuramos variables de entorno para Spark y Hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH=/opt/hadoop/lib/native:$LD_LIBRARY_PATH
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV SPARK_HOME=/opt/spark
ENV PATH=/opt/hadoop/sbin:/opt/hadoop/bin:/opt/spark/bin:/opt/spark/sbin:$PATH

# Cambiamos a usuario jovyan para seguridad
USER jovyan
WORKDIR /home/jovyan/work

# ECO **Solución Extra**: Asegurar que las variables se cargan en cada shell
RUN echo 'export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH' >> ~/.bashrc \
    && echo 'export HADOOP_HOME=/opt/hadoop' >> ~/.bashrc \
    && echo 'export SPARK_HOME=/opt/spark' >> ~/.bashrc \
    && echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.bashrc \
    && echo 'export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH' >> ~/.bashrc \
    && echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc

# Exponemos el puerto de JupyterLab
EXPOSE 8888


# Comando por defecto para iniciar JupyterLab con PySpark
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]