"""Clean and feature-engineer the public hotel booking dataset.

This script preserves the raw file. Exact duplicate rows are removed, but
that does not prove duplicate bookings because the source has no booking ID.
"""
from pathlib import Path
import json
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
RAW_FILE = ROOT / "data" / "raw" / "hotel_bookings_raw.csv"
PROCESSED_DIR = ROOT / "data" / "processed"
FINAL_DIR = ROOT / "data" / "final"
REPORT_DIR = ROOT / "reports"
for folder in (PROCESSED_DIR, FINAL_DIR, REPORT_DIR):
    folder.mkdir(parents=True, exist_ok=True)

if not RAW_FILE.exists():
    raise FileNotFoundError(
        f"Source file not found: {RAW_FILE}\n"
        "Place hotel_bookings_raw.csv in data/raw/."
    )

df = pd.read_csv(RAW_FILE)
source_rows, source_cols = df.shape
duplicates_removed = int(df.duplicated().sum())
df = df.drop_duplicates().copy()

# Retain missingness flags before imputing.
if "children" in df.columns:
    df["children_was_missing"] = df["children"].isna().astype("int8")
    df["children"] = df["children"].fillna(0)

for col, replacement in {
    "company": "Not Specified",
    "agent": "Not Specified",
    "country": "Unknown",
}.items():
    if col in df.columns:
        df[col] = df[col].fillna(replacement)

# Defensive handling: do not silently impute unexpected columns.
remaining = int(df.isna().sum().sum())
if remaining:
    missing_cols = df.columns[df.isna().any()].tolist()
    raise ValueError(
        f"{remaining} missing values remain in {missing_cols}. "
        "Review and explicitly document a treatment before continuing."
    )

required = [
    "arrival_date_year", "arrival_date_month", "arrival_date_day_of_month",
    "stays_in_weekend_nights", "stays_in_week_nights",
    "adults", "children", "babies", "lead_time",
    "booking_changes", "total_of_special_requests",
    "required_car_parking_spaces",
]
missing_required = [c for c in required if c not in df.columns]
if missing_required:
    raise ValueError(f"Required source columns missing: {missing_required}")

month_map = {
    name: number for number, name in enumerate(
        ["January", "February", "March", "April", "May", "June",
         "July", "August", "September", "October", "November", "December"], 1
    )
}
month_num = df["arrival_date_month"].map(month_map)
if month_num.isna().any():
    raise ValueError("Unexpected arrival_date_month value found.")

df["total_nights"] = (
    df["stays_in_weekend_nights"] + df["stays_in_week_nights"]
).astype("int64")
df["total_guests"] = (
    df["adults"] + df["children"] + df["babies"]
).astype("int64")
df["is_family_booking"] = (
    (df["children"] > 0) | (df["babies"] > 0)
).astype("int8")
df["arrival_date"] = pd.to_datetime({
    "year": df["arrival_date_year"],
    "month": month_num.astype(int),
    "day": df["arrival_date_day_of_month"],
}, errors="raise")
df["arrival_quarter"] = "Q" + df["arrival_date"].dt.quarter.astype(str)
df["arrival_day_of_week"] = df["arrival_date"].dt.day_name()
df["is_weekend_arrival"] = (
    df["arrival_date"].dt.dayofweek >= 5
).astype("int8")
df["has_booking_changes"] = (df["booking_changes"] > 0).astype("int8")
df["has_special_requests"] = (
    df["total_of_special_requests"] > 0
).astype("int8")
df["requires_parking"] = (
    df["required_car_parking_spaces"] > 0
).astype("int8")

df["lead_time_category"] = pd.cut(
    df["lead_time"],
    bins=[-1, 7, 30, 90, 180, 365, np.inf],
    labels=["0-7 days", "8-30 days", "31-90 days",
            "91-180 days", "181-365 days", "365+ days"],
    right=True,
).astype("string")

df["stay_category"] = pd.cut(
    df["total_nights"],
    bins=[-1, 1, 3, 7, 14, np.inf],
    labels=["0-1 nights", "2-3 nights", "4-7 nights",
            "8-14 nights", "15+ nights"],
    right=True,
).astype("string")

clean_path = PROCESSED_DIR / "hotel_bookings_cleaned.csv"
feature_path = FINAL_DIR / "hotel_bookings_feature_engineered.csv"
df.to_csv(feature_path, index=False)

# The clean output intentionally precedes engineered fields.
clean_cols = [c for c in df.columns if c not in {
    "total_nights", "total_guests", "is_family_booking", "arrival_date",
    "arrival_quarter", "arrival_day_of_week", "is_weekend_arrival",
    "has_booking_changes", "has_special_requests", "requires_parking",
    "lead_time_category", "stay_category",
}]
df[clean_cols].to_csv(clean_path, index=False)

audit = {
    "source_records": int(source_rows),
    "source_columns": int(source_cols),
    "exact_duplicate_rows_removed": duplicates_removed,
    "retained_records": int(len(df)),
    "cleaned_columns": int(len(clean_cols)),
    "feature_engineered_columns": int(df.shape[1]),
    "remaining_missing_values": int(df.isna().sum().sum()),
    "remaining_exact_duplicate_rows": int(df.duplicated().sum()),
    "children_missing_flagged": int(df["children_was_missing"].sum()),
    "company_missing_replacement": "Not Specified",
    "agent_missing_replacement": "Not Specified",
    "country_missing_replacement": "Unknown",
    "note": "Exact duplicate rows are not necessarily duplicate bookings; no unique booking ID exists."
}
(REPORT_DIR / "transformation_audit.json").write_text(
    json.dumps(audit, indent=2), encoding="utf-8"
)
print(json.dumps(audit, indent=2))
print(f"Cleaned CSV: {clean_path}")
print(f"Feature-engineered CSV: {feature_path}")
