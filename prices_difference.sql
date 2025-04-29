SELECT *
FROM transactions
LIMIT 100;

-- Drop unnecessary column
ALTER TABLE transactions
DROP COLUMN transaction_qty;

-- The below SQL query clearly shows that prices are the same in every coffee shop.
-- Coffee shop location doesn't affect on any prices.
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