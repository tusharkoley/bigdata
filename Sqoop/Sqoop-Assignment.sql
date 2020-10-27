
SELECT movies.title, COUNT(ratings.movie_id ) AS ratingCount from movies INNER JOIN ratings ON movie_id=ratings.movie_id    
 GROUP BY movies.title ORDER BY ratingCount;    

 grant all privileges on movielens.* to ''@'localhost' ;


 ''@'localhost'

  grant all privileges on movielens.* to ''@'localhost' ;

  sqoop import --connect jdbc:mysql://localhost/movielens --driver com.mysql.jdbc.Driver --table movies -m 1

  CREATE TABLE exported_movie (id INTEGER, title VARCHAR(255), releaseDate DATE);

sqoop export --connect jdbc:mysql://localhost/movielens --driver com.mysql.jdbc.Driver  -m 1 --table exported_movie --export-dir /apps/hive/warehouse/movies --input-fields-terminated-by '\0001'




bin/flume-ng  agent --conf conf --conf-file /home/maria_dev/assignments/example.conf --name a1  -Dflume.root.logger=INFO,console

bin/flume-ng agent --conf conf --conf-file /home/maria_dev/assignments/example.conf --name a1 -Dflume.root.logger=INFO,console

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk


 ./kafka-topics.sh --create --zookeeper sandbox-hdp.hortonworks.com:2181 --replication-factor 1 --partitions 1 --topic fred

 ./kafka-topics.sh --list --zookeeper sandbox-hdp.hortonworks.com:2181 

 ./kafka-console-producer.sh --broker-list  ​sandbox-hdp.hortonworks.com:6667 --topic log-test

 ./kafka-console-consumer.sh --bootstrap-server sandbox-hdp.hortonworks.com:6667 --zookeeper localhost:2181 --topic fred --from-beginning

 ./kafka-console-consumer.sh --bootstrap-server sandbox-hdp.hortonworks.com:6667 --topic fred --from-beginning

  ./kafka-console-consumer.sh --bootstrap-server sandbox-hdp.hortonworks.com:6667 --topic log-test 

 ./connect-standalone.sh ~/connect-standalone.properties ~/connect-file-source.properties ~/connect-file-sink.properties


 wget media.sundog-soft.com/hadoop/access_log_small.txt