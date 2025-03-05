# Usamos tu imagen base con Spark y Hadoop
FROM adbgonzalez/hadoop-spark:3.5.5

# Instalamos dependencias adicionales para Jupyter
RUN apt-get update && apt-get install -y \
    python3-pip \
    && apt-get clean

# Instalamos JupyterLab y PySpark 3.5.5
RUN pip install --upgrade pip --break-system-packages && \
    pip install jupyterlab pyspark==3.5.5 --break-system-packages

# Creamos un usuario jovyan para Jupyter con permisos adecuados
RUN useradd -m -s /bin/bash jovyan && \
    mkdir -p /home/jovyan/work && \
    chown -R jovyan:jovyan /home/jovyan

# Configuramos variables de entorno para Spark y Hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH=/opt/hadoop/lib/native:$LD_LIBRARY_PATH
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV SPARK_HOME=/opt/spark
ENV PATH=/opt/hadoop/sbin:/opt/hadoop/bin:/opt/spark/bin:/opt/spark/sbin:$PATH

# Exponemos el puerto de JupyterLab
EXPOSE 8888

# Cambiamos a usuario jovyan para seguridad
USER jovyan
WORKDIR /home/jovyan/work

# Comando por defecto para iniciar JupyterLab con PySpark
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
