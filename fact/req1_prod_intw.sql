-- calulate temp diff for each point_id for every timestamp
USE production_db;

-- WITH temp_cte AS (
--     SELECT
--         p_id,
--         timestamp,
--         temp,
--         LAG(temp) OVER (PARTITION BY p_id ORDER BY timestamp) AS prev_temp
--     FROM temperature_data
-- )
-- SELECT
--     p_id,
--     timestamp,
--     temp,
--     abs(temp - prev_temp) AS temp_diff
-- FROM temp_cte;

---- or

SELECT p_id,timestamp,temp,date
       abs(temp-lag(temp)OVER (partition by p_id order by timestamp))as temp_diff
from temperature_data;



------

SELECT 
    p_id,
    timestamp,
    temp,
    ABS(temp - LAG(temp) OVER (PARTITION BY p_id ORDER BY timestamp)) AS temp_diff,
    TIMESTAMPDIFF(SECOND, LAG(timestamp) OVER (PARTITION BY p_id ORDER BY timestamp), timestamp) AS time_diff_minutes
FROM temperature_data;

