emp = load 'emp.txt' using PigStorage(',') AS (id:int, name:chararray, city:chararray, salary:int);

emp_city = GROUP emp BY city;

avg_sal_city = FOREACH emp_city GENERATE group, AVG(emp.salary);

dump avg_sal_city;


data type customer - id, name, city, income
data type orders - id, costomer_id, delivery_addr, order_amount

perform the follwing action -

1) load order and custmore data from two csv (create sample csv files)
2) find the average customer income by city
3) join the two data by customer id and display custmore_name, delivery_addr, total order amount
