-- =============================================================================
-- BANKING DATA ANALYTICS: REPORTING VIEWS FOR BI DASHBOARDS
-- =============================================================================

-- View 1: Customer 360 Degree View
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

-- View 2: Branch Performance Metrics
CREATE OR REPLACE VIEW vw_branch_performance AS
SELECT 
    c.branch_code,
    c.city,
    COUNT(DISTINCT c.customer_id) AS active_customers,
    ROUND(SUM(c.clean_balance), 2) AS total_branch_liquidity,
    ROUND(AVG(c.clean_balance), 2) AS avg_customer_balance,
    COUNT(t.transaction_id) AS total_branch_transactions
FROM stg_customers c
LEFT JOIN fact_transactions t ON c.customer_id = t.customer_id
GROUP BY c.branch_code, c.city;
