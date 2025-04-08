WITH state_intervals AS (
    SELECT 
        Datetime AS starttime,
        LEAD(Datetime) OVER (ORDER BY Datetime) AS enddate,
        STATE
    FROM preproc_equipmentstatechange
),
expanded_intervals AS (
    SELECT 
        DATE(starttime) AS report_date,
        ADDTIME(DATE(starttime), time_dim.Time) AS hour_slot,
        state_intervals.STATE
    FROM state_intervals
    JOIN time_dim 
    ON ADDTIME(DATE(starttime), time_dim.Time) BETWEEN starttime AND enddate
)
SELECT 
    report_date,
    TIME(hour_slot) AS hour,
    STATE,
    COUNT(*) AS state_count
FROM expanded_intervals
GROUP BY report_date, hour, STATE
ORDER BY report_date, hour, STATE;
