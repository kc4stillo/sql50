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
	, ROUND((SUM(timestamp::decimal - prev::decimal) / COUNT(*)), 3) AS processing_time
FROM tbl
WHERE activity_type = 'end'
GROUP BY machine_id;

-- #577 employee bonus
-- Selects employees who either received a bonus less than 1000 or did not receive a bonus.
SELECT name
	, bonus
FROM employee
	LEFT JOIN bonus USING (empid)
WHERE bonus < 1000
	OR bonus IS NULL;

-- #1280 students and examinations
-- Lists students along with the subjects and the number of exams attended.
WITH blank AS (
	SELECT *
	FROM students
		CROSS JOIN subjects
)
SELECT student_id
	, student_name
	, subject_name
	, (COUNT(*) - 1) AS attended_exams
FROM (
	SELECT student_id
		, subject_name 
	FROM blank
	UNION ALL 
	SELECT * FROM examinations
) INNER JOIN students USING (student_id)
GROUP BY student_id, student_name, subject_name
ORDER BY student_id, student_name, subject_name;

-- #570 managers with at least 5 direct reports
-- Selects managers who have at least 5 direct reports.
SELECT name
FROM employee
WHERE id IN (
	SELECT managerid
	FROM employee
	GROUP BY managerid
	HAVING COUNT(*) >= 5
);

-- #1934 confirmation rate
-- Calculates the confirmation rate based on user actions of 'timeout' and 'confirmed'.
WITH timeout AS (
	SELECT user_id
		, COUNT(action) AS count_timeout
	FROM signups 
		LEFT JOIN confirmations USING(user_id) 
	WHERE action = 'timeout' 
	GROUP BY user_id
), confirmed AS ( 
	SELECT user_id
		, COUNT(action) AS count_confirmed
	FROM signups 
		LEFT JOIN confirmations USING(user_id) 
	WHERE action = 'confirmed' 
	GROUP BY user_id
)
SELECT signups.user_id
	, CASE 
		WHEN (count_confirmed IS NULL AND count_timeout IS NULL) OR
		     (count_timeout IS NOT NULL AND count_confirmed IS NULL) THEN 0::decimal
		WHEN count_timeout IS NULL THEN 1::decimal
		ELSE ROUND((count_confirmed::decimal / (count_timeout::decimal + count_confirmed::decimal)), 2) 
	END AS confirmation_rate
FROM signups
	LEFT JOIN timeout USING(user_id)
	LEFT JOIN confirmed USING(user_id);
