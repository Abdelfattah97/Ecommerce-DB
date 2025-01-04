-- fill sale_history with existing data
with sale_hist as(
select oi.order_item_id,c.customer_id,c.first_name ,c.last_name ,
  p.product_id ,p.name, p.description ,
  oi.unit_price::decimal ,oi.quantity, (oi.quantity*oi.unit_price)::decimal as total_amount,
  o.order_id,o.order_date 
 from order_item as oi 
 inner join "order" as o on o.order_id = oi.order_fk
 inner join customer as c on o.customer_fk = c.customer_id
 inner join product as p on oi.product_fk = p.product_id 
) 
insert into sale_history (
sale_id,customer_id,first_name ,last_name ,
  product_id ,product_name, prodcut_description ,
  unit_price,quantity, total_amount,order_id,order_date 
);