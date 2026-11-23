/*
Data-quality checks. Review results; do not automatically delete anomalies.
*/
USE TravelMarketIntelligence;
GO

-- Row count and missingness in key fields
SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN adr IS NULL THEN 1 ELSE 0 END) AS Null_ADR_Rows,
    SUM(CASE WHEN total_guests = 0 THEN 1 ELSE 0 END) AS Zero_Guest_Rows,
    SUM(CASE WHEN adr < 0 OR adr > 1000 THEN 1 ELSE 0 END) AS ADR_Out_Of_Range_Rows
FROM dbo.fact_hotel_bookings_v2;
GO

-- Inspect zero-guest records by cancellation status
SELECT
    is_canceled,
    COUNT(*) AS Zero_Guest_Rows
FROM dbo.fact_hotel_bookings_v2
WHERE total_guests = 0
GROUP BY is_canceled
ORDER BY is_canceled;
GO

-- Inspect extreme ADR rows; preserve pending investigation
SELECT
    hotel, arrival_date, adr, total_nights, adults, children, babies, is_canceled
FROM dbo.fact_hotel_bookings_v2
WHERE adr > 1000 OR adr < 0
ORDER BY adr DESC;
GO

-- Check small or undefined market-segment categories
SELECT
    market_segment,
    COUNT(*) AS Booking_Count,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS Cancelled_Count
FROM dbo.fact_hotel_bookings_v2
GROUP BY market_segment
ORDER BY Booking_Count DESC;
GO
