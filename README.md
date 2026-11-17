# Travel Market Intelligence 2.0

**Turning Travel Data into Market Intelligence**

## Project Overview

Travel Market Intelligence 2.0 is an end-to-end hotel booking analytics project demonstrating how data analytics can support business decisions in the hospitality and travel industry.

The project uses Python, SQL Server and Power BI to transform hotel booking data into actionable business insights through data cleaning, feature engineering, data quality validation, KPI analysis, market segmentation and revenue trend analysis.

This is an independent portfolio project using a publicly available hotel booking dataset. It is not affiliated with or based on proprietary data from Agoda or any other travel company.

## Technology Stack

- **Python:** Data profiling, data cleaning, feature engineering and data quality audits
- **SQL Server:** Data staging, transformation, analytical queries and KPI validation
- **Power BI:** Interactive dashboards, DAX measures and business intelligence reporting
- **GitHub:** Project version control and documentation

## Dataset

The project uses the publicly available Hotel Booking Demand dataset, covering City Hotel and Resort Hotel booking records.

- Original records: 119,390
- Records retained after exact duplicate removal: 87,396
- Original dataset columns: 32
- Feature-engineered dataset columns: 45

The removal of exact duplicate rows is a data-cleaning operation. It does not establish that every removed row represented a duplicate booking, as the source does not provide a unique booking identifier.

## Project Workflow

1. **Data Profiling:** Examine dataset structure, missing values, duplicate records and data distributions.
2. **Data Cleaning:** Handle missing values and exact duplicate rows while preserving relevant data quality indicators.
3. **Feature Engineering:** Create analytical features related to stay duration, guest composition, arrival dates, booking changes and special requests.
4. **SQL Analytics:** Load the processed data into SQL Server and validate business KPIs.
5. **Power BI Reporting:** Develop dashboards covering hotel performance, booking behaviour, market segments and revenue trends.
6. **Data Quality Auditing:** Document transformation decisions and data quality observations.

## Key Analytical Findings

- Total retained booking records: 87,396
- Cancelled bookings: 24,025
- Overall cancellation rate: 27.49%
- Average daily rate (ADR): 106.34
- Average stay duration: 3.63 nights

These figures describe the retained dataset and are not forecasts or audited financial results.

## Revenue Analysis Disclaimer

Revenue-related measures are analytical proxies derived from ADR and stay duration. They should not be interpreted as actual realised hotel revenue because the dataset does not establish completed payments or realised revenue.

## Repository Contents

| File | Description |
|---|---|
| `overall_business_kpis.csv` | Overall business KPI summary |
| `hotel_performance_kpis.csv` | Hotel-level performance summary |
| `market_segment_kpis.csv` | Market segment analysis |
| `monthly_booking_trends.csv` | Monthly booking trend summary |
| `stage3_data_quality_audit.csv` | Data quality audit |
| `stage3_transformation_audit.json` | Transformation audit details |

## Project Status

The Python data preparation and SQL KPI validation stages have been completed. Power BI dashboards have been developed as part of the project. Further documentation and report files will be added as the repository is organised.

## Data and Licensing

The original dataset is publicly available for research and educational use. Please refer to the original dataset provider's licence and terms before redistributing source or processed booking-level data.

This repository currently publishes summary KPI and audit outputs rather than the full booking-level dataset.

## Author

Independent Data Analytics Portfolio Project

**Focus Areas:** Data Analytics | Business Intelligence | Python | SQL Server | Power BI | Travel Analytics
