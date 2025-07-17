# General information
This is my first project that I did completely myself after one month of learning SQL.
# Data analysis steps performed
1. Define Objective: Examine how the time of day and year affect purchasing habits in a coffee shop. Analysing such data can help improve service (e.g., by increasing the number of employees during core hours) and assist with ordering.
2. Collect Data: The Data source file contains transaction records (almost 150,000 rows) for Maven Roasters, a fictitious coffee shop operating out of three NYC locations. Dataset includes the transaction date, timestamp and location, along with product-level details: https://www.kaggle.com/datasets/ahmedabbas757/coffee-sales
4. Clean Data: Prepare data by handling errors and formatting.
5. Explore and Analyse Data: Understand data patterns using visualisations.
6. Interpret Results: Conclude the analysis.
7. Communicate Findings: Present results clearly with visualisations.
8. Make Recommendations: Suggest actions based on insights.


# SQL code

After spending one week learning SQL, I wanted to use some basic SQL commands in data analysis: ORDER BY, LIMIT, GROUP BY, WHERE, SELECT DISTINCT, WHERE using wildcards, WHERE BETWEEN AND, COUNT(*), CREATE TABLE, ALTER TABLE, ALTER COLUMN, DROP COLUMN, DROP TABLE. No CTEs, window functions or JOINs were used.
```sql
-- Create database
CREATE DATABASE coffee_sales;

-- Create table and specify data type
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
Change 'price' data type to NUMERIC and replace ',' with '.' ',' in 'price' column casued issue with inserting data.
PostgreSQL expects a period (.) as the decimal separator for numeric types. */
ALTER TABLE transactions
ALTER COLUMN price TYPE numeric USING REPLACE(price, ',', '.')::numeric;

-- Test 
SELECT *
FROM transactions
LIMIT 50;
```


# Power BI

I connected Power BI to a local PostgreSQL server and the coffee_sales database. The data was cleaned and transformed, including extracting the month and year from the date field and combining them into a new column. Additionally, I used Copilot to assist in generating a DAX query that accurately categorized each transaction_time into the appropriate time of day.

![image](https://github.com/user-attachments/assets/f597996a-ce37-424e-8a2f-b2ccb6c62edb)


**Dashboard**

![image](https://github.com/user-attachments/assets/d5bb29a0-d0c2-48c4-8483-48a3603dca7e)

# Stack
- PostgreSQL
- VSCode
- Power BI
- Excel
- GitHub


