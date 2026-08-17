-- =============================================================================
-- BANKING DATA ANALYTICS: RAW TABLES DDL & INSERT SCRIPT
-- =============================================================================

-- Drop raw tables if they exist
DROP TABLE IF EXISTS raw_customers;
DROP TABLE IF EXISTS raw_transactions;

-- 1. Create Raw Customers Table (stores raw uncleaned strings & abnormalities)
CREATE TABLE raw_customers (
    id VARCHAR(50),
    customer_name VARCHAR(100),
    account_type VARCHAR(50),
    balance NUMERIC(12, 2),
    transaction_date VARCHAR(50),
    city VARCHAR(100),
    status VARCHAR(50),
    branch_code VARCHAR(50)
);

-- 2. Create Raw Transactions Table
CREATE TABLE raw_transactions (
    transaction_id VARCHAR(50),
    customer_id INT,
    transaction_type VARCHAR(50),
    amount NUMERIC(12, 2),
    transaction_time VARCHAR(50),
    merchant_category VARCHAR(100),
    status VARCHAR(50)
);

-- =============================================================================
-- INSERT RAW DATA: CUSTOMERS
-- =============================================================================

INSERT INTO raw_customers (id, customer_name, account_type, balance, transaction_date, city, status, branch_code) VALUES
('101', '  John Doe ', 'Savings', 15000.50, '2026-01-15', 'New York', 'ACTIVE', 'BR001'),
('102', 'Jane Smith', 'Checking', 25000.00, '15/01/2026', 'NEW YORK', 'ACTIVE', 'BR001'),
('103', '   Robert Johnson ', 'SAVINGS', -500.00, '2026-01-16', 'Chicago', 'ACTIVE', 'BR002'),
('104', 'Alice Williams', 'checking', 12000.75, '2026-01-17', 'CHICAGO', 'INACTIVE', 'BR002'),
('105', 'Charlie Brown', 'Savings', NULL, '2026-01-18', 'Houston', 'ACTIVE', 'BR003'),
('101', '  John Doe ', 'Savings', 15000.50, '2026-01-15', 'New York', 'ACTIVE', 'BR001'), -- Duplicate row
('106', '  Eva Green ', 'CHECKING', 8500.25, '19-01-2026', 'houston', 'ACTIVE', 'BR003'),
('107', 'David Miller', 'Savings', 45000.00, '2026-02-01', 'New York', 'INACTIVE', 'BR001'),
('108', '  Frank Wilson ', 'Checking', NULL, '2026/02/02', 'CHICAGO', 'ACTIVE', 'BR002'),
('109', 'Grace Lee', 'SAVINGS', 6700.00, '2026-02-03', 'New York', 'ACTIVE', 'BR001'),
('110', '  Hank Adams ', 'checking', 3200.00, '04-02-2026', 'Houston', 'INACTIVE', 'BR003'),
('111', 'Ivy Taylor', 'Savings', 18900.50, '2026-02-05', 'Chicago', 'ACTIVE', 'BR002'),
('112', 'Jack Anderson', 'CHECKING', 95000.00, '2026-02-06', 'NEW YORK', 'ACTIVE', 'BR001'),
('113', 'Karen Thomas', 'Savings', 450.00, '2026-02-07', 'houston', 'INACTIVE', 'BR003'),
('114', '  Leo Martin ', 'checking', -120.00, '08/02/2026', 'Chicago', 'ACTIVE', 'BR002'),
('115', 'Mia White', 'SAVINGS', 28000.00, '2026-02-09', 'New York', 'ACTIVE', 'BR001');

-- =============================================================================
-- INSERT RAW DATA: TRANSACTIONS
-- =============================================================================

INSERT INTO raw_transactions (transaction_id, customer_id, transaction_type, amount, transaction_time, merchant_category, status) VALUES
('T1001', 101, 'DEPOSIT', 5000.00, '2026-01-15 09:15:00', 'Branch', 'COMPLETED'),
('T1002', 101, 'WITHDRAWAL', 1200.00, '2026-01-16 10:30:00', 'ATM', 'COMPLETED'),
('T1003', 102, 'TRANSFER', 15000.00, '2026-01-16 11:00:00', 'Online Banking', 'COMPLETED'),
('T1004', 103, 'WITHDRAWAL', 800.00, '2026-01-16 14:20:00', 'ATM', 'COMPLETED'),
('T1005', 104, 'DEPOSIT', 2500.00, '2026-01-17 08:45:00', 'Branch', 'COMPLETED'),
('T1006', 106, 'WITHDRAWAL', 3000.00, '2026-01-19 16:10:00', 'Retail', 'COMPLETED'),
('T1007', 107, 'DEPOSIT', 10000.00, '2026-02-01 12:00:00', 'Branch', 'COMPLETED'),
('T1008', 109, 'WITHDRAWAL', 500.00, '2026-02-03 13:15:00', 'ATM', 'FAILED'),
('T1009', 101, 'WITHDRAWAL', 2000.00, '2026-02-04 15:30:00', 'Online Banking', 'COMPLETED'),
('T1010', 111, 'DEPOSIT', 4000.00, '2026-02-05 10:00:00', 'Branch', 'COMPLETED'),
('T1011', 112, 'TRANSFER', 25000.00, '2026-02-06 11:45:00', 'Wire Transfer', 'COMPLETED'),
('T1012', 112, 'WITHDRAWAL', 5000.00, '2026-02-06 14:00:00', 'ATM', 'COMPLETED'),
('T1013', 114, 'WITHDRAWAL', 300.00, '2026-02-08 17:30:00', 'ATM', 'COMPLETED'),
('T1014', 115, 'DEPOSIT', 8000.00, '2026-02-09 09:00:00', 'Branch', 'COMPLETED'),
('T1015', 102, 'WITHDRAWAL', 1200.00, '2026-02-10 10:15:00', 'Retail', 'COMPLETED'),
('T1016', 101, 'DEPOSIT', 3000.00, '2026-02-11 11:30:00', 'Branch', 'COMPLETED'),
('T1017', 103, 'DEPOSIT', 1000.00, '2026-02-12 12:00:00', 'Branch', 'COMPLETED'),
('T1018', 106, 'DEPOSIT', 2000.00, '2026-02-13 14:00:00', 'Branch', 'COMPLETED'),
('T1019', 107, 'WITHDRAWAL', 1500.00, '2026-02-14 15:45:00', 'ATM', 'FAILED'),
('T1020', 112, 'DEPOSIT', 10000.00, '2026-02-15 16:30:00', 'Branch', 'COMPLETED');
