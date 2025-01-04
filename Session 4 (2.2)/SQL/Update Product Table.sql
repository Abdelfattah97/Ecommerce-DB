-- Add author column 
ALTER TABLE product add column author_fk bigint;

-- Add Constraint on new column
ALTER TABLE product ADD CONSTRAINT author_fk FOREIGN KEY(author_fk)
REFERENCES author(author_id);

-- author 1 
update product set author_fk = 1
where product_id in (20,21,25,49,52,53,54,55);

-- author 2
update product set author_fk = 2
where product_id in (19,22,23,24,48,50,51);

-- author 3
update product set author_fk = 3
where product_id in (35,36,56,57,6,12,42,43
,45,46,47,13,14,59);

-- author 4
update product set author_fk = 4
where product_id in (17,18,34,37,15,16,40
,1,2,3,7,8,27,28,29,30,31,60,61);

-- author 5
update product set author_fk = 5
where product_id in (38,58,4,5,10,11,39,41,62
,63,65,9,26,32,44,64,33);