/*
Project: Travel Market Intelligence 2.0
Purpose: Validate core business KPIs.
Source: dbo.fact_hotel_bookings_v2
*/

USE TravelMarketIntelligence;
GO

-- 1. Overall booking KPIs
SELECT
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
        AS Cancelled_Bookings,
    CAST(
        100.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS Cancellation_Rate_Percent,
    AVG(adr) AS Average_ADR,
    AVG(CAST(total_nights AS DECIMAL(10,2)))
        AS Average_Stay_Nights
FROM dbo.fact_hotel_bookings_v2;
GO

-- 2. Hotel-level performance
SELECT
    hotel,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
        AS Cancelled_Bookings,
    CAST(
        100.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS Cancellation_Rate_Percent,
    AVG(adr) AS Average_ADR,
    AVG(CAST(total_nights AS DECIMAL(10,2)))
        AS Average_Stay_Nights
FROM dbo.fact_hotel_bookings_v2
GROUP BY hotel
ORDER BY Total_Bookings DESC;
GO

-- 3. Revenue proxy: non-cancelled bookings
-- Excludes ADR values outside the 0–1000 range.
-- This is an analytical proxy, not audited realised revenue.

SELECT
    hotel,
    SUM(adr * total_nights) AS Estimated_Revenue_Proxy
FROM dbo.fact_hotel_bookings_v2
WHERE is_canceled = 0
  AND adr >= 0
  AND adr <= 1000
GROUP BY hotel
ORDER BY Estimated_Revenue_Proxy DESC;
GO
