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
select w1.id
from weather w1
inner join weather w2
on w1.recordDate = w2.recordDate + 1
where w1.temperature > w2.temperature

-- #1661 average time of process per machine
with tbl as (
    select *,
    lag(timestamp, 1) over(partition by machine_id order by machine_id, process_id) as prev
    from (select * from activity order by machine_id, process_id, timestamp)
)
select machine_id, ROUND((sum(timestamp::decimal - prev::decimal) / count(*)), 3) as processing_time
from tbl
where activity_type = 'end'
group by machine_id

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
with blank as (
    select *
    from students
    cross join subjects
)
select student_id, student_name, subject_name, (count(*) -1) as attended_exams
from
(select student_id, subject_name from blank
union all select * from examinations)
inner join students using(student_id)
group by student_id, student_name, subject_name
order by student_id, student_name, subject_name
    
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
with timeout as (
    select user_id, count(action) as count_timeout
        from signups left join confirmations using(user_id) 
        where action = 'timeout' group by user_id
),
confirmed as ( 
    select user_id, count(action) as count_confirmed
    from signups left join confirmations using(user_id) 
    where action = 'confirmed' group by user_id
)
SELECT 
    signups.user_id,
    case when (count_confirmed is null and count_timeout is null) or
        (count_timeout is not null and count_confirmed is null) then 0::decimal
        when count_timeout is null then 1::decimal
        else round((count_confirmed::decimal/(count_timeout::decimal+count_confirmed::decimal)), 2) 
            end as confirmation_Rate
from signups
left join timeout using(user_id)
left join confirmed using(user_id)
