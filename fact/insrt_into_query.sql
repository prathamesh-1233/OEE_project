use oee;


insert into hourly_tb

select esc.EQUIPMENTNAME,esc.starttime,esc.endtime,esc.elapse_time,am.OUTPUTCOUNT
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
AND am.DATETIME < esc.endtime )      -- or esc.endtime is not null
-- where am.DATETIME BETWEEN '2025-02-23 00:00:01' AND '2025-02-23 01:45:38'and max(esc.starttime) < esc.starttime
WHERE esc.starttime > (SELECT MAX(starttime) FROM hourly_tb)
	AND esc.starttime  <= (SELECT DATE_ADD(MAX(starttime), INTERVAL 2 HOUR)FROM hourly_tb)
group by esc.EQUIPMENTNAME,esc.starttime,esc.endtime,esc.elapse_time,am.OUTPUTCOUNT