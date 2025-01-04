create table category (
category_id serial primary key,
category_name varchar(50) not null
);

create table product(
product_id serial primary key,
name varchar(50) not null,
description varchar(50),
price double precision not null check(price>0),
stock_quantity int ,
category_fk bigint,
CONSTRAINT category_fk foreign key(category_fk)
references category(category_id)
);

create table customer(
customer_id serial primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(50),
password varchar(50)
);

create table "order"(
order_id serial primary key,
total_amount double precision not null check(total_amount>=0),
order_date date not null default(CURRENT_DATE) ,
customer_fk bigint,
CONSTRAINT customer_fk FOREIGN KEY(customer_fk)
references customer(customer_id)
);

create table order_item(
order_item_id serial primary key,
order_fk bigint not null,
quantity int not null check(quantity>0),
unit_price double precision not null,
product_fk bigint not null,
CONSTRAINT product_fk FOREIGN KEY(product_fk)
REFERENCES product(product_id),
CONSTRAINT order_fk FOREIGN KEY(order_fk)
REFERENCES "order"(order_id)
);
