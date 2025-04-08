

SELECT 
    a.EQUIPMENTNAME,a.Starttime,a.Endtime,
    timestampdiff(SECOND, a.Starttime, a.Endtime) AS Time_elapse,STATE,STATEREASON
FROM (
    SELECT EQUIPMENTSTATE AS EQUIPMENTNAME,DATETIME AS Starttime,STATE,STATEREASON,
        LEAD(DATETIME) OVER (ORDER BY DATETIME) AS Endtime
    FROM preproc_equipmentstatechange
) a;



SELECT  RECEIPENAME,lead(OUTPUTCOUNT)over(partition by  a.EQUIPMENTNAME order by a.datetime ) AS qty
FROM prepoc_amountchange



SELECT 
    a.EQUIPMENTNAME,
    b.Starttime,
    a.Endtime,
    TIMESTAMPDIFF(SECOND, a.Starttime, a.Endtime) AS Time_elapse,
    a.STATE,
    a.STATEREASON,
    b.RECEIPENAME,
    LEAD(b.OUTPUTCOUNT) OVER (PARTITION BY a.EQUIPMENTNAME ORDER BY a.Starttime) AS qty
FROM (
    SELECT 
        EQUIPMENTSTATE AS EQUIPMENTNAME,
        DATE_FORMAT( RAWDATETIME, '%Y-%d-%mT%H:%i:%s')as Starttime,
        STATE,
        STATEREASON,
        LEAD(Starttime) OVER (ORDER BY Starttime) AS Endtime
    FROM preproc_equipmentstatechange
) a
LEFT JOIN prepoc_amountchange b 
    ON a.EQUIPMENTNAME = b.EQUIPMENTNAME 
    AND a.Starttime = b.Starttime;






