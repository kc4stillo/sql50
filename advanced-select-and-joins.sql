-- 1731 the number of employees which report to each employee
SELECT employee_id
     , name
     , reports_count
     , average_age
  FROM employees AS e1
     , (
         SELECT reports_to
              , COUNT(reports_to) AS reports_count
              , ROUND(AVG(age), 0) AS average_age
           FROM employees
          GROUP BY reports_to
       ) AS e2
 WHERE e1.employee_id = e2.reports_to
 ORDER BY employee_id;

-- #1789 primary department for each employee
SELECT employee_id
     , department_id
  FROM employee
 WHERE (employee_id, primary_flag) IN (
           SELECT employee_id
                , primary_flag
             FROM employee
            WHERE primary_flag = 'Y'
       )
    OR (
           employee_id IN (
               SELECT employee_id
                 FROM employee
                GROUP BY employee_id
               HAVING COUNT(*) = 1
           )
       );

-- #610 triangle judgement
SELECT *
     , CASE 
           WHEN x + y > z AND z >= y AND z >= x THEN 'Yes'
           WHEN x + z > y AND y >= x AND y >= z THEN 'Yes'
           WHEN y + z > x AND x >= y AND x >= z THEN 'Yes'
           WHEN x = y AND y = z THEN 'Yes'
           ELSE 'No'
       END AS triangle
  FROM triangle;

-- #180 consecutive numbers
SELECT DISTINCT l1.num AS consecutivenums
  FROM logs l1
     , logs l2
     , logs l3
 WHERE l1.id = l2.id - 1
   AND l1.num = l2.num
   AND l2.id = l3.id - 1
   AND l1.num = l3.num;

-- #1164 product price at a given date
WITH math AS (
    SELECT product_id
         , new_price
      FROM products
     WHERE (product_id, change_date) IN (
              SELECT product_id
                   , MAX(change_date)
                FROM products
               WHERE change_date <= '2019-08-16'
             GROUP BY product_id
           )
),
two AS (
    SELECT product_id
      FROM products
    EXCEPT
    SELECT product_id
      FROM math
)
SELECT DISTINCT product_id
     , CASE 
           WHEN product_id IN (SELECT product_id FROM two)
           THEN 10
           ELSE new_price
       END AS price
  FROM products
 WHERE (product_id, new_price) IN (SELECT * FROM math)
    OR product_id IN (SELECT * FROM two);

-- #1204 last person to fit in the bus
WITH weights AS (
    SELECT *
         , SUM(weight) OVER (
              ORDER BY turn
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS total_weight
      FROM queue
)
SELECT person_name
  FROM weights
 WHERE turn IN (
          SELECT MAX(turn)
            FROM weights
           WHERE total_weight <= 1000
       );

-- #1907 count salary categories
WITH tbl AS (
    SELECT DISTINCT unnest(array['Low Salary', 'Average Salary', 'High Salary']) AS category
),
tbl2 AS (
    SELECT *
         , CASE 
               WHEN income < 20000 THEN 'Low Salary'
               WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
               WHEN income > 50000 THEN 'High Salary'
           END AS st
      FROM accounts
)
SELECT category
     , COUNT(income) AS accounts_count
  FROM tbl
  LEFT JOIN tbl2
    ON tbl.category = tbl2.st
 GROUP BY category;
