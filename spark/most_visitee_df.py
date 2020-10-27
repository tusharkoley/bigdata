from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql.functions import lit

def parse_visitors(line):
    words=line.value.split(',')
    name=words[16]+'_'+words[17]
    return Row(visitor = name, count =1 )

if __name__ == "__main__":    
    spark = SparkSession.builder.appName("visitor").getOrCreate()

    # Get the raw data
    lines = spark.read.text('hdfs:///user/tushar/WhiteHouse-WAVES-Released-0611.csv').rdd   
    visitRDD = lines.map(parse_visitors)

    # Convert to a DataFrame and cache it
    visit_df = spark.createDataFrame(visitRDD).cache()
    
    visit_data = visit_df.groupBy("visitor").agg({'count':'count'})
        
    for line in visit_data.orderBy("count(count)", ascending=False).take(20):
        print(line)
