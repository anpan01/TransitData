SELECT
   R.RidershipRID,
   R.Vehicle_ID,
   R.Vehicle,
   R.Counter,
   R.Route_ID,
   R.Route,
   R.Route_Stop_ID,
   R.RouteStop,
   R.Latitude,
   R.Longitude,
   R.UTCTime,
   R.ClientTime,
   R.Entrys,
   R.Exits,
   R.DateTime,
   R.DayofWeek,
   R.TotalOnOff,
   R.DateTime2,
   R.MonthName,
   R.Date,
   R.Time2,
   SR.Trip NonBusTripID,
   SBS.Trip BusStartTripID,
   SBE.Trip BusEndTripID
FROM
   RidershipR AS R
   LEFT JOIN SchedulesR AS SR
       ON R.Route_ID = SR.Route
       AND R.Time2 BETWEEN SR.StartSec AND SR.EndSec
       AND R.RouteStop != 'Bus Station'
   LEFT JOIN SchedulesR AS SBS
       ON R.Route_ID = SBS.Route
       AND R.Time2 BETWEEN SBS.S_BS_S AND SBS.S_BS_E
       AND R.RouteStop = 'Bus Station'
   LEFT JOIN SchedulesR AS SBE
       ON R.Route_ID = SBE.Route
       AND R.Time2 BETWEEN SBE.E_BS_S AND SBE.E_BS_E
       AND R.RouteStop = 'Bus Station'
    --WHERE DayofWeek = 'Sun'
  --AND SR.Trip IS NULL
  --AND SBS.Trip IS NULL
  --AND SBE.Trip IS NULL
  --GROUP BY R.Date, SR.Trip,   SBS.Trip,   SBE.Trip
  

