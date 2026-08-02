-- Walmart Sales Analysis Queries

-- Displaying whole table
SELECT * FROM walmart;

-- Count total record
SELECT COUNT(*) FROM walmart;

-- Number of Distinct branches
SELECT COUNT(DISTINCT branch) FROM walmart;

-- Find the minimum and maximum quantities sold
SELECT MIN(quantity) AS min_quantity, MAX(quantity) AS max_quantity FROM walmart;

-- Business Problems

-- Q1: What are the different payment methods, and how many transactions and items were sold with each method?
SELECT 
    payment_method, 
    COUNT(*) AS no_of_payments,
    SUM(quantity) AS num_quantities_sold
FROM walmart
GROUP BY payment_method
ORDER BY no_of_payments DESC, num_quantities_sold DESC;


-- Q2: Which category received the highest average rating in each branch?
SELECT branch, category, avg_rating, rating_rank
FROM (
    SELECT 
        branch,
        category, 
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rating_rank 
    FROM walmart
    GROUP BY branch, category
) AS rank_table
WHERE rating_rank = 1;


-- Q3: What is the busiest day of the week for each branch based on transaction volume?
SELECT *
FROM (
    SELECT 
        branch, 
        DAYNAME(date) AS day_name,
        COUNT(*) AS no_of_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS day_rank
    FROM walmart
    GROUP BY branch, day_name
) AS t1
WHERE day_rank = 1;


-- Q4: How many items were sold through each payment method?
SELECT 
    payment_method, 
    SUM(quantity) AS total_quantities_sold
FROM walmart
GROUP BY payment_method
ORDER BY total_quantities_sold DESC;


-- Q5: What are the average, minimum, and maximum ratings for each category in each city?
SELECT 
    city,
    category, 
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM walmart
GROUP BY city, category;


-- Q6: What is the total profit for each category, ranked from highest to lowest?
SELECT 
    category,
    SUM(total) AS total_revenue,
    SUM(total * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;


-- Q7: What is the most frequently used payment method in each branch?
WITH my_cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS no_of_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS payment_rank
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT 
    branch,
    payment_method AS preferred_payment_method
FROM my_cte
WHERE payment_rank = 1;


-- Q8: How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
SELECT 
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening' 
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;


-- Q9: Which top 5 branches experienced the largest decrease in revenue compared to the previous year?
-- Revenue Ratio = (Last Year Revenue - Current Year Revenue) * 100 / (Last Year Revenue) 
WITH table_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart 
    WHERE YEAR(date) = 2022
    GROUP BY branch
),
table_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart 
    WHERE YEAR(date) = 2023
    GROUP BY branch
)
SELECT 
    ls.branch,
    ls.revenue AS last_year_revenue,
    cs.revenue AS cr_year_revenue,
    ROUND(((ls.revenue - cs.revenue) / ls.revenue * 100), 2) AS revenue_decrease_ratio
FROM table_2022 AS ls
JOIN table_2023 AS cs
    ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;