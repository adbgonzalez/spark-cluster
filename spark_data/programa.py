from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType, TimestampType
from pyspark.sql.functions import expr
import time, random

spark = SparkSession.builder.getOrCreate()
sc = spark.sparkContext


# Definir el esquema
schema = StructType([
    StructField("InvoiceNo", IntegerType(), True),
    StructField("StockCode", StringType(), True),
    StructField("Description", StringType(), True),
    StructField("Quantity", IntegerType(), True),
    StructField("InvoiceDate", TimestampType(), True),
    StructField("UnitPrice", DoubleType(), True),
    StructField("CustomerID", IntegerType(), True),
    StructField("Country", StringType(), True)
])

# Leer el archivo CSV con el esquema especificado

df = spark.read.csv("data/online-retail-dataset.csv", header=True, schema=schema)

new_df = df.select("InvoiceNo", expr("Quantity * UnitPrice AS ImporteTotal")).groupBy("InvoiceNo").avg("ImporteTotal")

new_df.write.json("salida")

time.sleep(1000)
