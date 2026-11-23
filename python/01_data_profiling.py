"""Profile the raw Hotel Booking Demand CSV before transformation."""
from pathlib import Path
import json
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW_FILE = ROOT / "data" / "raw" / "hotel_bookings_raw.csv"
REPORT_DIR = ROOT / "reports"
REPORT_DIR.mkdir(parents=True, exist_ok=True)

if not RAW_FILE.exists():
    raise FileNotFoundError(
        f"Source file not found: {RAW_FILE}\n"
        "Place hotel_bookings_raw.csv in data/raw/."
    )

df = pd.read_csv(RAW_FILE)
summary = {
    "source_file": str(RAW_FILE.relative_to(ROOT)),
    "row_count": int(len(df)),
    "column_count": int(len(df.columns)),
    "exact_duplicate_rows": int(df.duplicated().sum()),
    "total_missing_cells": int(df.isna().sum().sum()),
}
quality = pd.DataFrame({
    "column": df.columns,
    "data_type": df.dtypes.astype(str).values,
    "missing_count": df.isna().sum().values,
    "missing_percentage": (df.isna().mean().values * 100).round(2),
    "unique_values": df.nunique(dropna=False).values,
})
quality.to_csv(REPORT_DIR / "data_profiling_report.csv", index=False)
(REPORT_DIR / "data_profiling_summary.json").write_text(
    json.dumps(summary, indent=2), encoding="utf-8"
)
print(json.dumps(summary, indent=2))
print(f"Profiling outputs saved to: {REPORT_DIR}")
