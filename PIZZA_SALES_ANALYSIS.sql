create table pizzas(
pizza_id varchar(50) primary key,	
pizza_type_id varchar(50),
size varchar(10),
price float
);


select * from pizzas;

select count(*) from pizzas;

create table pizza_types(
pizza_type_id varchar(50) primary key,
name varchar(50),
category varchar(100),
ingredients varchar(200)
);

select * from pizza_types;


create table orders(
order_id varchar(50) primary key,
date date,
time time
);

select * from orders;
select count(*) from orders;

create table order_details(
order_details_id varchar(50) primary key,
order_id varchar(50), 
pizza_id varchar(50), 
quantity int
);

select * from order_details;
select count(*) from order_details;
----------------------------------------------------------------------------------------------
-- Retrieve the total number of orders placed.

select count(order_id) as "total order"  from orders;
----------------------------------------------------------------------------------------------
--Calculate the total revenue generated from pizza sales.
-- total revenue = qty*price

select  ROUND(SUM(p.price * o.quantity)::numeric, 2)	 as "total revenue" from  pizzas as p
inner join order_details as o
on p.pizza_id = o.pizza_id;
----------------------------------------------------------------------------------------------
--Identify the highest-priced pizza.
select * from pizza_types;
select max(price) as "highest priced pizza" from pizzas;
----------------------------------------------------------------------------------------------

-- what if the high price pizza with its name need to use joins

select  pt.name,p.price from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
order by p.price desc limit 1;

------------------------------------------------------------------------------------------------

--Identify the most common pizza size ordered.
select * from pizzas;
select * from pizza_types;

select * from order_details;

select p.size, count(o.order_details_id) as "total_orders_by_size" from pizzas as p
inner join order_details as o
on p.pizza_id = o.pizza_id
group by p.size
order by total_orders_by_size desc ;

----------------------------------------------------------------------------------------------
---List the top 5 most ordered pizza types along with their quantities.

select (pt.name), count(o.quantity) as "order_quantity_count" from  pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
inner join order_details o
on p.pizza_id = o.pizza_id
group by pt.name
order by order_quantity_count desc limit 5;

------------------------------------------------------------------------------------------------

--Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category, sum(od.quantity) as "total_quantity" from pizzas as p
inner join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
inner join order_details as od
on p.pizza_id = od.pizza_id
group by pt.category
order by total_quantity desc;

----------------------------------------------------------------------------------------------


-- Determine the distribution of orders by hour of the day

select extract(hour from time) as "hour", count(order_id) as "order_count"
from orders
group by "hour"
order by "hour" desc;
----------------------------------------------------------------------------------------------------
---Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) as total_types from pizza_types
group by category
order by  total_types desc;

-----------------------------------------------------------------------------------------------------

--Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(avg_pizzas_per_day),2) from
(select (o.date), sum(od.quantity) as "avg_pizzas_per_day" from pizzas as p
inner join order_details as od
on p.pizza_id = od.pizza_id
inner join orders as o
on o.order_id = od.order_id
group by  o.date) as avg_pizzas_by_day;

--------------------------------------------------------------------------------------------------------



-- Determine the top 3 most ordered pizza types based on revenue.

select pt.name, (sum(p.price * od.quantity)::numeric) as "revenue" from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
inner join order_details as od
on p.pizza_id = od.pizza_id
group by pt.name 
order by revenue desc 
limit 3;

-----------------------------------------------------------------------------------------------------

select * from pizzas;

--1. checking for the duplicates

select pizza_id, pizza_type_id
from pizzas
group by pizza_id, pizza_type_id
having count(*) > 1;


-- 2. getting second highest price from the pizzas table

select max(price) as second_max_price from pizzas
where price < (select max(price) as second_max_price from pizzas);


--3. Total revenue per Size 

select p.size, sum(od.quantity * p.price) as Total_Revenue from pizzas as p
inner join order_details as od
on p.pizza_id = od.pizza_id
group by size
order by Total_Revenue desc;


--4. get the top 3 highest paid pizzas name

select pt.name, sum(p.price) as cost from pizza_types as pt
inner join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
Group by pt.name
order by cost desc
limit 3;

-- 5. show the count of orders per customer

select * from order_details;

select order_details_id, count(*) as Order_Count from order_details	
group by order_details_id;	

--6. getting the latest order placed by each order
select order_id, max(date) as latest_ordered_date from orders
group by order_id;

--7. identifying most selling pizza name product
select order_id, sum(quantity) as total_quantity  from order_details
group by order_id
order by total_quantity desc
limit 1;

--8. count which order placed more than 5 times
select count(*) from order_details;

select count(*) as order_count from 
(select order_id from order_details 
group by order_id
having count(*) > 5) as sub;




