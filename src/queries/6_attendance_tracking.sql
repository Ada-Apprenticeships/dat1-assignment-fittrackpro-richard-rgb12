.open fittrackpro.db
.mode column

-- 6.1 
INSERT INTO attendance(member_id,location_id,check_in_time)
VALUES(7, 1, '2025-02-14 16:30:00');

-- 6.2 
SELECT 
    DATE(check_in_time) AS visit_date, 
    TIME(check_in_time) AS check_in_time, 
    TIME(check_out_time) AS check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY visit_date;

-- 6.3 
SELECT 
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'        
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END as day_of_week, 
    COUNT(member_id) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;

-- 6.4 
SELECT 
    name,
    ROUND(
        CASE 
            WHEN MIN(check_in_time) IS NULL THEN 0
            ELSE COUNT(member_id) * 1.0 / 
                (julianday(MAX(check_in_time)) - julianday(MIN(check_in_time)) + 1)
        END, 2) AS avg_daily_attendance
FROM locations l
LEFT JOIN attendance a
ON a.location_id = l.location_id
GROUP BY l.location_id;
