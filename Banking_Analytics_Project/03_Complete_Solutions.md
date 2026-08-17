# Complete Solutions: SQL & Python Banking Analytics

This document provides fully tested, complete solutions in **SQL** (PostgreSQL / ANSI SQL compliant) and **Python (Pandas)**.

---

## Part 1: Complete SQL Solutions

```sql
-- =============================================================================
-- MODULE 1: DATA CLEANING & STAGING
-- =============================================================================

-- Step 1.1: Create Staging Table with Deduplication & Data Cleaning
DROP TABLE IF EXISTS stg_customers;

CREATE TABLE stg_customers AS
WITH deduplicated AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY transaction_date) as rn
    FROM raw_customers
)
SELECT 
    id AS customer_id,
    TRIM(customer_name) AS customer_name,
    UPPER(TRIM(account_type)) AS account_type,
    -- Handle NULL balance with account-type average imputation, clamp negative balances to 0
    COALESCE(
        CASE WHEN balance < 0 THEN 0 ELSE balance END,
        AVG(CASE WHEN balance >= 0 THEN balance END) OVER (PARTITION BY UPPER(TRIM(account_type)))
    ) AS clean_balance,
    -- Unified Date Parsing
    CASE 
        WHEN transaction_date LIKE '%/%' THEN TO_DATE(transaction_date, 'DD/MM/YYYY')
        WHEN transaction_date LIKE '%-%' AND LENGTH(transaction_date) = 10 AND SUBSTRING(transaction_date, 3, 1) = '-' THEN TO_DATE(transaction_date, 'DD-MM-YYYY')
        ELSE TO_DATE(transaction_date, 'YYYY-MM-DD')
    END AS transaction_date,
    UPPER(TRIM(city)) AS city,
    UPPER(TRIM(status)) AS status,
    TRIM(branch_code) AS branch_code
FROM deduplicated
WHERE rn = 1;

-- =============================================================================
-- MODULE 2: DIMENSIONAL MODELING (STAR SCHEMA)
-- =============================================================================

-- Create Customer Dimension Table
CREATE TABLE dim_customers AS
SELECT 
    customer_id,
    customer_name,
    account_type,
    city,
    status,
    branch_code
FROM stg_customers;

-- Create Fact Transactions Table
CREATE TABLE fact_transactions AS
SELECT 
    t.transaction_id,
    t.customer_id,
    UPPER(TRIM(t.transaction_type)) AS transaction_type,
    t.amount,
    CAST(t.transaction_time AS TIMESTAMP) AS transaction_time,
    TRIM(t.merchant_category) AS merchant_category,
    UPPER(TRIM(t.status)) AS transaction_status
FROM raw_transactions t;

-- =============================================================================
-- MODULE 3: ADVANCED SQL ANALYTICS
-- =============================================================================

-- Task 3.1: Customer Segmentation using CASE & GROUP BY
SELECT 
    city,
    CASE 
        WHEN clean_balance >= 20000 THEN 'High Value'
        WHEN clean_balance >= 5000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(clean_balance), 2) AS avg_segment_balance
FROM stg_customers
GROUP BY 
    city,
    CASE 
        WHEN clean_balance >= 20000 THEN 'High Value'
        WHEN clean_balance >= 5000 THEN 'Mid Value'
        ELSE 'Low Value'
    END
ORDER BY city, total_customers DESC;

-- Task 3.2: Transaction Ranking per Customer using DENSE_RANK()
SELECT 
    customer_id,
    transaction_id,
    amount,
    DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS amount_rank
FROM fact_transactions
WHERE transaction_status = 'COMPLETED';

-- Task 3.3: Cumulative Running Total using SUM() OVER()
SELECT 
    customer_id,
    transaction_id,
    transaction_time,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id 
        ORDER BY transaction_time 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_spent
FROM fact_transactions
WHERE transaction_status = 'COMPLETED';

-- Task 3.4: Time Difference Between Consecutive Transactions using LAG()
SELECT 
    customer_id,
    transaction_id,
    transaction_time,
    LAG(transaction_time) OVER (PARTITION BY customer_id ORDER BY transaction_time) AS prev_transaction_time,
    ROUND(
        EXTRACT(EPOCH FROM (transaction_time - LAG(transaction_time) OVER (PARTITION BY customer_id ORDER BY transaction_time))) / 3600, 
        2
    ) AS hours_since_last_txn
FROM fact_transactions;

-- Task 3.5: Consolidating Activity via UNION ALL
SELECT transaction_id, customer_id, amount, 'COMPLETED' AS audit_status FROM fact_transactions WHERE transaction_status = 'COMPLETED'
UNION ALL
SELECT transaction_id, customer_id, amount, 'FAILED_ATTEMPT' AS audit_status FROM fact_transactions WHERE transaction_status = 'FAILED';

-- =============================================================================
-- MODULE 4: BI REPORTING VIEWS
-- =============================================================================

CREATE OR REPLACE VIEW vw_customer_360 AS
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.account_type,
    c.clean_balance AS current_balance,
    COUNT(t.transaction_id) AS total_transactions,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'DEPOSIT' THEN t.amount ELSE 0 END), 0) AS total_deposited,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'WITHDRAWAL' THEN t.amount ELSE 0 END), 0) AS total_withdrawn
FROM stg_customers c
LEFT JOIN fact_transactions t ON c.customer_id = t.customer_id AND t.transaction_status = 'COMPLETED'
GROUP BY c.customer_id, c.customer_name, c.city, c.account_type, c.clean_balance;
```

---

## Part 2: Complete Python Solutions (Pandas)

```python
import pandas as pd
import numpy as np

# 1. Load Datasets
df_cust = pd.read_csv('../data/raw_customers.csv')
df_txn = pd.read_csv('../data/raw_transactions.csv')

# 2. Data Cleaning
# Remove duplicates
df_cust = df_cust.drop_duplicates(subset=['id'], keep='first').copy()

# Trim whitespaces & standardize casing
df_cust['customer_name'] = df_cust['customer_name'].str.strip()
df_cust['account_type'] = df_cust['account_type'].str.strip().str.upper()
df_cust['city'] = df_cust['city'].str.strip().str.upper()
df_cust['status'] = df_cust['status'].str.strip().str.upper()

# Handle negative balance & NULL balance imputation
df_cust['balance'] = np.where(df_cust['balance'] < 0, 0, df_cust['balance'])
df_cust['balance'] = df_cust.groupby('account_type')['balance'].transform(lambda x: x.fillna(x.mean()))

# Parse heterogeneous dates
df_cust['transaction_date'] = pd.to_datetime(df_cust['transaction_date'], format='mixed')

# Print Clean Summary
print("--- Cleaned Customer Data Summary ---")
print(df_cust.info())
print(df_cust.head())
```
