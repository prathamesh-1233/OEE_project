use oee;
SELECT Datetime as starttime,
      lead(Datetime)over(order by Datetime)as enddate,STATE,
      timediff(lead(Datetime)over(order by Datetime),Datetime)as time_diff
FROM preproc_equipmentstatechange 
order by starttime asc;