import pandas as pd
import numpy as np

def clean_banking_data():
    print("--- Step 1: Loading Raw Data ---")
    df_cust = pd.read_csv('../data/raw_customers.csv')
    df_txn = pd.read_csv('../data/raw_transactions.csv')
    
    print(f"Raw Customer Count: {len(df_cust)}")
    
    # 1. Deduplication
    df_cust = df_cust.drop_duplicates(subset=['id'], keep='first').copy()
    print(f"Post-Deduplication Customer Count: {len(df_cust)}")
    
    # 2. String Cleaning & Casing Normalization
    df_cust['customer_name'] = df_cust['customer_name'].str.strip()
    df_cust['account_type'] = df_cust['account_type'].str.strip().str.upper()
    df_cust['city'] = df_cust['city'].str.strip().str.upper()
    df_cust['status'] = df_cust['status'].str.strip().str.upper()
    
    # 3. Handle Negative Values & Impute Missing Balances
    df_cust['balance'] = np.where(df_cust['balance'] < 0, 0, df_cust['balance'])
    df_cust['balance'] = df_cust.groupby('account_type')['balance'].transform(lambda x: x.fillna(x.mean()))
    
    # 4. Parsing Heterogeneous Date Formats
    df_cust['transaction_date'] = pd.to_datetime(df_cust['transaction_date'], format='mixed')
    
    print("\n--- Cleaned Customer Sample ---")
    print(df_cust.head(10))
    
    # Export Clean Datasets
    df_cust.to_csv('../data/clean_customers.csv', index=False)
    print("\nSaved clean customer dataset to '../data/clean_customers.csv'")

if __name__ == '__main__':
    clean_banking_data()
