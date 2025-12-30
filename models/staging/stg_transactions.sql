select
  transaction_id,
  account_id,
  customer_id,
  transaction_date,
  transaction_amount,
  transaction_type,
  last_updated_ts
from {{ source('raw','RAW_TRANSACTIONS') }}
