CREATE TABLE clients (
client_id INT,
client_name VARCHAR(100),
industry VARCHAR(50)
)

CREATE TABLE sales (
sale_id INT,
rep_id INT,
client_id INT,
sale_amount INT, 
sale_date DATE
)

CREATE TABLE sales_reps(
rep_id INT,
rep_name VARCHAR(50),
region VARCHAR(30)
)

-- 1. Top 3 Sales Reps by Total Sales
-- List the top 3 sales reps who generated the highest total sales.

SELECT 	sr.rep_name, SUM(s.sale_amount) AS total_sale 
FROM sales_reps AS sr
JOIN sales AS s
ON sr.rep_id = s.rep_id 
GROUP BY sr.rep_name 
ORDER BY total_sale DESC
LIMIT  3

-- 2. Monthly Sales per Sales Rep
-- Show each rep's total sales per month.

SELECT name, sale_month, 
	SUM(total_sales) OVER(PARTITION BY name ORDER BY month_no ) AS monthly_sale
FROM (
		SELECT  EXTRACT(MONTH FROM sale_date ) AS month_no,
				sr.rep_name AS name,
				TO_CHAR(sale_date, 'Month') AS sale_month,
				SUM(s.sale_amount) AS total_sales
		FROM sales AS s
		JOIN sales_reps AS sr
		ON s.rep_id = sr.rep_id 
		GROUP BY name , sale_month, month_no) AS x

-- 3. Running Total of Sales per Sales Rep
-- Use a window function to show running total of sales by each sales rep.

SELECT 	sr.rep_name AS name,
		s.sale_amount AS total_sale,
		SUM(s.sale_amount) OVER(PARTITION BY sr.rep_name ORDER BY s.sale_amount) AS running_total
FROM sales_reps AS sr	
JOIN sales AS s
ON sr.rep_id = s.rep_id 

-- 📈 4. Month-over-Month Growth
-- Show total monthly sales and growth % from the previous month.

SELECT *, 
LAG(total_sale) OVER(  ORDER BY month_no) AS difference,
ROUND((LAG(total_sale) OVER(  ORDER BY month_no) * 100.0 / 9991466):: NUMERIC ,2) AS growth_percentage 
FROM (
	SELECT  EXTRACT(MONTH FROM sale_date) AS month_no,
			TO_CHAR(sale_date, 'Month') AS sale_month,
			SUM(sale_amount) AS total_sale,
			ROUND(SUM(sale_amount) * 100.0 /     (SELECT SUM(sale_amount) 
			                               FROM sales ):: NUMERIC, 2) AS percetage 
	FROM sales 
	GROUP BY month_no, sale_month
	ORDER BY month_no ) AS x

-- 5. Rank Clients by Total Spend
-- Rank clients based on how much they spent.

SELECT 
RANK() OVER(ORDER BY total_spend DESC) AS ranking,
*
FROM (
	SELECT  c.client_name,  
			SUM(s.sale_amount) AS total_spend
	FROM clients AS c
	JOIN sales AS s
	ON c.client_id = s.client_id 
	GROUP BY client_name ) AS x

-- 6. First Sale Date for Each Sales Rep
-- When did each sales rep make their first sale?
	
SELECT DISTINCT name, date, sale_month
FROM (
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY name ORDER BY date) AS sale_ranking
	FROM (
		SELECT  sr.rep_name AS name,
				s.sale_date AS date,
				TO_CHAR(s.sale_date, 'Month') AS sale_month
		FROM sales AS s
		JOIN sales_reps AS sr
		ON s.rep_id = sr.rep_id
		ORDER BY date ) AS x ) AS y
WHERE sale_ranking = 1
				

-- 7. Day-wise Sales Trend
-- Show total sales per day for the last 30 days.

SELECT EXTRACT(DAY FROM sale_date), 
FROM sales 


SELECT  sale_date,
		TO_CHAR(sale_date, 'Day') sale_day,
		SUM(sale_amount) AS total_sale
FROM sales 
WHERE sale_date >= current_date - (INTERVAL '1 month')
GROUP BY sale_day, sale_date
ORDER BY sale_date 

	
-- 8. Total Sales per Industry
-- Join with clients and show total sales per industry.

SELECT *,
SUM(total_sale) OVER(PARTITION BY industry ORDER BY total_sale DESC) sales_by_industry
FROM (
	SELECT client_name, industry, SUM(sale_amount) as Total_sale 
	FROM clients AS c
	JOIN sales AS s
	ON c.client_id = s.client_id
	GROUP BY client_name , industry ) AS x

--  9. Highest Single Sale per Rep
-- Use window functions to find the highest sale per rep.

SELECT rep_name AS name, sale_amount AS day_sale 
FROM (
		SELECT *,
		RANK() OVER(PARTITION BY rep_name ORDER BY sale_amount DESC) AS ranking
		FROM (
			SELECT rep_name, sale_amount
			FROM sales AS s
			JOIN sales_reps AS sr
			ON sr.rep_id = s.rep_id ) AS x ) AS y
WHERE ranking = 1
ORDER BY day_sale DESC

--  10. % Contribution of Each Sale (Per Rep)
-- Show how much each sale contributes to the rep’s total sales (percentage).

SELECT  sr.rep_name , 
		SUM(s.sale_amount) AS total_sale,
		ROUND(SUM(s.sale_amount) * 100.0 / (SELECT SUM(sale_amount) 
		                             FROM sales ):: NUMERIC ,2 ) AS percentage 
FROM sales AS s
JOIN sales_reps AS sr
ON sr.rep_id = s.rep_id 
GROUP BY sr.rep_name 
ORDER BY total_sale DESC





