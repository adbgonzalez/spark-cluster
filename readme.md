docker build -t adbgonzlez/hadoop-spark:3.5 .
docker build -t adbgonzalez/spark-notebook:3.5.5 jupyter
docker compose up -d
docker compose logs jupyter-notebook # Obtener el token de conexión
