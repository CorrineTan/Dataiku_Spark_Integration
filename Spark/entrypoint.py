from pyspark.sql import SparkSession

appName = "pyspark read csv"
master = "local"
filename = "test.csv"

spark = SparkSession.builder.master(master).appName(appName).getOrCreate()

df = spark.read.format('csv').option('header', True).option('multiLine', True).load(filename)
df.show()
print(f'Record count is: {df.count()}')