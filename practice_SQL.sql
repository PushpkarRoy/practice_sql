CREATE TABLE customers (
customer_id INT,
name	VARCHAR(50),
email VARCHAR(100),
age INT,
gender VARCHAR(10),
city	VARCHAR(20),
state	VARCHAR(50),
signup_date DATE
)

CREATE TABLE order_items (
order_item_id INT,
order_id INT,
product_id INT,
product_name VARCHAR(50),
category VARCHAR(50),
price FLOAT,
quantity INT,
is_returned VARCHAR(10)
)

CREATE TABLE orders(
order_id INT,
customer_id INT,
order_date	 DATE,
total_amount FLOAT,
payment_method VARCHAR(20),
discount_applied VARCHAR(10),
order_status VARCHAR(20),
shipping_city VARCHAR(50)
)


SELECT * FROM customers 
SELECT * FROM order_items
SELECT * FROM orders 

-- 1. Top 5 most returned products (by return count and % of sold items)

SELECT  oi.product_name, 
		COUNT(o.order_status) AS total_return_product,
		ROUND(COUNT(order_status) * 100.0 / ( SELECT COUNT(order_status)
										FROM orders
										WHERE order_status = 'Returned'):: NUMERIC ,2) AS return_percentage

FROM order_items AS oi
JOIN orders AS o
ON oi.order_id = o.order_id
WHERE order_status = 'Returned'
GROUP BY  oi.product_name 
ORDER BY total_return_product DESC	


-- 2. Customers who placed orders from more than 2 different citie

SELECT name , COUNT(DISTINCT shipping_city) AS total_city
FROM orders AS o
JOIN customers AS c
ON c.customer_id = o.customer_id 
GROUP BY name 
HAVING COUNT(DISTINCT shipping_city) > 2
ORDER BY total_city DESC

-- ___________________________________________OR____________________________________________

SELECT name, shipping_city
FROM (
	SELECT *,
	RANK() OVER(PARTITION BY name ORDER BY total_amount) AS ranking
	FROM (
		SELECT c.name,  o.shipping_city, COUNT(DISTINCT o.shipping_city) AS total_city, o.total_amount
		FROM customers AS c
		JOIN orders AS 	o
		ON c.customer_id = o.customer_id
		GROUP BY c.name, o.shipping_city, o.total_amount
		ORDER BY total_city DESC ) AS x ) AS y
WHERE ranking > 1

-- 3. Monthly customer retention rate (repeat customers month over month)

SELECT  EXTRACT(YEAR FROM order_date) AS order_year,
		EXTRACT(MONTH FROM order_date) AS Month_no, 
		TO_CHAR(order_date, 'Month') AS Month_order, 
		COUNT(order_id) AS total_order,
		ROUND(COUNT(order_id) * 100.0 /(  SELECT COUNT(order_id)
									FROM orders ):: NUMERIC, 2) AS order_rate_by_percentage
FROM orders 
GROUP BY Month_no, Month_order, order_year
ORDER BY order_year, month_no

-- 4. Customers who never used a discount but made purchases > ₹10,000

SELECT c.name,
		ROUND(SUM(o.total_amount):: NUMERIC ,2) AS total_purchases, o.discount_applied
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.name, o.discount_applied
HAVING discount_applied = 'True' AND SUM(o.total_amount) > 10000

-- 5. Which payment method yields the highest average order value?

SELECT payment_method,  ROUND(AVG(total_amount):: NUMERIC,2) AS avg_amount
FROM orders 
GROUP BY payment_method
ORDER BY avg_amount DESC

-- 6. Compare revenue of top 3 cities in Q1 vs Q2 — highlight growth %

SELECT city, order_month, qtr, 
ROUND(AVG(avg_amount) OVER(PARTITION BY city ORDER BY avg_amount DESC):: NUMERIC ,2) AS final_avg_value
FROM (
	SELECT  EXTRACT(MONTH FROM order_date) AS month_no, c.city,
			TO_CHAR(order_date, 'Month') AS Order_month,
			ROUND(AVG(total_amount):: NUMERIC ,2) AS Avg_amount,
			CASE 
				WHEN order_date BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Q1'
				WHEN order_date  BETWEEN'2024-04-01' AND '2024-06-30' THEN 'Q2'
				END AS Qtr
	FROM orders AS o
	JOIN customers AS c
	ON c.customer_id = o.customer_id
	WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30'
	GROUP BY month_no, order_month, qtr, c.city
	ORDER BY month_no, qtr ) AS x
ORDER BY qtr, month_no 

-- ----------------------------------- or --------------------------------------------------

SELECT *,
RANK() OVER(PARTITION BY city ORDER BY qtr) AS final_ranking
FROM (
	SELECT DISTINCT city, amount, qtr,
	ROUND(AVG(amount) OVER(PARTITION BY city ORDER BY qtr):: NUMERIC ,2) AS avg_amount
	FROM (
		SELECT *,
		RANK() OVER(PARTITION BY qtr ORDER BY amount DESC) AS ranking
		FROM (
			SELECT city, ROUND(SUM(total_amount):: NUMERIC ,2) AS amount,
					CASE 
						WHEN order_date BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Q1'
						WHEN order_date  BETWEEN'2024-04-01' AND '2024-06-30' THEN 'Q2'
					END AS qtr
			FROM customers AS c
			JOIN orders AS o
			ON c.customer_id = o.customer_id 
			WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30'
			GROUP BY city, qtr
			ORDER BY qtr ) AS x ) AS y
	WHERE ranking <= 5 ) AS z	
		
-- 7. Identify customers whose total purchase quantity of 'Electronics' is > 15 but never returned a product

SELECT * FROM customers 
SELECT * FROM orders 
SELECT * FROM order_items

