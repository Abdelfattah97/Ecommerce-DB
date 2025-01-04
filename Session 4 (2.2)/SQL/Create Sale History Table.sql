-- create table sale history
create table sale_history (
sale_id bigint primary key,
customer_id bigint,
first_name varchar(50),
last_name varchar(50),
product_id bigint,
product_name varchar(50),
prodcut_description varchar(50),
unit_price decimal,  
quantity int ,
total_amount decimal,
order_id bigint,
order_date date
);