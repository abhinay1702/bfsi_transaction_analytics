{{ config(
    materialized='view'
) }}

select
    transaction_id,
    account_id,
    customer_id,
    transaction_amount,
    transaction_status as status,
    transaction_date,
    last_updated_ts,
from {{ source('raw','RAW_TRANSACTIONS') }}
