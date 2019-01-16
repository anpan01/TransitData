--UPDATE
--    S1
--SET
--    S1.EndSec = S1.EndSec + 7200,
--    S1.E_BS_E = S1.E_BS_E + 7200
--DELETE
--FROM
--    SundaySchedulesR
--WHERE Trip LIKE '%13'
--OR Trip LIKE '%14'
--OR Trip LIKE '%15'

UPDATE
   S1
SET
   S1.EndSec = S1.EndSec - 3600,
   S1.E_BS_E = S1.E_BS_E - 3600
FROM
   SundaySchedulesR AS S1
   CROSS APPLY (
       SELECT TOP(1)
           S2.Trip
       FROM
           SundaySchedulesR AS S2
       WHERE
           S2.Route = S1.Route
       ORDER BY
           S2.Trip DESC) AS S2
WHERE
   S1.Trip = S2.Trip

    select * from SundaySchedulesR