# Retail_sales_analysis_sql_P1

PROJECT OVERVIEW

Project Title: Retail Sales Analysis
Database: sql_project_p1

OBJECTIVES:
Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

PROJECT STRUCTURE:

1. Database Setup : 
Database Creation: The project starts by creating a database named sql_project_p1.
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale_date, sale_time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE SQL_project_p1;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

2. Data Exploration & Cleaning : 
Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.

```sql

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

1. Find the total sales for each category.
```sql
SELECT 
    category, SUM(total_Sale) AS Total_Sales
FROM
    retail_sales
GROUP BY category
ORDER BY Total_sales DESC;
```

2. Get the total number of transactions for each gender
```sql
SELECT 
    Gender, COUNT(*) AS Total_Transactions
FROM
    Retail_sales
GROUP BY Gender;
```

3. Retrieve all sales records for the "Clothing" category.
```sql
SELECT 
    *
FROM
    Retail_sales
WHERE
    Category = 'Clothing';
```

4. Find the total quantity of products sold per category.
```sql
SELECT 
    Category, SUM(quantity) AS Total_Quantity
FROM
    Retail_sales
GROUP BY Category;
```

5. Get the average total sale per transaction for each category.
```sql
SELECT
    Category,
    AVG(total_sale) AS average_total_sale
FROM
    Retail_sales
GROUP BY
    Category;
```
    
6. Find the month with the highest sales.
```sql
SELECT 
    MONTHNAME(sale_date) AS Month_name,
    SUM(total_Sale) AS Total_sales
FROM
    retail_sales
GROUP BY Month_name
ORDER BY Total_sales DESC
LIMIT 1;
```

7. Identify customers who have made more than 2 purchases.
```sql
SELECT 
    customer_id, COUNT(*) AS Number_of_purchases
FROM
    retail_sales
GROUP BY customer_id
HAVING Number_of_purchases > 2;
```
8. Calculate the profit for each transaction (Profit = Total Sale - COGS).
```sql
SELECT 
    Transactions_id,
    cogs,
    total_sale,
    ROUND((Total_sale - cogs), 2) AS Profit
FROM
    retail_sales;
```

9. Rank customers based on their total spending.
```sql
select customer_id,
sum(total_sale) as Total_spending,
rank() over(order by sum(total_sale) desc) as Rank_of_customer
from retail_sales
group by customer_id
order by total_spending desc;
```

10. Calculate the month-over-month revenue growth.
```sql
select *,
(Current_month_revenue - Previous_month_revenue) as month_over_month_revenue
from(
select month(sale_date) Monthh, year(sale_date) yearr,
sum(total_Sale) as Current_month_revenue,
lag(sum(total_Sale),1,0) over(partition by year(sale_date) order by month(sale_date)) as Previous_month_revenue
from retail_sales
group by monthh,yearr 
order by yearr) t;
```

11. Find customers who haven’t purchased anything in the last 3 months.
```sql
SELECT *
from(
select customer_id,
sale_date as CurrentDate,
lag(sale_date,1,NULL) over(partition by customer_id order by sale_date) as Previous_order_date,
datediff(sale_date , lag(sale_date,1,NULL) over(partition by customer_id order by sale_date)) as Days_between_next_order
from retail_sales) t
where Previous_order_date is NULL or Days_between_next_order >= 90 ;
```

12. Calculate the running total of sales over time.
```sql
select *,
sum(total_sale) over(order by sale_date) as running_total
from retail_sales;
```

13. Find the most profitable category (Total Sales - Total COGS).
```sql
SELECT category, 
       Total_Sales, 
       Total_COGS, 
       (Total_Sales - Total_COGS) AS profit
FROM (
    SELECT category,
           SUM(total_sale) AS Total_Sales,
           SUM(cogs) AS Total_COGS
    FROM retail_sales
    GROUP BY category
) t
ORDER BY profit DESC
LIMIT 1;
```

14. Get the top 5 highest single transactions based on total sales.
```sql
SELECT 
    *
FROM
    retail_sales
ORDER BY total_sale DESC
LIMIT 5;
```

15. Find the average price per unit for each category.
```sql
SELECT 
    category, AVG(price_per_unit) AS Average_unit_Price
FROM
    retail_sales
GROUP BY category;

```

16. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rn
FROM retail_sales
GROUP BY year, month
) as t1
WHERE rn = 1;
```

17. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
```sql
SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN
            HOUR(sale_time) >= 12
                AND HOUR(sale_time) <= 17
        THEN
            'Afternoon'
        ELSE 'Evening'
    END AS Shift,
    COUNT(*) AS Number_Of_Orders
FROM
    retail_sales
GROUP BY shift
ORDER BY Number_Of_Orders DESC;
```



KEY FINDINGS:

1.Category Performance:
Identified top-selling and most profitable product categories.
Analyzed average sales and quantity sold per category.

2. Customer Behavior:
Determined gender-based transaction patterns.
Ranked customers by spending and identified loyal customers.
Found customers inactive for 3 months, indicating potential churn.

3. Sales Trends:
Pinpointed the month with the highest overall sales and best-selling months per year.
Calculated month-over-month revenue growth.
Tracked running total sales over time.
Identified peak order times by shift.

4. Transaction Analysis:
Calculated profit per transaction.
Listed the top 5 highest single transactions.
Calculated average price per unit per category.
