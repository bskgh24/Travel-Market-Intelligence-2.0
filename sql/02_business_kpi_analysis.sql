/*
Core KPI validation against dbo.fact_hotel_bookings_v2.
Run only after importing the 45-column feature-engineered CSV.
*/
USE TravelMarketIntelligence;
GO

-- Overall KPIs
SELECT
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Cancelled_Bookings,
    CAST(100.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
         / NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS Cancellation_Rate_Percent,
    AVG(CAST(adr AS DECIMAL(18,4))) AS Average_ADR,
    AVG(CAST(total_nights AS DECIMAL(10,2))) AS Average_Stay_Nights,
    AVG(CAST(lead_time AS DECIMAL(10,2))) AS Average_Lead_Time_Days
FROM dbo.fact_hotel_bookings_v2;
GO

-- Hotel-level KPIs
SELECT
    hotel,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Cancelled_Bookings,
    CAST(100.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
         / NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS Cancellation_Rate_Percent,
    AVG(CAST(adr AS DECIMAL(18,4))) AS Average_ADR,
    AVG(CAST(total_nights AS DECIMAL(10,2))) AS Average_Stay_Nights
FROM dbo.fact_hotel_bookings_v2
GROUP BY hotel
ORDER BY Total_Bookings DESC;
GO

-- Analytical revenue proxy: non-cancelled rows; ADR restricted to 0–1000.
-- This is NOT audited or realised revenue. Currency is not confirmed.
SELECT
    hotel,
    SUM(CAST(adr AS DECIMAL(18,4)) * total_nights) AS Estimated_Revenue_Proxy
FROM dbo.fact_hotel_bookings_v2
WHERE is_canceled = 0
  AND adr >= 0
  AND adr <= 1000
GROUP BY hotel
ORDER BY Estimated_Revenue_Proxy DESC;
GO
