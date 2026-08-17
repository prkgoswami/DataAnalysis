import pandas as pd
import numpy as np

def run_banking_analysis():
    # Load clean data
    df_cust = pd.read_csv('../data/clean_customers.csv')
    df_txn = pd.read_csv('../data/raw_transactions.csv')
    
    # Merge Customer & Transactions
    df_merged = pd.merge(df_txn, df_cust, left_on='customer_id', right_on='id', how='inner')
    
    print("--- 1. Customer Segmentation by City ---")
    bins = [0, 5000, 20000, np.inf]
    labels = ['Low Value', 'Mid Value', 'High Value']
    df_cust['segment'] = pd.cut(df_cust['balance'], bins=bins, labels=labels, right=False)
    
    segment_summary = df_cust.groupby(['city', 'segment'])['balance'].agg(['count', 'mean']).reset_index()
    print(segment_summary)
    
    print("\n--- 2. Customer Transaction Rankings ---")
    df_completed = df_merged[df_merged['status_x'] == 'COMPLETED'].copy()
    df_completed['amount_rank'] = df_completed.groupby('customer_id')['amount'].rank(method='dense', ascending=False)
    print(df_completed[['customer_id', 'transaction_id', 'amount', 'amount_rank']].head(10))

if __name__ == '__main__':
    run_banking_analysis()
