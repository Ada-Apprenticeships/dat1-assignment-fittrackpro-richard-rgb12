.open fittrackpro.db
.mode column

-- 5.1 
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    ms.type AS membership_type, 
    m.join_date
FROM memberships ms
INNER JOIN members m
    ON ms.member_id = m.member_id
WHERE ms.status = 'Active';

-- 5.2 
SELECT 
    ms.type AS membership_type, 
    ROUND(AVG((julianday(a.check_out_time) - julianday(a.check_in_time)) * 24 * 60), 2) AS avg_visit_duration_minutes
FROM memberships ms
INNER JOIN attendance a
    ON ms.member_id = a.member_id
GROUP BY membership_type;

-- 5.3 
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    m.email, 
    ms.end_date
FROM memberships ms
INNER JOIN members m
ON ms.member_id = m.member_id
WHERE ms.end_date LIKE '2025%';
