-- #1378 replace employee id with the unique identifier
SELECT
    unique_id,
    name
FROM
    employees
    LEFT JOIN employeeuni USING (id);

-- # 1068 product sales analysis i
SELECT
    product_name,
    year,
    price
FROM
    sales
    INNER JOIN product USING (product_id)
  
-- $1581 customer who visited but did not make any transactions
SELECT
    customer_id,
    COUNT(*) AS count_no_trans
FROM
    visits AS v
    LEFT JOIN transactions AS t USING (visit_id)
WHERE
    t.visit_id IS NULL
GROUP BY
    customer_id;

-- #197 rising temperature

-- #1661 average time of process per machine

-- 577 employee bonus
SELECT
    name,
    bonus
FROM
    employee
    LEFT JOIN bonus USING (empid)
WHERE
    bonus < 1000
    OR bonus IS NULL
  
-- #1280 students and examinations
  
-- #570 managers with at least 5 direct reports
SELECT
    name
FROM
    employee
WHERE
    id IN (
        SELECT
            managerid
        FROM
            employee
        GROUP BY
            managerid
        HAVING
            COUNT(*) >= 5
    )
    -- #1934 confirmation rate
