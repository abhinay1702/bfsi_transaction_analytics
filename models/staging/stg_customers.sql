select
  customer_id,
  customer_name,
  pan_number,
  city,
  last_updated_ts
from {{ source('raw','RAW_CUSTOMERS') }}
