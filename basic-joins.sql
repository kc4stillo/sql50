-- #1378 replace employee id with the unique identifier
SELECT unique_id, name
FROM Employees
LEFT JOIN EmployeeUNI
USING(id);

-- # 1068 product sales analysis i
SELECT product_name, year, price
FROM Sales
inner JOIN Product
USING(Product_id)

-- $1581 customer who visited but did not make any transactions
SELECT 
  customer_id, 
  COUNT(*) AS count_no_trans 
FROM 
  Visits AS v 
  LEFT JOIN Transactions AS t USING (visit_id) 
WHERE 
  t.visit_id IS NULL 
GROUP BY 
  customer_id;

-- #197 rising temperature

-- #1661 average time of process per machine

-- #employee bonus
SELECT name, bonus
FROM Employee
LEFT JOIN Bonus
USING (empId)
WHERE bonus < 1000 or bonus is null

-- #1280 students and examinations

-- #570 managers with at least 5 direct reports

-- #1934 confirmation rate
