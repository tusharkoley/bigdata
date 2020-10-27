

CREATE EXTERNAL TABLE nasdaq_dividend ( exchange1 STRING, stock_symbol STRING, modified_date STRING, dividends FLOAT ) 
COMMENT 'This is the nasdaq dividend table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE 
LOCATION '/user/tushar/nasdaq/';



CREATE EXTERNAL TABLE nasdaq_daily ( exchange1 STRING, stock_symbol STRING, modified_date STRING, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, avg FLOAT ) 
COMMENT 'This is the nasdaq dividend table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE 
LOCATION '/user/tushar/nasdaq/';

 //Find out total volume sale for each stock symbol which has closing price more than $5. --

select stock_symbol, sum(volume) as stock_volume 
from nasdaq_daily 
where close > 5 
group by stock_symbol;


 ***********Find out highest price in the history for each stock symbol ******

 select stock_symbol, max(close) from nasdaq_daily 
 group by stock_symbol;

********  Find out highest dividends given for each stock symbol in entire history. *****

select stock_symbol, max(dividends) from nasdaq_dividend 
group by stock_symbol;

*********Find out highest price and highesh dividends for each stock symbol if highest price and highest dividends exist. ****

 select np.stock_symbol, max(np.close) , max (nd.dividends)
 from nasdaq_daily np join nasdaq_dividend nd
 on np.stock_symbol==nd.stock_symbol
 group by stock_symbol;


select np.stock_symbol , np.max_price, nd.max_div from 

(select stock_symbol, max(close) as max_price from nasdaq_daily 
 group by stock_symbol) np join 

 (select stock_symbol, max(dividends) as max_div from nasdaq_dividend 
group by stock_symbol) nd
on np.stock_symbol = nd.stock_symbol;


select np.stock_symbol , np.max_price, nd.max_div from 

(select stock_symbol, max(close) as max_price from nasdaq_daily 
 group by stock_symbol) np full outer join 

 (select stock_symbol, max(dividends) as max_div from nasdaq_dividend 
group by stock_symbol) nd
on np.stock_symbol = nd.stock_symbol;


*****CReate Dynamic  partition Table for dividends ******
CREATE EXTERNAL TABLE nasdaq_dividend_part ( exchange1 STRING, modified_date STRING, dividends FLOAT ) 
PARTITIONED BY (stock_symbol STRING)
STORED AS ORC;


set hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE nasdaq_dividend_part
PARTITION (stock_symbol)  select exchange1, modified_date , dividends , stock_symbol
 from nasdaq_dividend;


*****CReate Dynamic  partition Table for nasdaq daily price ******



CREATE EXTERNAL TABLE nasdaq_daily_part ( exchange1 STRING,  modified_date STRING, open FLOAT, high FLOAT, low FLOAT, close FLOAT, volume INT, avg FLOAT ) 
PARTITIONED BY (stock_symbol STRING)
STORED AS ORC;

set hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE nasdaq_daily_part
PARTITION (stock_symbol)  select  exchange1 ,  modified_date , open , high , low , close , volume , avg ,stock_symbol 
 from nasdaq_daily;