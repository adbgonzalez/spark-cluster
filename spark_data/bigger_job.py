from pyspark import SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, count, lit, udf

import time, random

from pyspark.sql.types import StringType


def create_spark_session(is_local: bool) -> SparkSession:
    if is_local:
        print("Stating for local mode")
        conf = SparkConf().set("spark.driver.memory", "8g")

        spark_session = SparkSession\
            .builder\
            .master("local[4]")\
            .config(conf=conf)\
            .appName("Spark UI Tutorial") \
            .getOrCreate()

        spark_session.sparkContext.setCheckpointDir("checkpoint")

        return spark_session

    else:
        print("Stating for cluster mode")
        return SparkSession\
            .builder\
            .appName("Spark UI Tutorial")\
            .getOrCreate()


def get_alphabet_skewed(number: int):
    if number > 25:
        if number % 3 == 0:
            return "x"
        if number % 3 == 1:
            return "y"
        else:
            return "z"
    else:
        return chr(97 + number)


@udf(returnType=StringType())
def repeat_letter(letter: str, should_randomly_fail: bool) -> str:
    if should_randomly_fail:
        random_num = random.randint(0, 5000000)
        print(f"Random number: {random_num}")
        if random_num < 1:
            print("Failing ......")
            raise ValueError("Randomly failing")

    print(f"Letter is: {letter}")
    return letter * 4


def execute_bigger_job(is_local: bool, number_of_records: int):
    spark = create_spark_session(is_local=is_local)

    raw_data = [(i, get_alphabet_skewed(i % 200)) for i in range(0, number_of_records)]
    data_df = spark.createDataFrame(raw_data, ["number", "letter"])\
        .repartition(201)

    print(data_df.count())
    data_df.show(truncate=False)

    data_df\
        .withColumn("repeated_alpha", repeat_letter(col("letter"), lit(False)))\
        .groupBy("repeated_alpha")\
        .agg(count(lit(1)))\
        .sort("repeated_alpha")\
        .show(truncate=False, n=30)


if __name__ == '__main__':
    execute_bigger_job(is_local=False, number_of_records=10000000)

    # For UI to stick
    time.sleep(1000) 
