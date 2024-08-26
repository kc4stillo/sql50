-- #2356 number of unique subjects taught by each teacher
SELECT teacher_id, 
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP By teacher_id;
