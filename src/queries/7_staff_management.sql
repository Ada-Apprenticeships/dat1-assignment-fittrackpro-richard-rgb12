.open fittrackpro.db
.mode column

-- 7.1 
SELECT staff_id, first_name, last_name, position as role
FROM staff;

-- 7.2 

SELECT pts.staff_id AS trainer_id, CONCAT(first_name, ' ', last_name) AS trainer_name, COUNT(session_id) AS session_count
FROM personal_training_sessions pts
INNER JOIN staff s
ON pts.staff_id = s.staff_id
WHERE session_date BETWEEN '2025-01-20' AND '2025-02-20'
GROUP BY trainer_id;