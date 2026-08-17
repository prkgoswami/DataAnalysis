# Banking Analytics Project — Task Breakdown

Follow these tasks sequentially to complete the end-to-end data analytics workflow.

---

## Module 1: Data Cleaning & Normalization (SQL)

The raw CSV file `raw_customers.csv` contains common data quality issues:
- **Whitespaces**: Extra leading/trailing spaces in customer names.
- **Inconsistent String Casing**: City names like `New York`, `NEW YORK`, `houston`. Account types like `Savings`, `SAVINGS`, `checking`.
- **Date Format Heterogeneity**: Mixed formats (`YYYY-MM-DD`, `DD/MM/YYYY`, `DD-MM-YYYY`, `YYYY/MM/DD`).
- **Duplicates**: Duplicate rows (e.g., `id = 101`).
- **NULL/Missing Values**: `balance` contains NULLs and negative values.

### Tasks:
1. **Task 1.1**: Deduplicate `raw_customers` and store clean unique customer records into a staging table `stg_customers`.
2. **Task 1.2**: Strip whitespaces from `customer_name`.
3. **Task 1.3**: Standardize `account_type` to UPPERCASE (`SAVINGS`, `CHECKING`) and `city` to Title Case / Uppercase (`NEW YORK`, `CHICAGO`, `HOUSTON`).
4. **Task 1.4**: Parse mixed string dates into a unified SQL `DATE` data type (`YYYY-MM-DD`).
5. **Task 1.5**: Handle missing/NULL balances by imputing with the median/average balance of the respective `account_type`. Replace negative balances with zero or mark them as overdraft.

---

## Module 2: Dimensional Modeling (Fact & Dimension Concepts)

1. **Task 2.1**: Design a **Dimension Table** `dim_customers` containing customer demographic attributes.
2. **Task 2.2**: Design a **Fact Table** `fact_transactions` containing transactional metrics linked to `dim_customers` via `customer_id`.

---

## Module 3: Intermediate & Advanced SQL Analytics

1. **Task 3.1 (CASE & Grouping)**: Categorize customers into balance tiers (`High Value` > $20k, `Mid Value` $5k–$20k, `Low Value` < $5k) and count how many customers fall into each tier per city.
2. **Task 3.2 (Window Functions - Ranking)**: Rank transactions for each customer from highest amount to lowest amount using `DENSE_RANK()`.
3. **Task 3.3 (Window Functions - Running Totals)**: Calculate a cumulative running total of transaction amounts over time for each customer using `SUM() OVER()`.
4. **Task 3.4 (Window Functions - LAG/LEAD)**: Find the time difference (in days or hours) between consecutive transactions for each customer using `LAG()`.
5. **Task 3.5 (UNION / UNION ALL)**: Combine completed transactions and failed transactions into a consolidated audit report with a status flag.
6. **Task 3.6 (Joins & Metrics)**: Find the top 3 customers per city based on their total transaction volume using `JOIN` + `RANK()`.

---

## Module 4: BI Reporting Views

1. **Task 4.1**: Create a SQL View `vw_branch_performance` showing Total Deposits, Total Withdrawals, Active Customer Count, and Average Balance by Branch.
2. **Task 4.2**: Create a SQL View `vw_customer_360` combining customer demographic profiles, account balance, total transaction count, and total spend for Power BI / Tableau dashboards.

---

## Module 5: Python Analytics & Visualization

1. **Task 5.1**: Load `raw_customers.csv` and `raw_transactions.csv` using `pandas`.
2. **Task 5.2**: Replicate the data cleaning pipeline in Python (`str.strip()`, `str.upper()`, `pd.to_datetime()`, `dropna()`, `fillna()`).
3. **Task 5.3**: Generate exploratory charts using `matplotlib` / `seaborn`:
   - Account Balance Distribution by City (Box Plot).
   - Transaction Volume over Time (Line Chart).
   - Failed vs. Completed Transactions by Channel (Bar Chart).
