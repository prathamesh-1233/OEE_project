USE oee;

SELECT COALESCE(SUM(am.OUTPUTCOUNT), 0) AS total_qty
FROM (
    SELECT 
        EQUIPMENTNAME, 
        CHAMBER, 
        STATE, 
        PLANT, 
        DATETIME AS starttime,
        LEAD(DATETIME) OVER (PARTITION BY EQUIPMENTNAME ORDER BY DATETIME) AS endtime
    FROM preproc_equipmentstatechange
) esc
LEFT JOIN prepoc_amountchange am
ON esc.EQUIPMENTNAME = am.EQUIPMENTNAME
AND am.DATETIME >= esc.starttime
AND am.DATETIME < esc.endtime
WHERE esc.STATE = 'IDLE';
