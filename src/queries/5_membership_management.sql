.open fittrackpro.db
.mode column

-- 5.1 
SELECT 
    m.member_id, 
    first_name, 
    last_name, 
    type AS membership_type, 
    join_date
FROM memberships ms
INNER JOIN members m
ON ms.member_id = m.member_id
WHERE status = 'Active';

-- 5.2 
SELECT 
    type AS membership_type, 
    ROUND(AVG((julianday(check_out_time) - julianday(check_in_time)) * 24 * 60), 2) AS avg_visit_duration_minutes
FROM memberships m
INNER JOIN attendance a
ON m.member_id = a.member_id
GROUP BY membership_type;

-- 5.3 
SELECT 
    m.member_id, 
    first_name, 
    last_name, 
    email, 
    end_date
FROM memberships ms
INNER JOIN members m
ON ms.member_id = m.member_id
WHERE end_date LIKE '2025%';
