-- creates a trigger function that inserts the record that fired the trigger into the sale_history table
CREATE or REPLACE FUNCTION insert_sale_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		insert into sale_history (
		sale_id,customer_id,first_name ,last_name ,
		  product_id ,product_name, prodcut_description ,
		  unit_price,quantity, total_amount,order_id,order_date 
		) select oi.order_item_id,c.customer_id,c.first_name ,c.last_name ,
		  p.product_id ,p.name, p.description ,
		  oi.unit_price,quantity, (oi.quantity*oi.unit_price) as total_amount, o.order_id, o.order_date 
		  from order_item as oi 
		  left join product as p on p.product_id = oi.product_fk
		  left join "order" as o on o.order_id = oi.order_fk
		  left join customer as c on c.customer_id = o.customer_fk
		  where oi.order_item_id = NEW.order_item_id;
		  
	RETURN NEW;
	END;
$$;

-- Creates a trigger that fires on each row insert
CREATE TRIGGER insert_sale_history_trigger AFTER INSERT ON public.order_item FOR EACH ROW EXECUTE FUNCTION public.insert_sale_history();
