-- list of customers with orders totaling more than $500 in the past month
with monthly_orders as( 
select c.customer_id as cust_id
, concat(c.first_name,' ',c.last_name) as name 
, round(sum(o.total_amount)::decimal,2) as orders_amount
, date_part('month',o.order_date) as order_month
from customer AS "c" 
right join "order" o on o.customer_fk = c.customer_id 
where  date_part('month',o.order_date)  = date_part('month',CURRENT_DATE-INTERVAL '1 MONTH') 
group by c.customer_id, date_part('month',o.order_date)
)
select cust_id,name,orders_amount from monthly_orders 
where orders_amount >= 500
order by orders_amount desc;
