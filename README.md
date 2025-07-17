# General information
This was my first project after two weeks of learning SQL. I wanted to apply basic SQL commands in a practical data analysis scenario. I used statements such as ORDER BY, LIMIT, GROUP BY, WHERE, SELECT DISTINCT, WHERE with wildcards, WHERE BETWEEN ... AND, COUNT(*), as well as CREATE TABLE, ALTER TABLE, ALTER COLUMN, DROP COLUMN, and DROP TABLE. I intentionally kept the scope simple—avoiding CTEs, window functions, and JOINs—to focus on mastering the core SQL syntax and logic.

## Data analysis steps performed
1. Define Objective: Examine how the time of day and year affect purchasing habits in a coffee shop. Analysing such data can help improve service (e.g., by increasing the number of employees during core hours) and assist with ordering.
2. Collect Data: The Data source file contains transaction records (almost 150,000 rows) for Maven Roasters, a fictitious coffee shop operating out of three NYC locations. Dataset includes the transaction date, timestamp and location, along with product-level details: https://www.kaggle.com/datasets/ahmedabbas757/coffee-sales
4. Clean Data: Prepare data by handling errors and formatting.
5. Explore and Analyse Data: Understand data patterns using visualisations.
6. Interpret Results: Conclude the analysis.
7. Communicate Findings: Present results clearly with visualisations.

## SQL 
```sql
-- Create database
CREATE DATABASE coffee_sales;

-- Create a table and specify the data type
CREATE TABLE transactions (
    transaction_id INTEGER,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INTEGER,
    store_id INTEGER,
    store_location VARCHAR(255),
    product_id INTEGER,
    price NUMERIC(6,2),
    product_category VARCHAR(255),
    product_type VARCHAR(255),
    product_detail VARCHAR(255)
);

DROP TABLE transactions;

-- Change 'price' data type to VARCHAR (NUMERIC causes issues when uploading file)
ALTER TABLE transactions
ALTER COLUMN price TYPE VARCHAR(255);

/* I used Copilot to help me generate the below query.
Change 'price' data type to NUMERIC and replace ',' with '.' ',' in 'price' column caused issue with inserting data.
PostgreSQL expects a period (.) as the decimal separator for numeric types. */
ALTER TABLE transactions
ALTER COLUMN price TYPE numeric USING REPLACE(price, ',', '.')::numeric;

-- Test 
SELECT *
FROM transactions
LIMIT 50;
```


## Power BI

I connected Power BI to a local PostgreSQL server and the coffee_sales database. The data was cleaned and transformed, including extracting the month and year from the date field and combining them into a new column. Additionally, I used Copilot to assist in generating a DAX query that accurately categorised each transaction_time into the appropriate time of day.
```PowerShell
= Table.AddColumn(#"Extracted Month1", "Custom", each if [transaction_time] <= #time(12, 0, 0) then "Morning"
else if [transaction_time] <= #time(18, 0, 0) then "Afternoon"
else "Evening")
```

**Dashboard**

![image](https://github.com/user-attachments/assets/d5bb29a0-d0c2-48c4-8483-48a3603dca7e)

## Conclude the analysis
I observed that sales across all coffee shop locations are influenced by the time of year. This seasonal trend suggests that customer behaviour and purchasing patterns vary throughout the year, which could be valuable for forecasting demand, planning promotions, or optimising inventory. 
```sql
-- Daily transaction count during winter. A growing number of transactions. Peak in March 2023.
SELECT
    transaction_date::date AS day,
    COUNT(*) AS transaction_count
FROM 
    transactions
WHERE
    transaction_date BETWEEN '2023-01-01' AND '2023-03-20'
GROUP BY
    day
ORDER BY
    day;

-- Daily transaction count during spring. A growing number of transactions. Peak at the end of June 2023.
SELECT
    transaction_date::date AS day,
    COUNT(*) AS transaction_count
FROM 
    transactions
WHERE
    transaction_date BETWEEN '2023-03-20' AND '2023-06-30'
GROUP BY
    day
ORDER BY
    day;

-- Difference in transaction count (winter vs spring)
SELECT
    transaction_date::date AS day,
    COUNT(*) AS transaction_count,
    CASE
        WHEN transaction_date BETWEEN '2023-03-20' AND '2023-06-30' THEN 'spring'
        WHEN transaction_date BETWEEN '2023-01-01' AND '2023-03-20' THEN 'winter'
        ELSE 'other'
    END AS season
FROM 
    transactions
GROUP BY
    day, season
ORDER BY
    day;
```
Interestingly, during the analysis, I discovered that the pricing structure is consistent across all coffee shop locations—every product is sold at the same price regardless of the branch. This insight suggests a centralised pricing strategy and could be a valuable starting point for further business analysis, such as evaluating the impact of location on sales volume or customer preferences.
```sql
/* The below SQL query clearly shows that prices are the same in every coffee shop.
Coffee shop location doesn't affect on the price. */
SELECT
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    MAX(price) AS max_price
FROM
    transactions
GROUP BY
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail
ORDER BY
    max_price DESC;
```


## Stack
- PostgreSQL
- VSCode
- Power BI
- Excel
- GitHub


