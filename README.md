# Loan Default Risk Analytics Platform

End-to-end analytics pipeline that predicts loan default risk for a peer-to-peer lending portfolio — from raw data to a production-style risk dashboard.

## Business Problem

Lenders need to price risk accurately and flag high-risk loans before they default. This project builds a complete pipeline — ingest, model, visualize — that mirrors how a credit risk or business analytics team would actually work: a SQL data warehouse, a default-risk model with proper interpretability, and a dashboard a non-technical stakeholder could use.

## Tech Stack

- **Python** — ETL, EDA, machine learning (pandas, scikit-learn, XGBoost, SHAP)
- **SQL** — PostgreSQL warehouse, schema design, analytical queries
- **BI Tool** — Tableau Public / Power BI for the final dashboard

## Architecture

```
Raw CSV (Kaggle) → Python ETL → PostgreSQL (star schema) → SQL/Python EDA → ML model (default risk) → BI dashboard
```

## Roadmap

- [x] **Phase 1 — Scaffolding:** repo structure, environment, problem definition
- [ ] **Phase 2 — Database & ETL:** schema design, ingestion pipeline, validation
- [ ] **Phase 3 — EDA:** SQL-driven business questions, visual analysis
- [ ] **Phase 4 — Modeling:** default-risk classifier, class-imbalance handling, SHAP interpretability
- [ ] **Phase 5 — Dashboard:** interactive portfolio risk-monitoring dashboard
- [ ] **Phase 6 — Polish:** final writeup, visuals, GitHub presentation

## Dataset

Lending Club historical loan data (peer-to-peer lending, 2007–2020) — free on Kaggle, several mirrors available. Field definitions will be added to `docs/data_dictionary.md` in Phase 2.

## Repository Structure

```
├── data/           raw & processed data (gitignored)
├── sql/
│   ├── schema/     DDL — table definitions
│   └── queries/    analysis queries
├── etl/            Python ingestion scripts
├── notebooks/      EDA & modeling notebooks
├── models/         saved model artifacts
├── dashboards/     BI files & exported visuals
└── docs/           data dictionary, architecture notes
```

## Setup

```bash
git clone <your-repo-url>
cd loan-default-risk-analytics
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

## Results

_To be filled in as each phase completes: key findings, model performance, dashboard preview._

## Author

Avanit Singh — https://www.linkedin.com/in/avsinghs24/
