-- monthly report of the top-selling products in a given month.
-- top 10 products

-- select p.product_id as prod_id,p.name as prod_name, round(p.price::decimal,2)as prod_price,round(sum(oi.unit_price*oi.quantity)::decimal,2) as total_revenue,
-- count(oi.product_fk) as uq_orders,
-- concat(date_part('month',o.order_date)  ,'-',date_part('year',o.order_date) ) as month_year
-- from order_item oi left join "order" as o on o.order_id = oi.order_fk
-- left join product as "p" on oi.product_fk = p.product_id
-- where date_part('month',o.order_date)=7 and date_part('year',o.order_date)=2024
-- group by p.product_id , date_part('month',o.order_date), date_part('year',o.order_date)
-- order by uq_orders desc,total_revenue desc
-- limit 10;	


-- Top Ten Selling Products as function for diff months and years
CREATE OR REPLACE FUNCTION monthly_top_ten_prod(mm int , yyyy int)
RETURNS TABLE (
prod_id int ,prod_name varchar(50),
prod_price numeric,total_revenue numeric,
uq_orders bigint , month_year text
)
AS $$
BEGIN 
Return query
select p.product_id as prod_id,p.name as prod_name, round(p.price::decimal,2)as prod_price,round(sum(oi.unit_price*oi.quantity)::decimal,2) as total_revenue,
count(oi.product_fk) as uq_orders,
concat(date_part('month',o.order_date)  ,'-',date_part('year',o.order_date) ) as month_year
from order_item oi left join "order" as o on o.order_id = oi.order_fk
left join product as "p" on oi.product_fk = p.product_id
where date_part('month',o.order_date)=7 and date_part('year',o.order_date)=2024
group by p.product_id , date_part('month',o.order_date), date_part('year',o.order_date)
order by uq_orders desc,total_revenue desc
limit 10;		
END
$$ language plpgsql

select * from monthly_top_ten_prod(7,2024);