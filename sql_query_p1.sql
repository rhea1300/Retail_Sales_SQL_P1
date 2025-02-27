--Retail Sales Project

CREATE DATABASE retail_sale;

CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales;
SELECT * FROM retail_sales LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning

SELECT * FROM retail_sales WHERE transactions_id IS NULL;

DELETE FROM retail_sales WHERE 
transactions_id IS NULL 
OR sale_date IS NULL
OR sale_time IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
or total_sale IS NULL;

-- Data exploration

-- How many sales, unique customers and cartegories do we have?

SELECT COUNT(*) AS total_sales FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

--Data Analysis and Business Key problems and answers

--Q1: Retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'

--Q2: Retrieve all transactions where category is Clothing, and the Qty sold is more than or equal to 4 in the month of Nov-2022

SELECT * FROM retail_sales WHERE category = 'Clothing' AND quantity >= 4 AND sale_date >='2022-11-01' AND sale_date <'2022-12-01';

--Calculate total_sales and total orders for each category

SELECT category, 
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales GROUP BY category;

--Find average age of customers who purchased items from 'Beauty' category

SELECT category, ROUND(AVG(age),2) AS average_age FROM retail_sales 
GROUP BY category 
HAVING category='Beauty';

--Second option
SELECT ROUND(AVG(age),2) AS average_age 
FROM retail_sales 
WHERE category='Beauty'

--Find all transactions where total_sale is greater than 1000

SELECT * FROM retail_sales 
WHERE total_sale >1000;

--Find total number of transactions made by each gender in each category
SELECT category, gender, COUNT(*) FROM retail_sales 
GROUP BY category,gender ORDER BY 1;

--Find average sale of each month, and find out best selling month in each year 

SELECT year, month, avg_sale FROM (
SELECT 
EXTRACT(YEAR from sale_date) AS year,
EXTRACT(MONTH from sale_date) AS month,
AVG(total_sale) as avg_sale,
RANK() OVER (PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales 
GROUP BY year, month
) 
WHERE rank =1; 
--ORDER BY 1,3 DESC;

--Find top 5 customers based on highest total sales

SELECT customer_id, SUM(total_sale) as final_sale, 
RANK() OVER (ORDER BY SUM(total_sale) DESC) as rank
FROM retail_sales
GROUP BY customer_id LIMIT 5 ; 

--easier: 
SELECT customer_id, SUM(total_sale) as final_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY final_sale DESC
LIMIT 5;

--Find number of unique customers who pruchased an item from each category 

SELECT COUNT(DISTINCT(customer_id)) as unique_customer_count, category 
FROM retail_sales
GROUP BY category;

--Find number of orders for different shifts (i.e. Morning <=12, Afternoon between 12 -17 and Evening > 17)
--BETWEEN includes both the numbers mentioned

WITH hourly_sale
AS
(
SELECT * ,
CASE 
	WHEN EXTRACT(HOUR from sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as shift
FROM retail_sales
)
SELECT COUNT(*) as total_orders, shift
FROM hourly_sale 
GROUP BY shift;

--End of Project

