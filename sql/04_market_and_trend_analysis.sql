/*
Market segment and arrival trend analysis.
*/
USE TravelMarketIntelligence;
GO

-- Market segment performance
SELECT
    market_segment,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Cancellations,
    CAST(100.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
         / NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS Cancellation_Rate_Percent,
    AVG(CAST(adr AS DECIMAL(18,4))) AS Average_ADR,
    AVG(CAST(lead_time AS DECIMAL(10,2))) AS Average_Lead_Time_Days
FROM dbo.fact_hotel_bookings_v2
GROUP BY market_segment
ORDER BY Total_Bookings DESC;
GO

-- Monthly booking trends
SELECT
    YEAR(arrival_date) AS Arrival_Year,
    MONTH(arrival_date) AS Arrival_Month_Number,
    DATENAME(MONTH, arrival_date) AS Arrival_Month,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Cancellations,
    AVG(CAST(adr AS DECIMAL(18,4))) AS Average_ADR,
    SUM(total_nights) AS Total_Room_Nights
FROM dbo.fact_hotel_bookings_v2
GROUP BY YEAR(arrival_date), MONTH(arrival_date), DATENAME(MONTH, arrival_date)
ORDER BY Arrival_Year, Arrival_Month_Number;
GO

-- Booking behaviour by special-request status; association is not causation.
SELECT
    has_special_requests,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Cancellations,
    CAST(100.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
         / NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS Cancellation_Rate_Percent
FROM dbo.fact_hotel_bookings_v2
GROUP BY has_special_requests
ORDER BY has_special_requests;
GO
