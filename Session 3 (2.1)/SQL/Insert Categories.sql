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

-- select * from category order by category_id;