.open fittrackpro.db
.mode column

-- 7.1 
SELECT 
    staff_id, 
    first_name, 
    last_name, 
    position AS role
FROM staff
ORDER BY role;

-- 7.2 
SELECT 
    pts.staff_id AS trainer_id, 
    s.first_name || ' ' || s.last_name AS trainer_name, 
    COUNT(pts.session_id) AS session_count
FROM personal_training_sessions pts
INNER JOIN staff s
ON pts.staff_id = s.staff_id
WHERE DATE(session_date) BETWEEN '2025-01-20' AND '2025-02-20'
GROUP BY trainer_id;
