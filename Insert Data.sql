-- Insert 100 dummy customers
INSERT INTO customer (first_name, last_name, email, password)
SELECT 
    'Customer' || i AS first_name, 
    'User' || i AS last_name, 
    'customer' || i || '@example.com' AS email, 
    'pass' || i AS password
FROM generate_series(1, 100) i;

-- Insert 10 categories
INSERT INTO category (category_name)
SELECT 'Category ' || i AS category_name
FROM generate_series(1, 10) i;

-- Insert 50 products linked to random categories
INSERT INTO product (name, description, price, stock_quantity, category_fk)
SELECT 
    'Product ' || i AS name, 
    'Description for product ' || i AS description, 
    (random() * 200 + 10)::numeric(10,2) AS price,  -- price between 10 and 210
    floor(random() * 500 + 10) AS stock_quantity,  -- stock between 10 and 510
    floor(random() * 10 + 1) AS category_fk  -- category_fk between 1 and 10
FROM generate_series(1, 50) i;

-- Insert 500 orders distributed over 6 months (July to December 2024)
INSERT INTO "order" (total_amount, order_date, customer_fk)
SELECT 
    (random() * 500 + 50)::numeric(10,2) AS total_amount,  -- total amount between 50 and 550
    date '2024-07-01' + (floor(random() * 180)) * interval '1 day' AS order_date,  -- Random dates within 6 months
    floor(random() * 100 + 1) AS customer_fk  -- Random customer_fk between 1 and 100
FROM generate_series(1, 500) i;

-- Insert 1000 order items, linked to random orders and products
INSERT INTO order_item (order_fk, product_fk, quantity, unit_price)
SELECT 
    floor(random() * 500 + 1) AS order_fk,  -- order_fk between 1 and 500
    floor(random() * 50 + 1) AS product_fk,  -- product_fk between 1 and 50
    floor(random() * 5 + 1) AS quantity,  -- quantity between 1 and 5
    (random() * 200 + 10)::numeric(10,2) AS unit_price  -- unit price between 10 and 210
FROM generate_series(1, 1000) i;

-- update order.total_amount with order_items --> total_amount
update "order" o 
SET total_amount = (
select sum(oi.quantity*oi.unit_price)
from order_item oi
where oi.order_fk = o.order_id
)
where exists (
select 1
from order_item oi
where oi.order_fk=o.order_id
)

-- delete orders that are not referenced by order_items
delete from "order" as o
where (select count(order_fk) from order_item where order_fk=o.order_id) <1