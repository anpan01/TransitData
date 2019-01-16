DROP TABLE RidershipR
GO

CREATE TABLE RidershipR(
	RidershipRID BIGINT NOT NULL IDENTITY(0,1),
	Vehicle_ID TINYINT NULL,
	Vehicle VARCHAR(10) NULL,
	Counter VARCHAR(25) NULL,
	Route_ID TINYINT NULL,
	Route VARCHAR(10) NULL,
	Route_Stop_ID INT NULL,
	RouteStop VARCHAR(50) NULL,
	Latitude DECIMAL(9, 6) NULL,
	Longitude DECIMAL(9, 6) NULL,
	UTCTime DATETIME NULL,
	ClientTime DATETIME NULL,
	Entrys TINYINT NULL,
	Exits TINYINT NULL,
	DateTime DATETIME NULL,
	DayofWeek CHAR(3) NULL,
	TotalOnOff TINYINT NULL,
	DateTime2 DATETIME NULL,
	MonthName CHAR(3) NULL,
	Date DATETIME NULL,
	Time2 INT NULL,
	CONSTRAINT PK_RidershipR PRIMARY KEY CLUSTERED(RidershipRID ASC)
)
GO

INSERT INTO RidershipR
	(
		Vehicle_ID,
		Vehicle,
		Counter,
		Route_ID,
		Route,
		Route_Stop_ID,
		RouteStop,
		Latitude,
		Longitude,
		UTCTime,
		ClientTime,
		Entrys,
		Exits,
		DateTime,
		DayofWeek,
		TotalOnOff,
		DateTime2,
		MonthName,
		Date,
		Time2
	)
SELECT
	Vehicle_ID,
	Vehicle,
	Counter,
	Route_ID,
	Route,
	NULLIF(Route_Stop_ID, 'NA'),
	RouteStop,
	Latitude,
	Longitude,
	UTCTime,
	ClientTime,
	Entrys,
	Exits,
	DateTime,
	DayofWeek,
	TotalOnOff,
	DateTime2,
	MonthName,
	Date,
	Time2
FROM
	OPENROWSET(
		BULK '\\SADMINAUS01\AData\Planning\PLDV-2018.0108 McAllen Short Range Transit Plan SRTP\Tasks\3_Phase I (Analysis)\3.1_Fixed Route COA\Ridership\RidershipRNoQuotes.csv',
		FORMATFILE = '\\SADMINAUS01\AData\Planning\PLDV-2018.0108 McAllen Short Range Transit Plan SRTP\Tasks\3_Phase I (Analysis)\3.1_Fixed Route COA\Ridership\RidershipR.xml',
		FIRSTROW = 2,
		ROWS_PER_BATCH = 10000,
		ERRORFILE = '\\SADMINAUS01\AData\Planning\PLDV-2018.0108 McAllen Short Range Transit Plan SRTP\Tasks\3_Phase I (Analysis)\3.1_Fixed Route COA\Ridership\RidershipRError.csv')  RidershipR
GO

CREATE NONCLUSTERED INDEX IX_RidershipR_Route_Stop ON RidershipR (Route_ID ASC, Route_Stop_ID ASC)
GO

CREATE NONCLUSTERED INDEX IX_RidershipR_RouteStop ON RidershipR (RouteStop ASC)
GO

DELETE
    R1
FROM
    RidershipR AS R1
    INNER JOIN RidershipR AS R2
        ON R1.Route_ID = R2.Route_ID
        AND R1.Route_Stop_ID = R2.Route_Stop_ID
        AND R1.DateTime = R2.DateTime
        AND (R1.TotalOnOff < R2.TotalOnOff
            OR (R1.TotalOnOff = R2.TotalOnOff
                AND R1.RidershipRID > R2.RidershipRID))
GO
