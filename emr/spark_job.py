from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType
# Create a SparkSession
spark = SparkSession.builder.appName("EMR_Local_DataFrame_Sample").getOrCreate()
# Define schema for the DataFrame
schema = StructType([
    StructField("name", StringType(), True),
    StructField("age", IntegerType(), True),
    StructField("city", StringType(), True)
])
# Create a list of data for the DataFrame
data = [
    ("John", 28, "New York"),
    ("Sara", 35, "San Francisco"),
    ("Mike", 40, "Los Angeles"),
    ("Jane", 22, "Chicago")
]
# Create a DataFrame from the local list of data
df = spark.createDataFrame(data, schema=schema)
# Perform a transformation: Filter rows where age is greater than 30
filtered_df = df.filter(df.age > 30)
# Show the filtered DataFrame
filtered_df.show()
# Stop the SparkSession
spark.stop()