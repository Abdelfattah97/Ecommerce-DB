## Ecommerce DB

This repository contains tasks and solutions from the database phase of Eng/Ahmed Emad's mentorship program.
The focus is on designing, querying and optimizing Ecommerce database to generate effecient reports and insights.

**Datbase used:** PostgreSQL-16

## Content

- [Session 3 (2.1) Task](#session-3-21-task)

  - [Summary & Tasks](#summary)
  - [Solution](#solution)
    - [ERD](#erd)
    - [Tables Creation](#table-creation-script)
    - [Dummy Data ](#dummy-data-insertion-script)
    - [Total Revenue Of Specific Day](#total-revenue-of-specific-day)
    - [Monthly Top Selling Products](#monthly-top-selling-products)
    - [Customers With High-Amount Orders](#customers-with-high-amount-orders)

- [Session 4 (2.2) Task](#session-4-22-task)
  - [Summary & Tasks](#summary-1)
  - [Solution](#solution-1)
    - [ERD](#erd-1)
    - [Initial Data](#initial-data-1)
    - [Sale History Denormalization](#sale-history-denormalization)
      - [Create Table Sale History](#create-table-sale-history)
      - [Insert Existing Data to Sale History](#insert-existing-data-to-sale-history)
      - [Trigger To Synchronize Sale History](#trigger-to-synchronize-sale-history)
    - [Search Product Containing Word](#search-products-containing-a-word)
    - [Product Recommendations](#product-recommendations)

## Session 3 (2.1) Task:

### Summary:

This section will contain db design, creation, intialization, and generating some reports of it.

- Entities:
<p> 
<img src="Session 3 (2.1)/Task-Entities.jpg" />
</p>

- Tasks:
  - Create DB schema script for the entities
  - Identify the relationships between entities
  - Draw ERD of this sample schema
  - Write an SQL query to generate a daily report of the total revenue for a specific date.
  - SQL query to generate a monthly report of the top-selling products in a given month.
  - Write a SQL query to retrieve a list of customers who have placed orders totaling more than $500 in the past month.
    Include customer names and their total order amounts. [Complex query].

---

### Solution

#### ERD

<p>
<p>
<b>Schema Diagram</b>
</p>
<img src="Session 3 (2.1)/e-commerce-db-schema-1.jpg" />
</p>
<p>
<p>
<b>ER-Diagram</b>
</p>
<img src="Session 3 (2.1)/e_commerce-ERD-1.jpg" />
</p>

---

#### Scripts

- Initial Data \
  Scripts for creating tables and filling them with dummy data.

  - ##### [Table Creation Script](<Session%203%20(2.1)/SQL/Create%20tables.sql>)
    This file contains the script creating the earlier mentioned schema => [ERD](#erd).
  - ##### [Dummy Data Insertion Script](<Session%203%20(2.1)/SQL/Insert%20Dummy%20Data-2.sql>)

    This Script Contains a transaction that truncates all data from tables, resets PK sequences and inserts dummy data randomly simulating a real life e-commerce DB case.

    > As we mentioned that some of the inserted data will be randomly inserted to the database some of the queries results will not have the same result as shown in the examples below.

    Dummy Data:

    - Specific:

      - 17 Category
      - 65 Product

    - Randomly:
      - 10K Customer
      - 100K Orders
      - 1M Order_details

- ##### [Total Revenue Of Specific Day](<Session%203%20(2.1)/SQL/Total%20Revenue-Specific%20Date_Function.sql>)

  This script generates a report of total revenue of orders in a specific day

  > The Script creates a function that takes the **specific date** and uses a query to return a **table** having the total revenue and the date.

  > The query sums total price (unit_price \* quantity) of all order items grouped by their order date and then filters the specified date total revenue.

  ```sql
  --Total Revenue for specific date as a function
  CREATE OR REPLACE FUNCTION total_revenue_by_date(report_date date)
  returns table (total_revenue numeric , date date)AS
  $$
  BEGIN
  RETURN QUERY
  --Query
  SELECT
  -- sum of total_prices
  ROUND(SUM(oi.unit_price*oi.quantity)::decimal,2)AS total_revenue,
  -- the orders date (as they are grouped by order_date)
  order_date AS date
  -- from order items table
  FROM order_item AS oi
  -- joing order as it owns the order_date
  LEFT JOIN "order" AS o ON o.order_id = oi.order_fk
  -- filtering only the queried report date
  WHERE o.order_date = report_date
  -- grouping results by date
  GROUP BY o.order_date
  -- sorting higher revenue on the top
  ORDER BY total_revenue DESC;
  END
  $$ LANGUAGE plpgsql;
  ```

  **Result**: \
   You can see the results by using a select query on the funtion and passing the desired date to the function

  ```sql
  -- This generates a total revenue report for the specified date (2024-07-23)
   select * from total_revenue_by_date('2024-07-23');
  ```

  <p><img src="Session 3 (2.1)/Total-Revenue-Result.jpg" /></p>

  **Columns:**

  - **total_revenue:** total price of all date's order items
  - **date:** the date of the total revenue

- ##### [Monthly Top Selling Products](<Session%203%20(2.1)/SQL/Monthly%20Report%20Top%20Selling_Function.sql>)

  This script generates a report showing the top-selling products of a specific month of a year.

  > The Script creates a function that takes two parameters month and year and uses a query to return a table of product id , product name , average price , quantity sold , total revenue , order frequency , month of year.

  > The query gets the product basic details , avgerage price of selling this product over the specified month of year , the quantity sold in that month , the total revenue of this product in that month of a year , the order frequency which is orders count where the product appeared , month of a year of this report

  > You can change how top-selling strategy is determined by changing the sorting of the results by ( total_revenue | order_freq | quantity_sold )

  ```sql
  CREATE OR REPLACE FUNCTION monthly_top_selling_prod(mm int , yyyy int)
  RETURNS TABLE (
  prod_id int ,
  prod_name varchar(50),
  avg_price numeric,
  quantity_sold bigint,
  total_revenue numeric,
  order_freq bigint,
  month_year text
  )AS $$
  BEGIN
  Return query
  select p.product_id as prod_id, p.name as prod_name,
  -- the average price of selling the product in a mnth (unit price may differ from product price)
  round(avg(oi.unit_price)::decimal,2)as avg_price,
  -- the sum of product quantity sold in a month
  sum(oi.quantity),
  -- the sum of total price of the product in order items of a month
  round(sum(oi.unit_price*oi.quantity)::decimal,2) as total_revenue,
  -- The count of orders where a product was ordered
  count(oi.product_fk) as order_freq,
  -- the month and year of the orders
  concat(date_part('month',o.order_date),'-',date_part('year',o.order_date)) as month_year
  from order_item oi
  left join "order" as "o" on o.order_id = oi.order_fk
  left join product as "p" on oi.product_fk = p.product_id
  -- filtering the desired month of year total revenue
  where date_part('month',o.order_date)=mm and date_part('year',o.order_date)=yyyy
  -- grouping results by each product and ordering date for the product's order
  group by p.product_id , date_part('month',o.order_date), date_part('year',o.order_date);
  END
  $$ language plpgsql;
  ```

  **Result**: \
   You can see the results by using a select query on the funtion and passing the desired month and year to the function. \
  Add your desired combination of sorting to change the top-selling strategy.

  ```sql
  -- This generates a total revenue report for the specified date (2024-07-23)
    select * from monthly_top_selling_prod(10,2024)
    order by total_revenue desc,order_freq desc, quantity_sold desc
    limit 10;
  ```

     <p>
     <img src="Session%203%20(2.1)/Top-Ten-Selling-Product-Results.jpg" >
     </p>

  **Columns:**

  - **prod_id, prod_name:** Product basic information.
  - **avg_price**: Average selling price across a month of year.
  - **quantity_sold**: The overall quantity sold across a month of year.
  - **total_revenue:** The total revenue of that product in a month of year.
  - **order_freq:** The ordering count of that product in a month of year or how much orders the product has appeared in.
  - **month_year:** The month of a year for the result (included for clarity).

- ##### [Customers With High-Amount Orders](<Session%203%20(2.1)/SQL/Filtered_Customers_List.sql>)

  This script generates a report listing customers who have placed orders totaling more than $500 in the past month.

  > The query first calculates the total amount of orders placed by each customer in the past month. It then filters and returns customers whose total orders exceed $500, sorted by order amount in descending order.

  ```sql
  -- list of customers with orders totaling more than $500 in the past month
  with monthly_orders as(
  select
  --customer id
  c.customer_id as cust_id
  -- customer name
  , concat(c.first_name,' ',c.last_name) as name
  -- total amount paid by this customer in a month
  , round(sum(o.total_amount)::decimal,2) as orders_amount
  -- the month of the result
  , date_part('month',o.order_date) as order_month
  from customer AS "c"
  right join "order" o on o.customer_fk = c.customer_id
  -- filters only the past month results
  where  date_part('month',o.order_date)  = date_part('month',CURRENT_DATE-INTERVAL '1 MONTH')
  --grouping aggregation by each customer and each month
  group by c.customer_id, date_part('month',o.order_date)
  )
  select cust_id,name,orders_amount from monthly_orders
  -- filtering only cusomers with order_amount >= 500
  where orders_amount >= 500
  -- sorting customers by the order_amount from higher to lower
  order by orders_amount desc;

  ```

  **Result:** \
   You can see the results by running the above query directly. It will display a list of customers along with their total order amounts.

    <p><img src="Session 3 (2.1)/Filtered_Customer_List_Result.jpg" /></p>

  **Columns:**

  - **cust_id**: Customer ID.
  - **name**: Full name of the customer.
  - **orders_amount**: Total order amount for the past month.

---

## Session 4 (2.2) Task:

### Summary

This Section contains more queries on the e-commerce schema from [Session (2.1)](#session-3-21-task)

- **Tasks:**
  - Search product containing "\<word\>" either in name or description.
  - Write query to suggest popular products in the same category and the same author excluding purchased product from recommendations.
  - A Trigger on insert to create a sale history, when a new order is made in "Orders" table inclide (order date, customer, product, total amount, quantity).

### Solution

### ERD

We created the schema in session 3 as shown in the [ERD](#erd) and as tasks mentioned a new entity "Author" we are going to add it to our schema.

> Author is the seller and owner of products group in the system.

Author will contain the following attributes:

- authour_id
- name

> We will keep it simple for now.

Now Product has a new Many-to-one relationship with the author.

The new ERD look like :

<p>
<p>
<b>Schema Diagram</b>
</p>
<img src="Session 4 (2.2)/e-commerce-db-schema-2-1.jpg" />
</p>
<p>
<p>
<b>ER-Diagram</b>
</p>
<img src="Session 4 (2.2)/e_commerce-ERD-2-1.jpg" />
</p>

### Scripts

- ##### Initial Data

  - [Create Author Table](<Session%204%20(2.2)\SQL\Create%20Author%20Table.sql>)
  - [Insert Author Data](<Session%204%20(2.2)\SQL\Insert Author Data.sql>)
  - [Update Product Table](<Session%204%20(2.2)\SQL\Update%20Product%20Table.sql>)

    We will Add author_fk column, add foreign key constraint and connect our existing products to diff authors by filling the new author_fk column with some author ids from th author table.

- ##### Sale History Denormalization

  We will create Sale History table as denormalization for tables containing sales of customers as an optimization technique avoiding the number of joins needed to get a sale record from Customer, Product, Order ,and Order Item tables.

  > Later a trigger will be created to ensure the syncronization of data in this table with the denormalized tables

    <p>
    <p>Table Design</p>
    <img src="Session 4 (2.2)/Sale-History-Table-Schema.jpg" />
    </p>
    
    > sale_id will be the same as order_item_id from order_item table and will used as the primary key for sale history table.

  - ##### [Create Table Sale History](<Session%204%20(2.2)\SQL\Create%20Sale%20History%20Table.sql>)

    Firstly we will create a new Sale History table using the following script.

    ```sql
        -- create table sale history
            create table sale_history (
            sale_id bigint primary key,
            customer_id bigint,
            first_name varchar(50),
            last_name varchar(50),
            product_id bigint,
            product_name varchar(50),
            prodcut_description varchar(50),
            unit_price decimal,
            quantity int ,
            total_amount decimal,
            order_id bigint,
            order_date date
            );
    ```

  - ##### [Insert Existing Data to Sale History](<Session%204%20(2.2)/SQL/Insert%20Existing%20Data%20To%20Sale%20History.sql>)

    Secondly we will fill the table with existing data.

    ```sql
        -- fill sale_history with existing data
        with sale_hist as(
        select oi.order_item_id, c.customer_id, c.first_name, c.last_name,
        p.product_id ,p.name, p.description,
        oi.unit_price::decimal, oi.quantity, (oi.quantity*oi.unit_price)::decimal as total_amount,
        o.order_id, o.order_date
        from order_item as oi
        inner join "order" as o
        on o.order_id = oi.order_fk
        inner join customer as c
        on o.customer_fk = c.customer_id
        inner join product as p
        on oi.product_fk = p.product_id
        )
        insert into sale_history (
        sale_id,customer_id,first_name ,last_name ,
        product_id ,product_name, prodcut_description ,
        unit_price,quantity, total_amount,order_id,order_date
        );
    ```

  - ##### [Trigger to Synchronize Sale History](<\Session%204%20(2.2)\SQL\Create%20Trigger%20On%20Order%20Item%20Insertion.sql>)

    This trigger automatically inserts relevant order and customer details into the sale_history table whenever a new record is added to the order_item table. This ensures that the sale_history table stays up-to-date with the latest order data.

    ```sql
    -- creates a trigger function that inserts the record that fired the trigger into the sale_history table
    CREATE or REPLACE FUNCTION insert_sale_history() RETURNS trigger
        LANGUAGE plpgsql
        AS $$
        BEGIN
        -- insert statement into sale_history table
            insert into sale_history (
            sale_id,customer_id,first_name ,last_name ,
            product_id ,product_name, prodcut_description ,
            unit_price,quantity, total_amount,order_id,order_date
            )
            -- select required data for the sale history table
            select oi.order_item_id,c.customer_id,c.first_name ,c.last_name ,
            p.product_id ,p.name, p.description ,
            oi.unit_price,quantity, (oi.quantity*oi.unit_price) as total_amount, o.order_id, o.order_date
            -- joins required tables to extract data needed
            from order_item as oi
            left join product as p on p.product_id = oi.product_fk
            left join "order" as o on o.order_id = oi.order_fk
            left join customer as c on c.customer_id = o.customer_fk
            -- Includes only newly inserted order_item related data
            where oi.order_item_id = NEW.order_item_id;

        RETURN NEW;
        END;
    $$;

        -- Creates a trigger that fires on each row insert
        CREATE TRIGGER insert_sale_history_trigger AFTER INSERT ON public.order_item FOR EACH ROW EXECUTE FUNCTION public.insert_sale_history();
    ```

- ##### [Search Products Containing A Word](<Session%204%20(2.2)/SQL/Search%20Product%20Containing%20Word.sql>)

  Searches Products containing \<word\>.

  > This Script concatenates name and description of the product and uses "ILike" to compare the concatenation with a pattern where "5g" is our desired \<word\> and "%" sign matches one or more characters used before and after the word.

  ```sql
  select * from product
  where concat(name,' ',description) ILike '%5g%';
  ```

  > "5g" is used as it tests both cases whether \<word\> appears in name or in description.

  Result:
    <p> 
    <img src="Session 4 (2.2)/Search-Products-Containing-Word-Result.jpg" />
    </p>

- ##### [Product Recommendations](<\Session%204%20(2.2)\SQL\Popuar%20Relative%20Product%20Recommendations.sql>)

  **Popular Relative Product Recommendation:** which are products by same author and same category that are not purchased by the customer before ordering results by popularity.

    <p>
    <img src="Session 4 (2.2)/Product-Recommendations-Explaination-1.jpg"/>
    </p>

  Achieving the desired results has four requirements (Relative Products, Related Orders ,Customer Non Purchased Products ,Popularity )

  - **Reltive Products:** products by same author and same category of the selected product.
     <p>
    <img src="Session 4 (2.2)/Related-Products.jpg"/>
    </p>

  - **Relative Orders:** Orders containing related products to calculate popularity and determine non purchased products.
    <p>
    <img src="Session 4 (2.2)/Related-Orders.jpg"/>
    </p>

  - **Customer Non Purchased Products:** An anti-join between related products and related orders will be used to filter non purchased products.
    ```sql
    FROM
        RELATIVE_PRODUCTS AS RP
        -- Anti join to filter non purchased products
        LEFT JOIN RELATIVE_ORDERS AS RO
            ON RO.PRODUCT_FK = RP.PRODUCT_ID
            AND RO.CUSTOMER_FK = 20 -- Non purchased products will be null
    WHERE -- Anti join condition
        RO.CUSTOMER_FK IS NULL
    ```
  - **Popularity:** The Count of distinct customers per relative product, it will be calculated in a CTE and joined with relative products.
    <p>
    <img src="Session 4 (2.2)/product_popularity.jpg"/>
      </p>

    **Script:**

    ```sql
        WITH
            RELATIVE_PRODUCTS AS ( -- relative products of same category and same author
                -- product columns
                SELECT
                    P.PRODUCT_ID, P.NAME, P.DESCRIPTION, P.PRICE,
                    P.STOCK_QUANTITY, P.CATEGORY_FK, P.AUTHOR_FK
                FROM
                    PRODUCT AS P
                    INNER JOIN ( -- inner join to filter only matching category and author from products
                        SELECT -- select category_fk ad author_fk of a specific product
                            CATEGORY_FK, AUTHOR_FK
                        FROM PRODUCT
                        WHERE PRODUCT_ID = 20
                    ) AS R
                    ON R.CATEGORY_FK = P.CATEGORY_FK
                    AND R.AUTHOR_FK = P.AUTHOR_FK -- filters products by category and author
            ),
            RELATIVE_ORDERS AS ( -- set containing distinct (buyer and relative_product)
                -- selecting distinct product and customer
                SELECT
                    PRODUCT_FK, CUSTOMER_FK
                    -- relative products CTE
                FROM
                    RELATIVE_PRODUCTS AS RP
                    -- join and filter only order_items having relative products
                    INNER JOIN ORDER_ITEM AS OI
                    ON RP.PRODUCT_ID = OI.PRODUCT_FK
                    -- join orders to determine products buyers
                    INNER JOIN "order" AS O
                    ON O.ORDER_ID = OI.ORDER_FK
                    -- group product and customer eliminating duplicates duplicates
                GROUP BY
                    PRODUCT_FK, CUSTOMER_FK
            ),
            PRODUCT_POPULARITY AS ( -- set containing product popularity and
                SELECT -- product_fk for joining & popularity
                    RO.PRODUCT_FK, COUNT(CUSTOMER_FK) AS BUYERS
                    -- This CTE already has no duplicates
                FROM RELATIVE_ORDERS AS RO
                GROUP BY PRODUCT_FK
            )

        SELECT -- product details and popularity
            RP.PRODUCT_ID, RP.NAME, RP.DESCRIPTION, RP.STOCK_QUANTITY,
            RP.CATEGORY_FK, RP.AUTHOR_FK, POP.BUYERS
        FROM
            RELATIVE_PRODUCTS AS RP
            -- left join to include product popularity
            LEFT JOIN PRODUCT_POPULARITY AS POP
                ON POP.PRODUCT_FK = RP.PRODUCT_ID
            -- Anti join to filter non purchased products
            LEFT JOIN RELATIVE_ORDERS AS RO
                ON RO.PRODUCT_FK = RP.PRODUCT_ID
                AND CUSTOMER_FK = 20
        WHERE -- Anti join condition
            RO.CUSTOMER_FK IS NULL
        ORDER BY -- sort by popularity
            BUYERS DESC
        LIMIT 10; -- only top 10 popular products

    ```

    Result:

    <p>
    <img src="Session 4 (2.2)/Product-Recommendations-Result.jpg"/>
    </p>
