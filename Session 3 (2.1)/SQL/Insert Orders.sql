-- This Query Generates random orders and it is Dependent on a range of customer_id in customer list
-- It is Recommended to use it only when inserting dummy data within one transaction avoiding any conflicts 
-- The Query is saved in a separate file for organizing purposes only
WITH RECURSIVE random_dates AS (
    SELECT
        -- Generate a random order date between 2024-06-01 and 2024-12-31
       1 as id ,'2024-06-01'::date + (random() * ( '2024-12-31'::date - '2024-06-01'::date ))::int AS order_date
    UNION ALL
    SELECT
       id+1 ,'2024-06-01'::date + (random() * ( '2024-12-31'::date - '2024-06-01'::date ))::int
    FROM random_dates
    where id <500
)
INSERT INTO "order" (order_date,total_amount,customer_fk)
SELECT
    order_date,0,
    -- Randomly assign customer IDs between 1 and 100
    (floor(random() * 100) + 1)::int AS customer_fk
FROM random_dates;