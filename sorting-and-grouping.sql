-- #2356 number of unique subjects taught by each teacher
SELECT teacher_id
     , COUNT(DISTINCT subject_id) AS cnt
  FROM Teacher
 GROUP BY teacher_id;

-- #1141 user activity for the past 30 days
SELECT DISTINCT activity_date AS day
     , COUNT(DISTINCT user_id) AS active_users
  FROM Activity
 WHERE activity_date BETWEEN '2019-07-27' - INTERVAL 30 DAY AND '2019-07-27'
 GROUP BY activity_date
 ORDER BY activity_date;

-- #1070 product sales analysis iii
SELECT product_id
     , year AS first_year
     , quantity
     , price
  FROM Sales
 WHERE (product_id, year) IN (
          SELECT product_id
               , MIN(year)
            FROM Sales
           GROUP BY product_id
       );

-- #596 classes more than 5 students
SELECT class
  FROM Courses
 GROUP BY class
HAVING COUNT(*) >= 5;

-- #1729 find followers count
SELECT user_id
     , COUNT(*) AS followers_count
  FROM Followers
 GROUP BY user_id
 ORDER BY user_id;

-- #619 biggest single number
WITH nums AS (
    SELECT *
         , COUNT(*) AS count
      FROM myNumbers
     GROUP BY num
    HAVING COUNT(*) = 1
)
SELECT MAX(num) AS num
  FROM nums;

-- 1045 customers who bought all products
WITH yeah AS (
    SELECT DISTINCT customer_id
         , COUNT(DISTINCT product_key) AS count
      FROM customer
     GROUP BY customer_id
)
SELECT customer_id
  FROM yeah
 WHERE count IN (
          SELECT COUNT(DISTINCT product_key)
            FROM product
       );
