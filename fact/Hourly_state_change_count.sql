-- requirement 
use oee;

WITH state_changes AS (
    SELECT 
        Datetime AS starttime,
        LEAD(Datetime) OVER (ORDER BY Datetime) AS enddate,
        STATE,
        LAG(STATE) OVER (ORDER BY Datetime) AS prev_state
    FROM preproc_equipmentstatechange
),
state_report AS (
    SELECT
        DATE_FORMAT(GREATEST(a.starttime, td.Time), '%Y-%m-%d %H:%i:%s') AS report_datetime,
        LEAST(TIME(a.enddate), td.Time) AS Hour_slot,
        a.STATE,
        DATE_FORMAT(a.starttime, '%Y-%m-%d %H:00:00') AS hour_bucket
    FROM state_changes a
    JOIN time_dim td 
        ON HOUR(a.starttime) = HOUR(td.Time)
    WHERE a.STATE != a.prev_state OR a.prev_state IS NULL  
)
SELECT 
    sr.report_datetime,
    sr.Hour_slot,
    sr.STATE,
    COUNT(*) OVER (PARTITION BY sr.hour_bucket) AS hourly_state_change_count
FROM state_report sr
-- where sr.STATE= 'PRODUCTION'
ORDER BY sr.report_datetime, sr.Hour_slot

