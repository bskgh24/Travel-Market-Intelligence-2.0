/*
Project: Travel Market Intelligence 2.0
Database: TravelMarketIntelligence
Purpose: Create the project database if it does not already exist.
*/

IF DB_ID('TravelMarketIntelligence') IS NULL
BEGIN
    CREATE DATABASE TravelMarketIntelligence;
END;
GO

USE TravelMarketIntelligence;
GO

SELECT
    DB_NAME() AS CurrentDatabase,
    GETDATE() AS SetupTimestamp;
GO
