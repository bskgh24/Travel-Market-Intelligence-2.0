# Project Methodology — Travel Market Intelligence 2.0

## Scope and source

Independent portfolio analysis using the public Hotel Booking Demand dataset. The project is not based on proprietary Agoda data. The source covers City Hotel and Resort Hotel bookings.

## Data preparation results

- Source records: 119,390
- Exact duplicate rows removed: 31,994
- Retained records: 87,396
- Source columns: 32
- Cleaned columns: 33
- Feature-engineered columns: 45
- Missing values after documented treatment: 0

Exact duplicate rows are not necessarily duplicate bookings because the source does not contain a unique booking identifier. Missing `children` values were imputed as zero and tracked with `children_was_missing`. Missing `company` and `agent` values were represented as `Not Specified`; missing `country` values as `Unknown`.

## KPI definitions and recorded results

| KPI | Definition | Result |
|---|---|---:|
| Total bookings | Count of retained rows | 87,396 |
| Cancelled bookings | Rows where `is_canceled = 1` | 24,025 |
| Cancellation rate | Cancelled / total | 27.49% |
| Average ADR | Mean ADR | 106.34 |
| Average stay | Mean `total_nights` | 3.63 nights |
| Average lead time | Mean `lead_time` | 79.89 days |

### Hotel comparison

| Hotel | Bookings | Cancellations | Cancellation rate | Average ADR | Average stay |
|---|---:|---:|---:|---:|---:|
| City Hotel | 53,428 | 16,049 | 30.04% | 110.99 | 3.15 nights |
| Resort Hotel | 33,968 | 7,976 | 23.48% | 99.03 | 4.39 nights |

## Feature engineering

The feature-engineered dataset contains 45 columns. Derived fields include `children_was_missing`, `total_nights`, `total_guests`, `is_family_booking`, `arrival_date`, `arrival_quarter`, `arrival_day_of_week`, `is_weekend_arrival`, `has_booking_changes`, `has_special_requests`, `requires_parking`, `lead_time_category` and `stay_category`.

## Revenue proxy

The non-cancelled room-revenue proxy is calculated as `adr * total_nights`, excluding cancelled rows and ADR values outside 0–1000. Recorded result: 22,976,780.14 (City Hotel 12,159,645.91; Resort Hotel 10,817,134.23). This is an analytical proxy, not actual realised or audited revenue. Currency is not confirmed.

## Data-quality caveats

- 166 records have zero guests; retain and investigate rather than automatically deleting.
- One ADR value is null.
- One extreme ADR value of 5,400 was identified; flag and investigate rather than silently deleting.
- `Undefined` market segment has only two records, both cancelled; do not generalise from this small group.
- Associations between booking attributes and cancellation do not establish causation.

## Power BI report

The completed local report has three pages: Hotel Performance Overview; Market & Booking Behaviour; Revenue & Seasonal Trends. The PBIX is not included in this update package. Revenue visuals must retain the proxy disclaimer.

## Reproducibility

The raw and processed booking-level CSVs are not included. Place the original file at `data/raw/hotel_bookings_raw.csv`. SQL scripts expect database `TravelMarketIntelligence` and table `dbo.fact_hotel_bookings_v2`, loaded from the feature-engineered CSV. Validate the table schema and row count before running the analysis scripts.
