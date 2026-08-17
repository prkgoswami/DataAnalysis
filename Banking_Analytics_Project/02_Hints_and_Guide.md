# Hints & Guidance Guide

Use these hints if you get stuck on any task.

---

## Module 1: Data Cleaning Hints

* **String Cleaning**: Use `TRIM()` for whitespaces and `UPPER()` or `LOWER()` for string standardization.
* **Deduplication**: Use `ROW_NUMBER() OVER(PARTITION BY id ORDER BY transaction_date)` to flag duplicate rows where row number > 1.
* **Date Parsing**:
  - In PostgreSQL: Use `CASE WHEN` with `TO_DATE(date_str, 'YYYY-MM-DD')`, `TO_DATE(date_str, 'DD/MM/YYYY')`, etc.
  - In MySQL: Use `STR_TO_DATE()`.
  - In SQLite: Use `SUBSTR()` or string manipulation.
* **NULL Imputation**: Use `COALESCE(balance, (SELECT AVG(balance) FROM ...))` or update with windowed averages.

---

## Module 2: Dimensional Modeling Hints

* **Fact vs. Dimension**:
  - **Dimensions** describe *who*, *where*, *what* (Customer Name, City, Branch).
  - **Facts** store numerical measurements/events (*Amount*, *Quantity*, *Balance*).

---

## Module 3: SQL Analytics Hints

* **CASE Statement Syntax**:
  ```sql
  CASE 
      WHEN balance >= 20000 THEN 'High Value'
      WHEN balance >= 5000 THEN 'Mid Value'
      ELSE 'Low Value'
  END
  ```
* **Window Functions**:
  - `DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC)`
  - `SUM(amount) OVER (PARTITION BY customer_id ORDER BY transaction_time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`
  - `LAG(transaction_time) OVER (PARTITION BY customer_id ORDER BY transaction_time)`

---

## Module 5: Python Pandas Hints

* **String Operations**: `df['customer_name'] = df['customer_name'].str.strip()`
* **Date Parsing**: `df['transaction_date'] = pd.to_datetime(df['transaction_date'], format='mixed')`
* **Grouping**: `df.groupby(['city', 'account_type'])['balance'].mean()`
