-- =============================================================================
-- BANKING DATA ANALYTICS: DATA CLEANING & STAGING
-- =============================================================================

-- Drop staging table if exists
DROP TABLE IF EXISTS stg_customers;

-- Step 1: Create Staging Table with Deduplication, String Cleaning & Date Normalization
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
    -- Clamp negative balances to 0 and impute NULL balances with account_type average
    COALESCE(
        CASE WHEN balance < 0 THEN 0 ELSE balance END,
        AVG(CASE WHEN balance >= 0 THEN balance END) OVER (PARTITION BY UPPER(TRIM(account_type)))
    ) AS clean_balance,
    -- Handle mixed date format parsing
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
