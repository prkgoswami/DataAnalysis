# Master Banking Data Analytics Project: SQL & Python Guide

Welcome to the **End-to-End Banking Data Analytics Hands-On Project**. This project is specifically designed to take you from foundational data cleaning up to advanced analytical reporting using **SQL** and **Python**.

---

## 📁 Repository Structure

```
Banking_Analytics_Project/
├── data/
│   ├── raw_customers.csv          # Raw customer dataset with deliberate abnormalities
│   └── raw_transactions.csv       # Raw transactional dataset
├── sql/
│   ├── 01_data_cleaning.sql       # Cleaning queries (SQL)
│   ├── 02_analytical_tasks.sql    # Core Analysis, GroupBy, Window Functions, Case
│   └── 03_reporting_views.sql     # Executive Dashboards & Dimensional Modeling
├── python/
│   ├── 01_data_cleaning.py        # Pandas Cleaning & Normalization
│   └── 02_eda_and_visualization.py# Exploratory Data Analysis & Visualizations
├── 01_Project_Tasks.md            # Detailed Task Breakdown
├── 02_Hints_and_Guide.md          # Hints for every task
└── 03_Complete_Solutions.md      # Fully executed SQL & Python code
```

---

## 🎯 Project Objectives

1. **Data Cleaning & Quality Assurance**:
   - Trim leading/trailing whitespaces.
   - Standardize strings (casing, city names, account types).
   - Handle missing/NULL values using imputation strategy.
   - Standardize heterogeneous date formats (`YYYY-MM-DD`, `DD/MM/YYYY`, `DD-MM-YYYY`, `YYYY/MM/DD`).
   - Deduplicate records.

2. **Dimensional Modeling & Schema Architecture**:
   - Understand **Fact tables** (`fact_transactions`) vs. **Dimension tables** (`dim_customers`, `dim_branch`).
   - Design Star Schema star models.

3. **End-to-End Data Analysis**:
   - Aggregate statistics with `GROUP BY` and `HAVING`.
   - Categorize accounts using `CASE WHEN`.
   - Calculate running totals, customer transaction rankings, and lead/lag date differences using **Window Functions** (`ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER()`, `LAG()`).
   - Merge datasets using `INNER JOIN`, `LEFT JOIN`, and `UNION ALL`.

4. **Executive Reporting**:
   - Build SQL Views for Business Intelligence tools (Power BI, Tableau, Excel).

5. **Python Analytics Extension**:
   - Perform equivalent cleaning and Exploratory Data Analysis (EDA) using `pandas`, `matplotlib`, and `seaborn`.

---

## 🚀 How to Get Started

1. Navigate to `01_Project_Tasks.md` to see the step-by-step challenges.
2. Attempt to solve each task on your local database or Python environment.
3. If you get stuck, refer to `02_Hints_and_Guide.md`.
4. Review full working solutions in `03_Complete_Solutions.md`.
