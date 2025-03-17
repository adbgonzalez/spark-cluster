## Antes de empezar:
Aunque las imágines están en Docker Hub pueden generarse de la siguiente forma, especilamente si se quieren modificar con los sigiuentes comandos:
- docker build -t adbgonzlez/hadoop-spark:3.5 .
- docker build -t adbgonzalez/spark-notebook:3.5.5 jupyter
## Crear directorio work:
- mkdir work
- cd work
- git clone https://github.com/adbgonzalez/curso-spark.git .

## Crear directorio data
- mkdir data
- cd data
- git clone https://github.com/adbgonzaelz/data-spark.git .

## Lanzar el clúster
- docker compose up -d
- docker compose logs jupyter-notebook # Obtener el token de conexión
