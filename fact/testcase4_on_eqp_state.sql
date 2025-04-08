--  filter on equipment and state=idle
use oee;
select esc.EQUIPMENTNAME,esc.CHAMBER,am.RECEIPENAME,esc.STATE,esc.PLANT,esc.starttime,esc.endtime,esc.elapse_time,COALESCE(SUM(am.OUTPUTCOUNT), 0) AS qty
from
(SELECT 
        EQUIPMENTNAME,CHAMBER,STATE,PLANT,
        DATETIME AS starttime,
        LEAD(DATETIME) OVER (PARTITION BY EQUIPMENTNAME ORDER BY DATETIME) AS endtime,
        TIMESTAMPDIFF(SECOND, DATETIME, LEAD(DATETIME) OVER (PARTITION BY EQUIPMENTNAME ORDER BY DATETIME)) AS elapse_time
FROM preproc_equipmentstatechange)esc
left join prepoc_amountchange am
on esc.EQUIPMENTNAME=am.EQUIPMENTNAME
AND (am.DATETIME>=esc.starttime
AND am.DATETIME < esc.Endtime)
-- where esc.EQUIPMENTNAME='Centura#2' and esc.STATE='IDLE' and date(esc.starttime)='2025-02-24'
where esc.STATE='IDLE' and date(esc.starttime)='2025-02-24' and am.RECEIPENAME= 'ZLETCH1'
group by esc.EQUIPMENTNAME,esc.CHAMBER,am.RECEIPENAME,esc.STATE,esc.PLANT,esc.starttime,esc.endtime,esc.elapse_time
