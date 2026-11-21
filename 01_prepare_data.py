from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
OUT = ROOT / "data" / "processed"
OUT.mkdir(parents=True, exist_ok=True)

FILES = ["leads", "accounts", "opportunities", "opportunity_stage_history",
         "sales_activities", "sales_reps", "sales_targets", "customers"]

def load(name):
    return pd.read_csv(RAW / f"{name}.csv")

def main():
    data = {name: load(name) for name in FILES}

    # Standardize date fields and trim text columns.
    date_cols = {
        "leads": ["created_date"],
        "accounts": ["created_date"],
        "opportunities": ["created_date", "close_date"],
        "opportunity_stage_history": ["stage_entered_date"],
        "sales_activities": ["activity_date"],
        "sales_targets": ["target_month"],
        "customers": ["contract_start_date"],
    }
    for name, cols in date_cols.items():
        for col in cols:
            data[name][col] = pd.to_datetime(data[name][col], errors="coerce")

    for name, df in data.items():
        for col in df.select_dtypes(include="object").columns:
            df[col] = df[col].astype("string").str.strip()

    # Remove duplicate primary keys only; preserve duplicate-risk flags as QA exceptions.
    pk = {
        "leads":"lead_id", "accounts":"account_id", "opportunities":"opportunity_id",
        "opportunity_stage_history":None, "sales_activities":"activity_id",
        "sales_reps":"rep_id", "sales_targets":None, "customers":"customer_id"
    }
    for name, key in pk.items():
        if key:
            data[name] = data[name].drop_duplicates(subset=[key], keep="first")

    # Enrich opportunities with rep and account attributes for simple BI use.
    opp = data["opportunities"].merge(
        data["accounts"][["account_id","industry","company_size","billing_country"]],
        on="account_id", how="left", validate="many_to_one"
    ).merge(
        data["sales_reps"][["rep_id","rep_name","sales_team"]],
        on="rep_id", how="left", validate="many_to_one"
    )
    opp["weighted_pipeline"] = opp["acv"] * opp["probability"]
    opp["is_open"] = opp["outcome"].eq("Open").astype(int)
    opp["is_won"] = opp["outcome"].eq("Closed Won").astype(int)
    opp["is_lost"] = opp["outcome"].eq("Closed Lost").astype(int)
    opp.to_csv(OUT / "opportunities_enriched.csv", index=False, date_format="%Y-%m-%d")

    # Activity recency by opportunity.
    acts = data["sales_activities"].copy()
    acts["activity_date"] = pd.to_datetime(acts["activity_date"])
    last_activity = acts.groupby("opportunity_id", as_index=False)["activity_date"].max()
    last_activity.rename(columns={"activity_date":"last_activity_date"}, inplace=True)
    opp_activity = opp.merge(last_activity, on="opportunity_id", how="left")
    opp_activity.to_csv(OUT / "opportunity_activity_health.csv", index=False, date_format="%Y-%m-%d")

    # Lightweight QA report.
    qa = []
    for name, df in data.items():
        qa.append({"table_name":name, "row_count":len(df), "duplicate_rows":int(df.duplicated().sum()),
                   "null_cells":int(df.isna().sum().sum())})
    pd.DataFrame(qa).to_csv(ROOT / "outputs" / "qa_reports" / "table_profile.csv", index=False)

    # Referential integrity checks.
    checks = []
    checks.append(["opportunities.account_id", int((~data["opportunities"].account_id.isin(data["accounts"].account_id)).sum())])
    checks.append(["opportunities.rep_id", int((~data["opportunities"].rep_id.isin(data["sales_reps"].rep_id)).sum())])
    checks.append(["activities.opportunity_id", int((~data["sales_activities"].opportunity_id.isin(data["opportunities"].opportunity_id)).sum())])
    pd.DataFrame(checks, columns=["check_name","orphan_count"]).to_csv(
        ROOT / "outputs" / "qa_reports" / "referential_integrity.csv", index=False
    )
    print("ETL complete. Processed files and QA reports written.")

if __name__ == "__main__":
    main()
