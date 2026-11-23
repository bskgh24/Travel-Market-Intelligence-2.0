# Travel Market Intelligence 2.0
**Turning Travel Data into Market Intelligence**

An independent end-to-end hotel booking analytics portfolio project using Python, SQL Server and Power BI.

> This project uses a publicly available hotel-booking dataset. It is not Agoda data and is not affiliated with Agoda or any other travel company.

## Project outcomes

| Measure | Recorded result |
|---|---:|
| Source records | 119,390 |
| Exact duplicate rows removed | 31,994 |
| Retained records | 87,396 |
| Source columns | 32 |
| Cleaned columns | 33 |
| Feature-engineered columns | 45 |
| Cancelled bookings | 24,025 |
| Cancellation rate | 27.49% |
| Average ADR | 106.34 |
| Average stay | 3.63 nights |
| Average lead time | 79.89 days |

Exact duplicate rows are not necessarily duplicate bookings. The source does not provide a unique booking identifier.

## Technology

- Python: profiling, cleaning, feature engineering and data-quality audits
- SQL Server: staging, analytical queries and KPI validation
- Power BI: three-page interactive dashboard and DAX measures
- GitHub: version control and project documentation

## Workflow

1. Place the original source file at `data/raw/hotel_bookings_raw.csv`.
2. Install dependencies: `pip install -r requirements.txt`.
3. Run `python/01_data_profiling.py`.
4. Run `python/02_clean_and_engineer.py`.
5. Load the resulting clean or feature-engineered CSV into SQL Server.
6. Run the SQL scripts in numerical order after the required database/table exists.
7. Build or refresh the Power BI report using the validated SQL model.

## Repository structure

```text
Travel-Market-Intelligence-2.0/
├── data/
│   ├── raw/                 # Not committed: original public dataset
│   ├── processed/           # Generated clean data
│   └── final/               # Generated feature-engineered data
├── python/
│   ├── 01_data_profiling.py
│   └── 02_clean_and_engineer.py
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_business_kpi_analysis.sql
│   ├── 03_data_quality_checks.sql
│   └── 04_market_and_trend_analysis.sql
├── documentation/
│   └── project_methodology.md
├── reports/                 # Generated profiling/audit outputs
├── powerbi/                 # PBIX retained locally unless separately published
└── requirements.txt
```

## Key analytical findings

- City Hotel: 53,428 bookings; 16,049 cancellations; 30.04% cancellation rate; average ADR 110.99; average stay 3.15 nights.
- Resort Hotel: 33,968 bookings; 7,976 cancellations; 23.48% cancellation rate; average ADR 99.03; average stay 4.39 nights.
- Online TA is the largest market segment in the retained data (51,618 bookings); its recorded cancellation rate is 35.35%.

## Revenue proxy disclaimer

The non-cancelled room-revenue proxy is calculated as `adr * total_nights`, excluding cancelled bookings and ADR values outside 0–1000. The recorded proxy is 22,976,780.14 (City Hotel 12,159,645.91; Resort Hotel 10,817,134.23). It is not audited or realised revenue. The dataset does not establish completed payments and the currency is not confirmed. Do not add a currency symbol or describe this measure as actual revenue.

## Data-quality caveats

- 166 records have zero guests; preserve and investigate rather than automatically deleting them.
- One ADR value is null.
- One extreme ADR value of 5,400 was identified; flag and investigate rather than silently deleting it.
- `Undefined` market segment contains only two records, both cancelled; avoid broad conclusions from this small group.
- Associations in the data do not establish causation.

## Power BI report

The completed local report has three pages:
1. Hotel Performance Overview
2. Market & Booking Behaviour
3. Revenue & Seasonal Trends

The PBIX is not included in this update package. Add it only if you explicitly intend to publish the report file.

## Data and licensing

The raw and booking-level processed datasets are intentionally excluded from this package. Check the original dataset provider's licence and terms before redistributing source or processed booking-level records.

## Current status

Python preparation, SQL KPI validation and the three-page Power BI dashboard have been completed in the working project. This package provides reproducible scripts and documentation to add to the GitHub repository. Run the scripts against your own local source data and SQL Server environment before treating a fresh run as independently reproduced.
