select esc.EQUIPMENTNAME,esc.starttime,esc.endtime,esc.elapse_time,sum(am.OUTPUTCOUNT)as qty
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
where esc.EQUIPMENTNAME='Mercury#4' and date(esc.starttime)='2025-02-23' 
group by esc.EQUIPMENTNAME,esc.starttime,esc.endtime,esc.elapse_time
