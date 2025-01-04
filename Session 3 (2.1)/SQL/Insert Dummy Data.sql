BEGIN;
-- Ensure no data Exists before inserting our dummy data
TRUNCATE TABLE order_item cascade;
TRUNCATE TABLE "order" cascade;
TRUNCATE TABLE customer cascade;
TRUNCATE TABLE product cascade;
TRUNCATE TABLE category_hierarchy cascade;
TRUNCATE TABLE category cascade;

-- Reset customer_id sequence
Alter sequence customer_customer_id_seq RESTART WITH 1;

-- Insert 100 dummy customers
INSERT INTO customer (first_name, last_name, email, password)
SELECT 
    'Customer' || i AS first_name, 
    'User' || i AS last_name, 
    'customer' || i || '@example.com' AS email, 
    'pass' || i AS password
FROM generate_series(1, 100) i;

select * from customer;

--Reset product_id Sequence
alter sequence category_category_id_seq RESTART WITH 1;

-- Insert Categories with their subs
INSERT INTO category (category_name, parent_category)
VALUES
('Electronics', NULL),
('Personal Electronics', 1),
('Tablets', 2),
('Computers & Office Supplies', 1),
('TVs', 1),
('Laptops', 4),
('Desktop & Monitors', 4),
('Smartphones', 2),
('Clothes', NULL),
('Women Fashion', 9),
('Men Fashion', 9),
('Printers', 4),
('5G Tablets', 3),
('Wifi Only Tablets', 3),
('Wearable Devices', 2),
('Photography equipment', 1),
('Audio Equipment', 1);

--Reset product_id Sequence
alter sequence product_product_id_seq RESTART WITH 1;

