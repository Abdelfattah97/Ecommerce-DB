-- Insert 100 dummy customers
INSERT INTO customer (first_name, last_name, email, password)
SELECT 
    'Customer' || i AS first_name, 
    'User' || i AS last_name, 
    'customer' || i || '@example.com' AS email, 
    'pass' || i AS password
FROM generate_series(1, 100) i;