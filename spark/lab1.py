def parse_visitor(line):
    words=line.split(',')
    vistor=words[0]+'_'+words[1]+'_'+words[2]
    return (vistor,1)

if __name__ == "__main__":
    
    from pyspark import SparkContext
    sc = SparkContext()
    my_rdd = sc.textFile('hdfs:///user/tushar/WhiteHouse-WAVES-Released-0611.csv')

    visitor_d=my_rdd.map(parse_visitor)

    visitor_red=visitor_d.reduceByKey(lambda cnt1, cnt2 : cnt1+cnt2)
    
    visitor_sorted=visitor_red.sortBy(lambda x: x[1], ascending=False)

    for line in visitor_sorted.take(20):
        print(line)
