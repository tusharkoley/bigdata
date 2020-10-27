from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils
from kafka import KafkaProducer
import json
from json import dumps

if __name__ == "__main__":
    
    def to_kafka(rdd):
        cnt=rdd.count()
        if cnt>0 :
            data = rdd.take(1)
            producer.send('spark_event_out', value=data)

    sc = SparkContext(appName="StreamingKafkaEventAggregator")
    sc.setLogLevel("ERROR")
    ssc = StreamingContext(sc, 10)

    print('Listenting to topic')
    data='Processed a batch now'

    producer = KafkaProducer(bootstrap_servers=['sandbox-hdp.hortonworks.com:6667'], value_serializer=lambda x: dumps(x).encode('utf-8'))

    kafkaStream = KafkaUtils.createStream(ssc, 'localhost:2181', 'spark-streaming', {'spark_event':1})
    parsed = kafkaStream.map(lambda v: json.loads(v[1]))


    parsed.count().map(lambda x:'Message in this batch: %s' % x).pprint()

    # writting the data back to Kafka
    parsed.foreachRDD(to_kafka)
    

    ssc.start()
    ssc.awaitTermination()
