

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


create view IF NOT EXISTS high_price_view as 
select stock_symbol, volume from  nasdaq_daily where close>5.0;

select stock_symbol,  sum(volume) from high_price_view group by stock_symbol;
