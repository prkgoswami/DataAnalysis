-- =============================================================================
-- BANKING DATA ANALYTICS: ANALYTICAL TASKS
-- =============================================================================

-- Task 3.1: Customer Segmentation using CASE and GROUP BY
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

-- Task 3.5: Audit Consolidation using UNION ALL
SELECT transaction_id, customer_id, amount, 'COMPLETED' AS audit_status FROM fact_transactions WHERE transaction_status = 'COMPLETED'
UNION ALL
SELECT transaction_id, customer_id, amount, 'FAILED_ATTEMPT' AS audit_status FROM fact_transactions WHERE transaction_status = 'FAILED';
