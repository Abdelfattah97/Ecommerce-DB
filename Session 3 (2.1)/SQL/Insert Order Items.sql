-- This Query Generates random order items and it is Dependent on a range of product_id and order_id
-- It is Recommended to use it only when inserting dummy data within one transaction avoiding any conflicts 
-- The Query is saved in a separate file for organizing purposes only
WITH RECURSIVE random_order_item AS (
    SELECT
        -- Generate a random order date between 2024-06-01 and 2024-12-31
       1 as id,(floor(random()*500)+1) as order_fk,(floor(random()*5)+1) as quantity,(floor(random()*65)+1) ::int as product_fk
    UNION ALL
    SELECT
       id+1 ,(floor(random()*500)+1) as order_fk,(floor(random()*5)+1) as quantity,(floor(random()*65)+1) ::int as product_fk
    FROM random_order_item
    where id <10000
)
INSERT INTO "order_item" (order_fk,quantity,unit_price,product_fk)
SELECT
    order_fk,quantity,p.price,product_fk
FROM random_order_item as roi left join product as p on roi.product_fk = p.product_id;