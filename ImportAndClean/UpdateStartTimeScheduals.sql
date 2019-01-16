UPDATE
    SchedulesR
SET
    StartSec = StartSec + 1,
    S_BS_S = S_BS_S + 1,
    E_BS_S = E_BS_S + 1
WHERE
    Trip % 100 > 1