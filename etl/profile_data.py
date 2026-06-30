"""
Phase 2a: Profile the raw Lending Club CSV before loading it into Postgres.
Save as etl/profile_data.py. Run after downloading the CSV into data/raw/.
"""
import pandas as pd

RAW_PATH = r"D:\Git Projects\loan-default-risk-analytics\data\loans.csv"  # adjust to your actual filename


def profile(path: str, sample_rows: int = 200_000):
    df = pd.read_csv(path, low_memory=False, nrows=sample_rows)

    print(f"Shape (sampled): {df.shape[0]:,} rows x {df.shape[1]} columns\n")

    print("Columns + dtypes:")
    print(df.dtypes.to_string())

    print("\nMissing % (worst 20):")
    missing = (df.isna().mean() * 100).round(1).sort_values(ascending=False)
    print(missing.head(20).to_string())

    if "loan_status" in df.columns:
        print("\nloan_status value counts:")
        print(df["loan_status"].value_counts().to_string())
    else:
        print("\n! 'loan_status' not found — check your CSV's actual column name")

    if "id" in df.columns:
        print(f"\n'id' column — unique: {df['id'].nunique():,} | "
              f"non-null: {df['id'].notna().sum():,} | total: {len(df):,}")
        print("  (if unique << total, we'll generate a surrogate loan_id in the ETL instead)")

    key_cols = ["loan_amnt", "term", "int_rate", "grade", "sub_grade", "emp_length",
                "home_ownership", "annual_inc", "verification_status", "issue_d",
                "purpose", "dti", "addr_state", "fico_range_low", "fico_range_high",
                "open_acc", "total_acc", "revol_bal", "revol_util", "delinq_2yrs",
                "inq_last_6mths", "pub_rec", "total_pymnt", "total_rec_prncp",
                "total_rec_int", "recoveries", "out_prncp"]
    missing_key = [c for c in key_cols if c not in df.columns]
    if missing_key:
        print(f"\n! Expected columns not found in your file: {missing_key}")
    else:
        print("\nAll expected core columns are present — schema.sql should match cleanly.")


if __name__ == "__main__":
    profile(RAW_PATH)
