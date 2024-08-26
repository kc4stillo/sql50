-- #1667 fix names in a table
SELECT user_id
     , CONCAT(
           UPPER(SUBSTRING(name, 1, 1))
         , LOWER(SUBSTRING(name, 2, LENGTH(name)))
       ) AS name
  FROM users
 ORDER BY user_id;

-- #1527 patients with a condition
SELECT
    patient_id,
    patient_name,
    conditions
FROM
    patients
WHERE
    conditions LIKE 'DIAB1%'
    OR conditions LIKE '% DIAB1%'
  
-- #196 delete duplicate emails
DELETE FROM person
WHERE
    id NOT IN (
        SELECT
            MIN(id)
        FROM
            person
        GROUP BY
            email
    )
  
-- #176 second highest salary
SELECT
    MAX(salary) AS secondhighestsalary
FROM
    employee
WHERE
    salary NOT IN (
        SELECT
            MAX(salary)
        FROM
            employee
    )
  
-- #1484 group sold products by the date
SELECT
    product_name,
    SUM(unit) AS unit
FROM
    products
    INNER JOIN orders USING (product_id)
WHERE
    order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY
    product_name
HAVING
    SUM(unit) >= 100

-- 1517 find users with valid e-mails
SELECT *
  FROM users
 WHERE REGEXP_LIKE(mail, '^[A-Za-z]+[A-Za-z0-9_.\-]*@leetcode\.com$');
