
-- #Method 1
-- DELETE
--     R1
-- FROM
--     RidershipR AS R1
--     INNER JOIN RidershipR AS R2
--         ON R1.Route_ID = R2.Route_ID
--         AND R1.Route_Stop_ID = R2.Route_Stop_ID
--         AND R1.DateTime = R2.DateTime
--         AND (R1.TotalOnOff < R2.TotalOnOff
--             OR (R1.TotalOnOff = R2.TotalOnOff
--                 AND R1.RidershipRID > R2.RidershipRID))

-- #Method 2
-- SELECT
--     R1.RidershipRID
-- FROM
--     RidershipR AS R1
--     CROSS APPLY (
--         SELECT
--             R2.RidershipRID
--         FROM
--             RidershipR AS R2
--             R2.Route_ID = R1.Route_ID
--             AND R2.Route_Stop_ID = R1.Route_Stop_ID
--             AND R2.DateTime = R1.DateTime
--             AND (R1.TotalOnOff < R2.TotalOnOff
--                 OR (R1.TotalOnOff = R2.TotalOnOff
--                     AND R1.RidershipRID > R2.RidershipRID))) AS R2

--Method 3
SELECT
    R1.RidershipRID,
    R1.Route_ID,
    R1.Route_Stop_ID,
    R1.DateTime,
    R1.TotalOnOff
FROM
    RidershipR AS R1
    INNER JOIN RidershipR AS R2
        ON R1.Route_ID = R2.Route_ID
        AND R1.Route_Stop_ID = R2.Route_Stop_ID
        AND R1.DateTime = R2.DateTime
        AND (R1.TotalOnOff < R2.TotalOnOff
            OR (R1.TotalOnOff = R2.TotalOnOff
                AND R1.RidershipRID > R2.RidershipRID))
ORDER BY
    R1.RidershipRID ASC;
WITH CTE AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                Route_ID,
                Route_Stop_ID,
                DateTime
            ORDER BY
                TotalOnOff DESC,
                RidershipRID ASC
        ) AS RN
    FROM
        RidershipR
    WHERE
        Route_ID IS NOT NULL
        AND Route_Stop_ID IS NOT NULL
        AND DateTime IS NOT NULL
)
SELECT
    RidershipRID,
    Route_ID,
    Route_Stop_ID,
    DateTime,
    TotalOnOff
FROM
    CTE
WHERE
    RN > 1
ORDER BY
    RidershipRID ASC