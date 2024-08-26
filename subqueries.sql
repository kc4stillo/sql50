-- #1978 employees whose manager left the company
SELECT employee_id
  FROM Employees
 WHERE manager_id NOT IN (
           SELECT employee_id
             FROM Employees
       )
   AND salary < 30000
 ORDER BY employee_id;

-- #626 exchange seats
SELECT id
     , CASE 
           WHEN MOD(id, 2) = 0 THEN (
               SELECT student
                 FROM seat s2
                WHERE s2.id + 1 = s1.id
           )
           WHEN id IN (SELECT MAX(id) FROM seat) THEN (
               SELECT student
                 FROM seat
                WHERE id IN (SELECT MAX(id) FROM seat)
           )
           WHEN MOD(id, 2) <> 0 THEN (
               SELECT student
                 FROM seat s2
                WHERE s2.id - 1 = s1.id
           )
       END AS student
  FROM seat s1;

-- #1341 movie rating
SELECT *
  FROM (
        SELECT NAME AS results
          FROM movierating
          INNER JOIN users USING (user_id)
         GROUP BY NAME
         ORDER BY COUNT(user_id) DESC
           , NAME
         LIMIT 1
    ) AS tbl1
UNION ALL
SELECT *
  FROM (
        SELECT title
          FROM movies
          INNER JOIN movierating USING (movie_id)
         WHERE created_at BETWEEN '2020-02-01' AND '2020-02-28'
         GROUP BY title
         ORDER BY AVG(rating) DESC
           , LENGTH(title) DESC
         LIMIT 1
    ) AS tbl2;

-- #1321 restaurant growth
SELECT visited_on
     , SUM(amount) OVER (
           ORDER BY visited_on
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ) AS amount
     , ROUND(
           AVG(amount) OVER (
               ORDER BY visited_on
               ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
           ), 2
       ) AS average_amount
  FROM (
        SELECT visited_on
             , SUM(amount) AS amount
          FROM customer
         GROUP BY visited_on
    ) OFFSET 6;

-- #602 friend requests ii: who has the most friends
SELECT id
     , COUNT(*) AS num
  FROM (
        SELECT requester_id AS id
          FROM requestaccepted
        UNION ALL
        SELECT accepter_id
          FROM requestaccepted
    ) AS combined
 GROUP BY id
 ORDER BY COUNT(*) DESC
 LIMIT 1;

-- #585 investments in 2016
SELECT ROUND(SUM(tiv_2016::NUMERIC), 2) AS tiv_2016
  FROM insurance
 WHERE (lat, lon) IN (
           SELECT lat
                , lon
             FROM insurance
            GROUP BY lat
                 , lon
           HAVING COUNT(*) = 1
       )
   AND tiv_2015 IN (
           SELECT tiv_2015
             FROM insurance
            GROUP BY tiv_2015
           HAVING COUNT(tiv_2015) > 1
       );

-- #185 department top three salaries
WITH cte AS (
    SELECT department.name AS department
         , employee.name AS employee
         , salary
         , DENSE_RANK() OVER (
               PARTITION BY departmentId
               ORDER BY salary DESC
           ) AS rnk
      FROM employee
      JOIN department
        ON employee.departmentid = department.id
)
SELECT department
     , employee
     , salary
  FROM cte
 WHERE rnk <= 3;
