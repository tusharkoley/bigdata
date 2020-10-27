from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql.functions import lit

def parse_visitors(line):
    words=line.value.split(',')
    name=words[0]+'_'+words[1]+'_'+words[2]
    return Row(visitor = name, cnt =1 )

if __name__ == "__main__":    
    spark = SparkSession.builder.appName("visitor").getOrCreate()

    # Get the raw data
    lines = spark.read.text('hdfs:///user/tushar/WhiteHouse-WAVES-Released-0611.csv').rdd   
    visitRDD = lines.map(parse_visitors)

    # Convert to a DataFrame and cache it
    visit_df = spark.createDataFrame(visitRDD).cache()
    
    visit_df.createOrReplaceTempView("t_visit")

    df2 = spark.sql("SELECT visitor, count(cnt) as total_count from t_visit  GROUP BY visitor order by total_count desc ")
    print(df2.take(20))


export SPARK_HOME='/Users/tushar/Desktop/Hadoop/spark/spark'
export PATH=$SPARK_HOME:$PATH
export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH