SELECT
   --R.RidershipRID,
   --R.Vehicle_ID,
   --R.Vehicle,
   --R.Counter,
   R.Route_ID,
   --R.Route,
   R.Route_Stop_ID,
   --R.RouteStop,
   --R.Latitude,
   --R.Longitude,
   --R.UTCTime,
   --R.ClientTime,
   --R.Entrys,
   --R.Exits,
   --R.DateTime,
   R.DayofWeek,
   --R.TotalOnOff,
   --R.DateTime2,
   --R.MonthName,
   R.Date,
   --R.Time2, 
   --AVG(R.Time2) AS agTime,
 --  CASE 
  --WHEN R.Time2 > 79200 THEN AVG(R.Time2)
  --ELSE NULL
 --  END AS agTime,
   --SR.Trip NonBusTripID,
   --SBS.Trip BusStartTripID,
   --SBE.Trip BusEndTripID
  COUNT(R.Entrys) AS CRecs,
  SUM(R.Entrys) AS TEntrys
FROM
   RidershipR AS R
   LEFT JOIN SundaySchedulesR AS SR
       ON R.Route_ID = SR.Route
       AND R.Time2 BETWEEN SR.StartSec AND SR.EndSec
       AND R.RouteStop != 'Bus Station'
   LEFT JOIN SundaySchedulesR AS SBS
       ON R.Route_ID = SBS.Route
       AND R.Time2 BETWEEN SBS.S_BS_S AND SBS.S_BS_E
       AND R.RouteStop = 'Bus Station'
   LEFT JOIN SundaySchedulesR AS SBE
       ON R.Route_ID = SBE.Route
       AND R.Time2 BETWEEN SBE.E_BS_S AND SBE.E_BS_E
       AND R.RouteStop = 'Bus Station'
    WHERE DayofWeek = 'Sun'
    AND SR.Trip IS NULL
    AND SBS.Trip IS NULL
    AND SBE.Trip IS NULL
    AND Time2 > 79200
    OR Time2 < 1600

   -- AND Entrys > 10
   --HAVING  COUNT(R.Entrys) > 1
  GROUP BY R.Date, R.DayofWeek, R.Route_ID, R.Route_Stop_ID, SR.Trip, SBS.Trip, SBE.Trip
  --ORDER BY  Date DESC;