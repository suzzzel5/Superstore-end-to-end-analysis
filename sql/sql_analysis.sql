-- Created Table 
CREATE TABLE superstore(
    row_id INT PRIMARY KEY,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50),
    product_id VARCHAR(25),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200),
    sales DECIMAL(10,2)
);

select * from superstore

select customer_name ,
count(distinct order_id) as total_orders,
round(sum(sales),2) as total_sales
from superstore
group by customer_name 
order by total_sales  desc
limit 10;

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (), 1) AS pct_of_total --sum(sum(sales) over(),1 ) IS windows function that calculate the grand total without collapsing group by
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

select category , sub_category, 
round(sum(sales),2) as total_sales,
count(distinct order_id) as total_orders
from superstore
group by 1,2
order by total_orders desc;

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time buyer'
        ELSE 'Repeat buyer'
    END AS customer_type,
    COUNT(*) AS num_customers,
    SUM(total_sales) AS total_sales_from_group
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY customer_id
) customer_summary
GROUP BY customer_type;

select customer_name ,
count(distinct order_id) as total_orders,
round(sum(sales),2) as total_sales
from superstore
group by customer_name 
order by total_sales  desc
limit 10;

--Customer Analysis (TOp customers)
select customer_name ,
count(distinct order_id) as total_orders,
round(sum(sales),2) as total_sales
from superstore
group by customer_name 
order by total_sales as desc;

--Category and sub-category performance
SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER (), 1) AS pct_of_total
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

--Why 2017 spiked the sell up to 30$
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    ROUND(SUM(sales) / COUNT(DISTINCT customer_id), 2) AS avg_sales_per_customer
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;

SELECT
    year,
    total_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY year))
        / LAG(total_sales) OVER (ORDER BY year) * 100, 1
    ) AS yoy_growth_pct
FROM (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY EXTRACT(YEAR FROM order_date)
) yearly_sales
ORDER BY year;

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;





