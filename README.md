Stack: PostgreSQL, VSCode, Power BI, Excel, GitHub

Data analysis steps performed:
1. Define Objective: Examine how the time of day and year affect purchasing habits in a coffee shop. Analyzing such data can help improve service (e.g., by increasing the number of employees during core hours) and assist with ordering.
2. Collect Data: Data source file contains transaction records (almost 150 000 rows) for Maven Roasters, a fictitious coffee shop operating out of three NYC locations. Dataset includes the transaction date, timestamp and location, along with product-level details: https://www.kaggle.com/datasets/ahmedabbas757/coffee-sales
4. Clean Data: Prepare data by handling errors and formatting.
5. Explore and Analzye Data: Understand data patterns using visualizations.
6. Interpret Results: Draw conclusions from the analysis.
7. Communicate Findings: Present results clearly with visualizations.
8. Make Recommendations: Suggest actions based on insights.




**SQL code**

After spending one week on learning SQL, I wanted to use some SQL basic commands in data analysis: ORDER BY, LIMIT, GROUP BY, WHERE, SELECT DISTINCT, WHERE using wildcards, WHERE BETWEEN AND, COUNT(*), CREATE TABLE, ALTER TABLE, ALTER COLUMN, DROP COLUMN, DROP TABLE. No CTEs, window functions or JOINs were used.

I used Copilot to help me generate the below query (excluding my comments):

-- Change 'price' data type from VARCHAR(255) to NUMERIC and replace ',' with '.' due to the issues with using arithmetical operators

-- ',' in 'price' column casued issue with inserting data. PostgreSQL expects a period (.) as the decimal separator for numeric types.

ALTER TABLE transactions

ALTER COLUMN price TYPE numeric USING REPLACE(price, ',', '.')::numeric;



**Power BI**

I have connected Power BI to the local PostgreSQL server and database 'coffee_sales'. Data was manipulated and transformed, e.g., extracting month and year from date and merging it in new column. I used Copilot to help me generate DAX query to assign the correct time of the day to the transaction_time:

![image](https://github.com/user-attachments/assets/f597996a-ce37-424e-8a2f-b2ccb6c62edb)


Dashboard

![image](https://github.com/user-attachments/assets/d5bb29a0-d0c2-48c4-8483-48a3603dca7e)



