--  filter on equipment and daytime
use oee;
select esc.EQUIPMENTNAME,esc.starttime,esc.endtime,esc.elapse_time,COALESCE(SUM(am.OUTPUTCOUNT), 0) AS qty
from
(SELECT 
        EQUIPMENTNAME,
        DATETIME AS starttime,
        LEAD(DATETIME) OVER (PARTITION BY EQUIPMENTNAME ORDER BY DATETIME) AS endtime,
        TIMESTAMPDIFF(SECOND, DATETIME, LEAD(DATETIME) OVER (PARTITION BY EQUIPMENTNAME ORDER BY DATETIME)) AS elapse_time
FROM preproc_equipmentstatechange)esc
left join prepoc_amountchange am
on esc.EQUIPMENTNAME=am.EQUIPMENTNAME
AND (am.DATETIME>=esc.starttime
AND am.DATETIME < esc.Endtime)
where esc.EQUIPMENTNAME='Mercury#4' and 
esc.Starttime BETWEEN '2025-02-23 00:00:00' AND '2025-02-23 02:46:00'
group by esc.EQUIPMENTNAME,esc.starttime,esc.endtime,esc.elapse_time