-- Insert Products 
INSERT INTO product (name, description, price, stock_quantity, category_fk) VALUES
('Samsung 55-Inch QLED TV','4K UHD Smart TV with HDR',899.99,40,5),
('LG C2 65-Inch OLED TV','Smart TV with Dolby Vision and Alexa',1499.0,35,5),
('Sony A80J OLED','65-inch 4K OLED Smart TV',1799.0,30,5),
('MacBook Pro 14','M2 Pro Chip, 512GB SSD',1999.0,25,6),
('Dell XPS 13','13.4-inch Touch Laptop with Intel i7',1499.99,40,6),
('ASUS ROG Strix G15','Gaming Laptop, RTX 4070, 16GB RAM',1699.0,20,6),
('Canon EOS R5','Full-Frame Mirrorless Camera, 45MP',3299.0,15,16),
('Nikon Z9','Mirrorless Camera, 8K Video',5499.0,10,16),
('GoPro HERO11','Action Camera with Hypersmooth 5.0',499.0,60,16),
('iPhone 15 Pro','256GB, Titanium Gray',1199.0,50,8),
('Samsung Galaxy S23 Ultra','512GB, Phantom Black',1199.0,45,8),
('Google Pixel 8 Pro','128GB, Hazel',999.0,55,8),
('Apple Watch Series 9','45mm GPS + Cellular',529.0,65,15),
('Garmin Fenix 7X','Multisport GPS Smartwatch',899.0,35,15),
('Brother HL-L3270CDW','Color Laser Printer',349.0,50,12),
('Epson EcoTank ET-4760','All-in-One Cartridge-Free Printer',499.0,45,12),
('Dell 27"" Monitor','UltraSharp 4K UHD Monitor',699.0,55,7),
('ASUS ProArt PA32UCX','32-inch 4K HDR Monitor',1599.0,20,7),
('Levi’s 511 Jeans','Slim Fit, Men',79.5,200,11),
('Nike Dri-FIT Tee','Men’s Training T-shirt',35.0,300,11),
('Adidas Ultraboost 22','Women’s Running Shoes',190.0,120,10),
('Under Armour Joggers','Men’s Fleece Pants',60.0,180,11),
('Patagonia Down Jacket','Men’s Insulated Puffer',229.0,75,11),
('Zara Blazer','Women’s Formal Jacket',150.0,90,10),
('Columbia Rain Jacket','Women’s Waterproof Jacket',129.0,85,10),
('DJI Mini 3 Pro','Compact Drone with 4K Camera',859.0,30,16),
('Sony Alpha 7 IV','Full-Frame Camera',2499.0,20,16),
('Fujifilm X-T5','Mirrorless Digital Camera',1699.0,25,16),
('Sigma 24-70mm Lens','Canon Mount, f/2.8',1199.0,40,16),
('Fitbit Charge 6','Health and Fitness Tracker',179.0,100,15),
('Amazfit GTR 4','Smartwatch with GPS',199.0,85,15),
('Apple AirPods Pro 2','Active Noise Cancelling',249.0,120,15),
('Garmin Venu 2 Plus','Smartwatch with AMOLED Display',449.0,70,15),
('Dell OptiPlex 7000','Business Desktop with i7',1150.0,50,7),
('HP Envy Desktop','Core i9, 32GB RAM',1499.0,40,7),
('Acer Predator Orion 3000','Gaming PC, RTX 3060',1399.0,30,7),
('ViewSonic VP3268a','32-inch 4K Professional Monitor',799.0,45,7),
('Canon PIXMA TR8620','Wireless All-in-One Printer',179.99,90,12),
('HP OfficeJet Pro 9015','Wireless Printer with Fax',229.99,70,12),
('Epson WorkForce WF-7720','Wide-Format Printer',249.0,65,12),
('Brother MFC-J995DW','Inkjet Printer with Scanner',219.0,75,12),
('Samsung Galaxy Tab S9 Ultra','14.6-inch, 512GB 5G',1299.0,40,13),
('Lenovo Tab P12 Pro 5G','12.6-inch, 256GB',849.0,45,13),
('Apple iPad Pro 12.9','M2, 512GB, 5G',1399.0,35,13),
('Amazon Fire Max 11','11-inch, 64GB Wi-Fi',299.0,100,14),
('Samsung Galaxy Tab A8','10.5-inch, 128GB Wi-Fi',349.0,90,14),
('iPad 10th Gen','10.9-inch, 256GB Wi-Fi',649.0,60,14),
('Gucci GG Marmont Bag','Small Shoulder Bag',2300.0,25,10),
('Nike Air Max 270','Women’s Sneakers',150.0,120,10),
('Coach Parker Bag','Signature Canvas Purse',395.0,50,10),
('Zara Midi Dress','Women’s Elegant Dress',99.0,90,10),
('Adidas Forum Low','Men’s Sneakers',120.0,150,11),
('North Face Fleece','Men’s Outdoor Jacket',180.0,80,11),
('Polo Ralph Lauren Shirt','Classic Fit Cotton Shirt',89.0,200,11),
('Levi’s Denim Jacket','Men’s Trucker Jacket',129.0,110,11),
('Sony WF-1000XM5','Wireless Noise Cancelling Earbuds',299.0,70,17),
('Bose QuietComfort 45','Noise Cancelling Headphones',329.0,60,17),
('Oculus Quest 3','Advanced VR Headset 128GB',499.0,40,17),
('HP Spectre x360','2-in-1 Convertible Laptop',1349.0,30,6),
('Razer Blade 16','Gaming Laptop, RTX 4080',2699.0,18,6),
('Lenovo ThinkPad X1 Carbon"	"14',' Business Laptop',1799.0,25,6),
('iPad Air 5th Gen','64GB, Wi-Fi, Starlight',599.0,65,14),
('Samsung Galaxy Tab S9+','12.4-inch, 128GB',849.0,50,14),
('Microsoft Surface Pro 9','Core i5, 256GB SSD',1199.0,40,13),
('Amazon Fire HD 10"	"10.1',' Full HD Tablet',149.99,100,14);

--Reset order_id seq
ALTER SEQUENCE order_order_id_seq RESTART WITH 1;

-- Insert Orders
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

--Reset Order_item 
ALTER SEQUENCE order_item_order_item_id_seq RESTART WITH 1;

--Insert Order_Items
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

-- update total_amount after adding order_items
update "order" o
set total_amount = (
select sum(quantity*unit_price) from order_item 
where order_fk = o.order_id );

COMMIT;