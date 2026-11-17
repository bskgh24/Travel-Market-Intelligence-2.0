
"""
Travel Market Intelligence 2.0
01 - Data Profiling

Purpose:
Inspect the source hotel booking dataset before cleaning.
"""

from pathlib import Path
import pandas as pd

# Project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA = PROJECT_ROOT / "Data" / "Raw" / "hotel_bookings_raw.csv"
REPORT_DIR = PROJECT_ROOT / "REPORTS"

REPORT_DIR.mkdir(parents=True, exist_ok=True)

# Load source dataset
df = pd.read_csv(RAW_DATA)

# Basic profiling
profile = {
    "row_count": len(df),
    "column_count": len(df.columns),
    "duplicate_rows": int(df.duplicated().sum()),
    "total_missing_values": int(df.isna().sum().sum()),
}

print("DATASET OVERVIEW")
for key, value in profile.items():
    print(f"{key}: {value}")

# Column-level data quality profile
quality = pd.DataFrame({
    "column": df.columns,
    "data_type": df.dtypes.astype(str).values,
    "missing_count": df.isna().sum().values,
    "missing_percentage": (
        df.isna().mean().values * 100
    ).round(2),
    "unique_values": df.nunique(dropna=False).values
})

quality.to_csv(
    REPORT_DIR / "data_profiling_report.csv",
    index=False
)

print("\nProfiling report saved successfully.")
