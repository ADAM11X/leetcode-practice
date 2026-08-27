WITH FULL_TABLE AS (
SELECT 
s.sale_id ,
p.product_name,
p.category ,
p.product_id  ,
s.sale_date  ,
s.quantity ,
s.price ,
s.price * s.quantity as revenue 
FROM sales s
LEFT JOIN products P
ON s.product_id = p.product_id 
),
SEASONS AS (
    SELECT 
    *,
    CASE 
        WHEN MONTH(sale_date) IN (3 ,4, 5)      THEN 'Spring'
        WHEN MONTH(sale_date) IN (6 ,7, 8)      THEN 'Summer'
        WHEN MONTH(sale_date) IN (9 ,10, 11)    THEN 'Fall'
        WHEN MONTH(sale_date) IN (12 , 1 , 2)   THEN 'Winter'
    END AS season
    FROM  FULL_TABLE
),
top_one as (

    SELECT  
    season  ,
    category ,
    sum(quantity) AS  total_quantity ,
    sum(revenue) AS total_revenue ,
    ROW_NUMBER() OVER(PARTITION BY season ORDER BY  sum(revenue)  DESC) AS RN
    FROM SEASONS  
    GROUP BY season , category 
)

SELECT 
season,
category,
total_quantity,
total_revenue
FROM top_one
WHERE RN<=1
ORDER BY season ASC , total_revenue DESC
