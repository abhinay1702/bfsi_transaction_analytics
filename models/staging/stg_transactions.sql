{{ config(materialized='view') }}

select
    transaction_id,
    account_id,
    customer_id,
    transaction_date,
    transaction_amount,
    transaction_status,
    payment_method,
    transaction_channel,
    currency_code,
    merchant_category,
    created_ts,
    last_updated_ts
from {{ source('raw','raw_transactions') }}
