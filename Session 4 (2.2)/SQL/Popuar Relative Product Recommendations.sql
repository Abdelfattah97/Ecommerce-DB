WITH
	RELATIVE_PRODUCTS AS ( -- relative products of same category and same author
		-- product columns
		SELECT
			P.PRODUCT_ID,
			P.NAME,
			P.DESCRIPTION,
			P.PRICE,
			P.STOCK_QUANTITY,
			P.CATEGORY_FK,
			P.AUTHOR_FK
		FROM
			PRODUCT AS P
			INNER JOIN ( -- inner join to filter only matching category and author from products 
				-- select category_fk ad author_fk of a specific product
				SELECT
					CATEGORY_FK,
					AUTHOR_FK
				FROM
					PRODUCT
				WHERE
					PRODUCT_ID = 20
			) AS R ON R.CATEGORY_FK = P.CATEGORY_FK
			AND R.AUTHOR_FK = P.AUTHOR_FK -- filters products by category and author
	),
	RELATIVE_ORDERS AS ( -- set containing distinct (buyer and relative_product)
		-- selecting distinct product and customer
		SELECT
			PRODUCT_FK,
			CUSTOMER_FK
			-- relative products CTE
		FROM
			RELATIVE_PRODUCTS AS RP
			-- join and filter only order_items having relative products 
			INNER JOIN ORDER_ITEM AS OI ON RP.PRODUCT_ID = OI.PRODUCT_FK
			-- join orders to determine products buyers
			INNER JOIN "order" AS O ON O.ORDER_ID = OI.ORDER_FK
			-- group product and customer eliminating duplicates duplicates
		GROUP BY
			PRODUCT_FK,
			CUSTOMER_FK
	) ,
	PRODUCT_POPULARITY AS ( -- set containing product popularity and
		SELECT
			RO.PRODUCT_FK,
			COUNT(CUSTOMER_FK) AS BUYERS
		FROM
			RELATIVE_ORDERS AS RO
		GROUP BY
			PRODUCT_FK
	)
	-- product details and popularity
SELECT
	RP.PRODUCT_ID,
	RP.NAME,
	RP.DESCRIPTION,
	RP.STOCK_QUANTITY,
	RP.CATEGORY_FK,
	RP.AUTHOR_FK,
	BUYERS
FROM
	RELATIVE_PRODUCTS AS RP
	-- left join to include product popularity
	LEFT JOIN PRODUCT_POPULARITY AS POP ON POP.PRODUCT_FK = RP.PRODUCT_ID
	-- anti join to filter non purchased products
	LEFT JOIN RELATIVE_ORDERS AS RO ON RO.PRODUCT_FK = RP.PRODUCT_ID
	AND CUSTOMER_FK = 20
WHERE
	RO.CUSTOMER_FK IS NULL
	-- sort by popularity
ORDER BY
	BUYERS DESC
	LIMIT 10;