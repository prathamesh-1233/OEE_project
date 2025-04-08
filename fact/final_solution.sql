use oee;

WITH state_changes AS (
    SELECT 
        Datetime AS starttime,
        LEAD(Datetime) OVER (ORDER BY Datetime) AS enddate,
        STATE,
        LAG(STATE) OVER (ORDER BY Datetime) AS prev_state
    FROM preproc_equipmentstatechange
)
SELECT
    DATE_FORMAT(GREATEST(a.starttime, td.Time), '%Y-%m-%d %H:%i:%s') AS report_datetime,
    LEAST(a.enddate, td.Time) AS Hour_slot,
    a.STATE
FROM state_changes a
JOIN time_dim td 
    ON HOUR(a.starttime) = HOUR(td.Time)
WHERE a.STATE != a.prev_state OR a.prev_state IS NULL  
ORDER BY a.starttime, a.enddate;
