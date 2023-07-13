create database sales_and_delivery;
use sales_and_delivery;

create table cust_dimen
(customer_name varchar(255),
province varchar(70),
region varchar (50),
customer_segment varchar (50),
cust_id varchar(255) primary key);

create table market_fact
(ord_id varchar (255),
prod_id varchar (255),
ship_id varchar (255),
cust_id varchar (255),
sales float,
discount float,
order_quantity float,
profit float,
shipping_cost float,
product_base_margin float);

create table orders_dimen
(order_id int,
order_date date,
order_priority varchar (255),
ord_id varchar (255) primary key);

create table prod_dimen
(
product_category varchar (255),
product_sub_category varchar (255),
prod_id varchar (255) primary key);

create table shipping_dimen
(
order_ID int,
ship_Mode varchar (50),
ship_date date,
ship_ID varchar (255) primary key);

#giving primary keys and foreign key refering from the ER Diagram
alter table market_fact
add foreign key (cust_id) references cust_dimen(cust_id);
alter table market_fact
add foreign key (ord_id) references orders_dimen(ord_id);
alter table market_fact
add foreign key (prod_id) references prod_dimen(prod_id);
alter table market_fact
add foreign key (ship_id) references shipping_dimen(ship_id);


#Questions1
#Find the top 3 customers who have the maximum number of orders
show tables;
select * from orders_dimen;
select * from cust_dimen;
select * from market_fact;
select distinct customer_name, cd.cust_id, order_quantity
from cust_dimen cd join market_fact mf
on cd.cust_id = mf.cust_id
order by (order_quantity) desc limit 3;

#Question 2: Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.
select * from shipping_dimen;
select * from orders_dimen;
update orders_dimen set order_date = str_to_date(order_date, '%Y-%m-%d');
update shipping_dimen set ship_date = str_to_date(ship_date, '%d-%m-%Y');

select distinct(order_Id), order_date, ship_date, datediff(ship_date,order_date) as DaysTakenForDelivery
from shipping_dimen join orders_dimen
using(order_Id)
having datediff(ship_date,order_date);

#Question 3: Find the customer whose order took the maximum time to get delivered.
select * from shipping_dimen;
select * from orders_dimen;
select order_Id, order_date, ship_date, datediff(ship_date,order_date) as DaysTakenForDelivery
from shipping_dimen join orders_dimen
using(order_Id)
having datediff(ship_date,order_date) 
order by datediff(ship_date,order_date) desc;

#Question 4: Retrieve total sales made by each product from the data (use Windows function)
select * from market_fact;
select distinct prod_id,
sum(sales) over(partition by prod_id) as total_sales from market_fact;

#Question 5: Retrieve the total profit made from each product from the data (use windows function)
select * from market_fact;
select distinct prod_id,
sum(profit) over(partition by prod_id) as total_profit from market_fact;


#Question 6: Count the total number of unique customers in January and how many of them came back 
#every month over the entire year in 2011
select * from orders_dimen;
select * from cust_dimen;
select * from market_fact;

with t1(unq_cust, ord_date, ord_date_y, ord_date_m) as
(select count(distinct cd.cust_id) as unique_customers, order_date, year(order_date),month(order_date) from cust_dimen cd join market_fact mf on cd.cust_id = mf.cust_id
join orders_dimen od on od.ord_ID = mf.ord_ID where month(order_date) = 01 group by year(order_date), month(order_date))
(select unq_cust, ord_date_y, ord_date_m from t1 join orders_dimen od on t1.ord_date = od.order_date
where year(order_date) = 2011
group by month(order_date)
order by month(order_date));
