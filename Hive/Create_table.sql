create database retail_db_tusharkoley;

use retail_db_tusharkoley;



CREATE External table IF NOT EXISTS orders (
    order_id  STRING,
    order_date STRING,
    order_customer_id  INT,
    order_status  STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
location '/user/cca/retail_db/orders' ;




create table daily_order_count ( order_date STRING,order_count INT )
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\u0059' 
LINES TERMINATED BY '\n';

insert into daily_order_count

select order_date, count(order_id) as order_count from orders GROUP BY order_date;



CREATE EXTERNAL TABLE order_items_stage (
    order_item_id  INT,
    order_item_order_id  INT,
    order_item_product_id  INT,
    order_item_quantity  INT,
    order_item_subtotal  FLOAT,
    order_item_product_price  FLOAT

)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
location  '/user/cca/retail_db/order_items';

CREATE EXTERNAL table IF NOT EXISTS order_items (
    order_item_id int,
    order_item_order_id  int,
    order_item_product_id  int,
    order_item_quantity  int,
    order_item_subtotal FLOAT,
    order_item_product_price  FLOAT
)
stored as orc;


insert into order_items select * from  order_items_stage;


create table daily_order_revenue (order_date INT, order_month INT, order_year INT, order_revenue FLOAT )
STORED as ORC;

insert into daily_order_revenue

select substr(orders.order_date, 0,4) as order_year,
substr(orders.order_date, 6,2) as order_month,
substr(orders.order_date, 9,2) as order_date,
sum(order_item_subtotal) as revenue from orders join order_items 
ON order_items.order_item_order_id = orders.order_id

where upper(orders.order_status) in ('COMPLETE', 'CLOSED')

group by orders.order_date;


Get all the orders which do not have corresponding order_items.

 Data should be loaded into new table. orders is parent table and order_items is child table.
 order_items.order_item_order_id is the foreign key for orders.order_id.

* Database: retail_db_<YOUR_OS_USER_NAME>

* Target Table: orders_outer

* File Format: text

* Field Delimiter: ,

* Field Names: order_id, order_date, order_customer_id, order_status

* Data Types should be from orders.

create table orders_outer (order_id INT, order_date STRING, order_customer_id STRING, order_status STRING )
STORED as ORC;

insert into orders_outer 
select order_id,order_date  , order_customer_id, order_status    from orders where order_id not in 
(select order_item_order_id from order_items);


sqoop import --connect jdbc:mysql://localhost/test --user root --password hadoop --table employee --target-location '/user/tushar'

sqoop export --connect 