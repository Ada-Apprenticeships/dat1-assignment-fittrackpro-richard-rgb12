.open fittrackpro.db
.mode column

-- 8.1 
SELECT 
    session_id, 
    m.first_name || ' ' || m.last_name AS member_name, 
    pts.session_date, 
    pts.start_time, 
    pts.end_time
FROM personal_training_sessions pts
INNER JOIN staff s
ON pts.staff_id = s.staff_id
INNER JOIN members m
ON m.member_id = pts.member_id
WHERE s.first_name = 'Ivy' AND s.last_name = 'Irwin';
