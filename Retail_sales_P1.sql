-- 1️ Find the total sales for each category.
SELECT 
    category, SUM(total_Sale) AS Total_Sales
FROM
    retail_sales
GROUP BY category
ORDER BY Total_sales DESC;
 
-- 2️ Get the total number of transactions for each gender
SELECT 
    Gender, COUNT(*) AS Total_Transactions
FROM
    Retail_sales
GROUP BY Gender;

-- 3️ Retrieve all sales records for the "Clothing" category.
SELECT 
    *
FROM
    Retail_sales
WHERE
    Category = 'Clothing';

-- 4️ Find the total quantity of products sold per category.
SELECT 
    Category, SUM(quantity) AS Total_Quantity
FROM
    Retail_sales
GROUP BY Category;

-- 5️ Get the average total sale per transaction for each category.
SELECT
    Category,
    AVG(total_sale) AS average_total_sale
FROM
    Retail_sales
GROUP BY
    Category;
    
-- 6️ Find the month with the highest sales.
SELECT 
    MONTHNAME(sale_date) AS Month_name,
    SUM(total_Sale) AS Total_sales
FROM
    retail_sales
GROUP BY Month_name
ORDER BY Total_sales DESC
LIMIT 1;

-- 7️ Identify customers who have made more than 2 purchases.
SELECT 
    customer_id, COUNT(*) AS Number_of_purchases
FROM
    retail_sales
GROUP BY customer_id
HAVING Number_of_purchases > 2;

-- 8️ Calculate the profit for each transaction (Profit = Total Sale - COGS).
SELECT 
    Transactions_id,
    cogs,
    total_sale,
    ROUND((Total_sale - cogs), 2) AS Profit
FROM
    retail_sales;


-- 9️ Rank customers based on their total spending.
select customer_id,
sum(total_sale) as Total_spending,
rank() over(order by sum(total_sale) desc) as Rank_of_customer
from retail_sales
group by customer_id
order by total_spending desc;


-- 10 Calculate the month-over-month revenue growth.
select *,
(Current_month_revenue - Previous_month_revenue) as month_over_month_revenue
from(
select month(sale_date) Monthh, year(sale_date) yearr,
sum(total_Sale) as Current_month_revenue,
lag(sum(total_Sale),1,0) over(partition by year(sale_date) order by month(sale_date)) as Previous_month_revenue
from retail_sales
group by monthh,yearr 
order by yearr) t;

-- 1️1 Find customers who haven’t purchased anything in the last 3 months.
SELECT *
from(
select customer_id,
sale_date as CurrentDate,
lag(sale_date,1,NULL) over(partition by customer_id order by sale_date) as Previous_order_date,
datediff(sale_date , lag(sale_date,1,NULL) over(partition by customer_id order by sale_date)) as Days_between_next_order
from retail_sales) t
where Previous_order_date is NULL or Days_between_next_order >= 90 ;

-- 1️2 Calculate the running total of sales over time.
select *,
sum(total_sale) over(order by sale_date) as running_total
from retail_sales;

-- 1️3 Find the most profitable category (Total Sales - Total COGS).
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

-- 1️4 Get the top 5 highest single transactions based on total sales.
SELECT 
    *
FROM
    retail_sales
ORDER BY total_sale DESC
LIMIT 5;

-- 1️5 Find the average price per unit for each category.
SELECT 
    category, AVG(price_per_unit) AS Average_unit_Price
FROM
    retail_sales
GROUP BY category;


-- 16.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
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

-- 17.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
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