def parse_visitee(line):
    words=line.split(',')
    name=words[16]+'_'+words[17]
    return (name,1)

if __name__ == "__main__":
    
    from pyspark import SparkContext
    sc = SparkContext()
    my_rdd = sc.textFile('hdfs:///user/tushar/WhiteHouse-WAVES-Released-0611.csv')

    visitee_d=my_rdd.map(parse_visitee).reduceByKey(lambda cnt1, cnt2 : cnt1+cnt2).sortBy(lambda x: x[1], ascending=False)

    for line in visitee_d.take(20):
        print(line)