SELECT c.customer_id, c.name, o.order_status, oi.category, SUM(oi.quantity) AS total_quantity
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id 
JOIN order_items AS oi
ON oi.order_id = o.order_id
WHERE category = 'Electronics'  AND order_status != 'Returned' 
GROUP BY c.customer_id, c.name, o.order_status, oi.category
HAVING SUM(oi.quantity) > 15
ORDER BY total_quantity DESC

-- 8. Find top 3 product categories that were most affected by returns (by return rate)

SELECT  oi.category,
		o.order_status,
		COUNT(order_status) AS total_return,
		ROUND(COUNT(o.order_status) * 100.0 / ( SELECT COUNT(order_status)
										        FROM orders ):: NUMERIC, 2) AS return_rate
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY oi.category, o.order_status
HAVING  o.order_status = 'Returned' 	
ORDER BY total_return DESC

-- 9. Which customers made orders every month in the last 6 months? (Consistent buyers)

SELECT name AS Consistent_buyers
FROM (
	SELECT *,
	RANK() OVER(PARTITION BY name ORDER BY order_date) AS monthly_order
	FROM (
		SELECT EXTRACT(MONTH FROM order_date) AS month_no, 
				TO_CHAR(order_date, 'Month') AS order_month,
				c.name, order_date
		FROM orders AS o
		JOIN customers AS c
		ON c.customer_id = o.customer_id
		WHERE order_date BETWEEN '2025-01-01' AND '2025-07-06'
		ORDER BY month_no DESC ) AS x ) AS z		
WHERE  monthly_order = 7

-- 10. List customers who signed up in the last 60 days and already made ≥ 2 purchases

SELECT c.customer_id, c.name, c.signup_date, COUNT(oi.order_item_id) AS total_order
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id 
JOIN order_items AS oi
ON oi.order_id = o.order_id 
WHERE signup_date >= CURRENT_DATE - INTERVAL '6 Month'
GROUP BY c.customer_id, c.name, c.signup_date
HAVING COUNT(oi.order_item_id) >= 2
ORDER BY total_order DESC

-- 11. Find orders with unusually high discount rate (more than 30% of average order value in that month)

SELECT order_month, product_name, total_amount,
ROUND(AVG(total_amount) OVER(PARTITION BY order_month ORDER BY month_no):: NUMERIC, 2) AS avg_amount,
ROUND((SUM(total_amount) * 30.0 / 100):: NUMERIC ,2) AS discount_value
FROM (
	SELECT EXTRACT(MONTH FROM order_date) AS month_no,
			TO_CHAR(order_date, 'month') order_month,
			product_name, o.discount_applied, 
			o.total_amount
	FROM orders AS  o
	JOIN order_items AS oi
	ON o.order_id = oi.order_id
	WHERE discount_applied = 'True' ) AS x
GROUP BY order_month, product_name, total_amount, month_no
ORDER BY month_no




WITH monthly_discounts AS (
    SELECT 
        o.order_id,
        TO_CHAR(o.order_date, 'Month') AS order_month,
        EXTRACT(MONTH FROM o.order_date) AS month_no,
        o.total_amount,
        -- Calculate average monthly amount using window function
        AVG(o.total_amount) OVER (PARTITION BY EXTRACT(MONTH FROM o.order_date)) AS monthly_avg
    FROM orders o
    WHERE o.discount_applied = 'True'
)

SELECT 
    order_id,
    order_month,
    month_no,
    total_amount,
    ROUND(monthly_avg::NUMERIC, 2) AS avg_amount,
    ROUND((total_amount * 100.0 / monthly_avg)::NUMERIC, 2) AS discount_percent
FROM monthly_discounts
WHERE total_amount < 0.7 * monthly_avg
ORDER BY month_no;

-- 12. Using window functions: Rank products by total quantity sold within each category

SELECT product_name, category, SUM(quantity) AS Total_quantity,
RANK() OVER(PARTITION BY category ORDER BY SUM(quantity)) AS ranking
FROM order_items 
GROUP BY product_name, category

-- 13. For each customer, show last order date and days since last purchase

SELECT name, order_date, order_day
FROM (
	SELECT  name,
			order_date,
			TO_CHAR(order_date, 'Day') AS order_day,
			RANK() OVER(PARTITION BY name ORDER BY order_date DESC) AS ranking
	FROM orders AS o
	JOIN customers AS c
	ON c.customer_id = o.customer_id 
	GROUP BY name, order_date )
WHERE ranking = 1

-- 14. Find product categories where returned orders exceed 10% of sales (flag risky categories)

SELECT  category, 
		COUNT(order_status) AS total_return ,
		ROUND((COUNT(order_status) * 100.0 / 965):: NUMERIC , 2) AS return_percentage,
		ROUND(COUNT(order_status) * 100.0 / (SELECT COUNT(order_status)
										FROM orders):: NUMERIC ,2) AS Total_order_percentage
FROM orders AS o
JOIN order_items AS oi
ON o.order_id = oi.order_id
WHERE order_status = 'Returned'
GROUP BY category

-- 15. Calculate average basket size (items per order) for each city and rank the cities

SELECT * FROM customers 
SELECT * FROM orders 
SELECT * FROM order_items

SELECT 	* , 
RANK() OVER(ORDER BY avg_basket_size DESC) AS ranking
FROM (
	SELECT  city, 
			ROUND(AVG(quantity):: NUMERIC ,2) AS avg_basket_size, 
			ROUND(AVG(total_amount):: NUMERIC ,2) AS avg_amount
	FROM customers AS c
	JOIN orders AS o
	ON c.customer_id = o.customer_id 
	JOIN order_items AS oi
	ON oi.order_id = o.order_id 
	GROUP BY city ) AS x

