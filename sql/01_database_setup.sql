/*
Travel Market Intelligence 2.0
Creates the database only if it does not already exist.
Does not drop or overwrite existing tables.
*/
IF DB_ID(N'TravelMarketIntelligence') IS NULL
BEGIN
    CREATE DATABASE TravelMarketIntelligence;
END;
GO

USE TravelMarketIntelligence;
GO

SELECT DB_NAME() AS CurrentDatabase, GETDATE() AS SetupTimestamp;
GO
