use oee;
select C.*
from
(SELECT 
    a.EQUIPMENTNAME,a.Starttime,a.Endtime,
    TIMESTAMPDIFF(SECOND, a.Starttime, a.Endtime) AS Time_elapse,
    a.STATE,a.STATEREASON,b.RECEIPENAME,b.OUTPUTCOUNT,
    LEAD(b.OUTPUTCOUNT) OVER (PARTITION BY a.EQUIPMENTNAME ORDER BY a.Starttime) AS qty
FROM (
    SELECT 
        EQUIPMENTSTATE AS EQUIPMENTNAME,RAWDATETIME,DATE_FORMAT( RAWDATETIME, '%Y-%d-%mT%H:%i:%s') AS Starttime,STATE,STATEREASON,
        LEAD(DATE_FORMAT( RAWDATETIME, '%Y-%d-%mT%H:%i:%s')) OVER (ORDER BY DATE_FORMAT( RAWDATETIME, '%Y-%d-%mT%H:%i:%s')) AS Endtime
    FROM preproc_equipmentstatechange
) a
LEFT JOIN prepoc_amountchange b 
    ON a.EQUIPMENTNAME = b.EQUIPMENTNAME 
    AND a.RAWDATETIME = b.RAWDATETIME)c
-- where c.EQUIPMENTNAME='Centura#2' and c.Starttime='2025-02-23 05:46:00' and Endtime='2025-02-23 05:46:00'
-- group by c.EQUIPMENTNAME,c.Starttime,c.Endtime,c.Time_elapse,c.STATE,c.STATEREASON,c.RECEIPENAME,c.Time_elapse,c.OUTPUTCOUNT

SELECT 
        EQUIPMENTSTATE AS EQUIPMENTNAME,RAWDATETIME,DATE_FORMAT( RAWDATETIME, '%Y-%m-%dT%H:%i:%s') AS Starttime
    FROM preproc_equipmentstatechange


-- c.EQUIPMENTNAME,c.Starttime,c.Endtime,c.Time_elapse,c.STATE,c.STATEREASON,c.RECEIPENAME,c.Time_elapse,c.OUTPUTCOUNT,sum(c.qty)