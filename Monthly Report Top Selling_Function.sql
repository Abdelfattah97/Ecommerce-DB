Drop FUNCTION if exists monthly_top_ten_prod;
-- Top Ten Selling Products as a function for diff months and years
CREATE OR REPLACE FUNCTION monthly_top_ten_prod(mm int , yyyy int)
RETURNS TABLE (
prod_id int ,
prod_name varchar(50),
avg_price numeric,
quantity_sold bigint,
total_revenue numeric,
order_freq bigint,
month_year text
)
AS $$
BEGIN 
Return query
select p.product_id as prod_id,p.name as prod_name, 
round(avg(oi.unit_price)::decimal,2)as avg_price,
sum(oi.quantity),
round(sum(oi.unit_price*oi.quantity)::decimal,2) as total_revenue,
count(oi.product_fk) as order_freq,
concat(date_part('month',o.order_date),'-',date_part('year',o.order_date)) as month_year
from order_item oi 
left join "order" as "o" on o.order_id = oi.order_fk
left join product as "p" on oi.product_fk = p.product_id
where date_part('month',o.order_date)=mm and date_part('year',o.order_date)=yyyy
group by p.product_id , date_part('month',o.order_date), date_part('year',o.order_date);		
END
$$ language plpgsql;

-- function test
select * from monthly_top_ten_prod(10,2024)
order by total_revenue desc,order_freq desc, quantity_sold desc
limit 10;
