-- #620 not boring movies
SELECT *
FROM cinema
WHERE (id % 2) <> 0
    AND description <> 'boring'
ORDER BY rating DESC;

-- #1251 average selling price
WITH tbl AS (
    SELECT product_id, price, units
    FROM Prices AS p
    LEFT JOIN unitssold AS us1 USING(product_id)
    WHERE purchase_date BETWEEN start_date AND end_date
        OR purchase_date IS NULL
)
SELECT 
    product_id,
    CASE 
        WHEN SUM(units) IS NULL THEN 0
        ELSE ROUND(SUM(price::decimal * units::decimal) / SUM(units::decimal), 2) 
    END AS average_price
FROM tbl
GROUP BY product_id;

-- #1075 project employees i
SELECT project_id, ROUND(AVG(experience_years), 2) AS average_years
FROM employee
INNER JOIN project USING(employee_id)
GROUP BY project_id;

-- #1633 percentage of users attended a contest
WITH count1 AS (
    SELECT COUNT(user_id) AS users_count
    FROM users
),
count2 AS (
    SELECT contest_id, COUNT(user_id) AS contest_count
    FROM register
    GROUP BY contest_id
)
SELECT contest_id, ROUND((contest_count::decimal / users_count::decimal) * 100, 2) AS percentage
FROM count1, count2
ORDER BY percentage DESC, contest_id;

-- #1211 queries quality and percentage
WITH qualtbl AS (
    SELECT query_name, ROUND(AVG(rating::decimal / position::decimal), 2) AS quality
    FROM queries
    GROUP BY query_name
),
poorqual AS (
    SELECT query_name,
        ROUND(
            (
                SELECT COUNT(*)
                FROM queries q1
                WHERE rating < 3
                    AND q1.query_name = q2.query_name
                GROUP BY query_name
            )::decimal / COUNT(*)::decimal * 100, 2
        ) AS poor_query_percentage
    FROM queries q2
    GROUP BY query_name
)
SELECT qualtbl.query_name, quality, COALESCE(poor_query_percentage, 0) AS poor_query_percentage
FROM qualtbl
FULL JOIN poorqual USING (query_name);

-- #1193 monthly transactions i
SELECT TO_CHAR(t1.trans_date, 'YYYY-MM') AS month, t1.country,
    COUNT(t1.*) AS trans_count, COUNT(t2.*) AS approved_count, COALESCE(SUM(t1.amount), 0) AS trans_total_amount,
    COALESCE(SUM(t2.amount), 0) AS approved_total_amount
FROM transactions t1
    LEFT JOIN transactions t2 ON t1.id = t2.id AND t2.state = 'approved'
GROUP BY TO_CHAR(t1.trans_date, 'YYYY-MM'), t1.country
ORDER BY month;

-- #1174 immediate food delivery ii
WITH same AS (
    SELECT DISTINCT customer_id, COUNT(customer_id) AS count_same
    FROM delivery AS d1
    WHERE (customer_id, order_date) IN (
        SELECT DISTINCT customer_id, MIN(order_date)
        FROM delivery AS d2
        WHERE d1.customer_id = d2.customer_id
        GROUP BY customer_id
    )
    AND order_date = customer_pref_delivery_date
    GROUP BY customer_id
),
sched AS (
    SELECT DISTINCT customer_id, COUNT(DISTINCT customer_id) AS count_sched
    FROM delivery
    WHERE customer_id IN (
        SELECT customer_id FROM delivery
        EXCEPT
        SELECT customer_id FROM same
    )
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN COUNT(sched) > 0 THEN ROUND((SUM(count_same)) / (SUM(count_sched) + SUM(count_same)) * 100, 2)
        ELSE 100
    END AS immediate_percentage
FROM same
FULL JOIN sched ON same.customer_id = sched.customer_id;

-- #550 game play analysis iv
WITH tbl1 AS (
    SELECT a1.*
    FROM activity a1
    INNER JOIN activity a2 ON a1.event_date = a2.event_date + 1 AND a1.player_id = a2.player_id
),
tbl2 AS (
    SELECT COUNT(DISTINCT player_id) AS counts
    FROM tbl1
    WHERE event_date IN (
        SELECT event_date 
        FROM activity a2 
        WHERE tbl1.player_id = a2.player_id 
        ORDER BY event_date 
        LIMIT 2
    )
)
SELECT ROUND(counts::decimal / (SELECT COUNT(DISTINCT player_id) FROM activity)::decimal, 2) AS fraction
FROM tbl2;
