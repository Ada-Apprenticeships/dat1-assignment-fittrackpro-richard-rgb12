.open fittrackpro.db
.mode column

-- 8.1 
SELECT session_id, CONCAT(m.first_name, ' ', m.last_name) AS member_name, session_date, start_Time, end_time
FROM personal_training_sessions pts
INNER JOIN staff s
ON pts.staff_id = s.staff_id
INNER JOIN members m
ON m.member_id = pts.member_id
WHERE CONCAT(s.first_name, ' ', s.last_name) = 'Ivy Irwin'
