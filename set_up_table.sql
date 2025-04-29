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

-- Check table
SELECT *
FROM transactions
LIMIT 50;


    


















