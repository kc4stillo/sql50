-- #1378 replace employee id with the unique identifier
-- Replaces employee ID with a unique identifier from the employeeuni table.
SELECT unique_id
    , name
FROM employees
    LEFT JOIN employeeuni USING (id);

-- #1068 product sales analysis i
-- Analyzes product sales by retrieving product names, year, and price from combined sales and product tables.
SELECT product_name
    , year
    , price
FROM sales
    INNER JOIN product USING (product_id);

-- #1581 customer who visited but did not make any transactions
-- Retrieves customers who visited but did not make any transactions, counting such visits.
SELECT customer_id
    , COUNT(*) AS count_no_trans
FROM visits AS v
    LEFT JOIN transactions AS t USING (visit_id)
WHERE t.visit_id IS NULL
GROUP BY customer_id;

-- #197 rising temperature
-- Identifies dates on which the temperature was higher than the previous day.
SELECT w1.id
FROM weather w1
    INNER JOIN weather w2 ON w1.recordDate = w2.recordDate + 1
WHERE w1.temperature > w2.temperature;

-- #1661 average time of process per machine
-- Calculates the average processing time per machine using timestamp data.
WITH tbl AS (
    SELECT *
        , LAG(timestamp, 1) OVER (PARTITION BY machine_id ORDER BY machine_id, process_id) AS prev
    FROM (SELECT * FROM activity ORDER BY machine_id, process_id, timestamp)
)
SELECT machine_id
    , ROUND((SUM(timestamp::decimal - prev::decimal)
