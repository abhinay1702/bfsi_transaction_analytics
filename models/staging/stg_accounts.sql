{{ config(materialized='view') }}

select
    account_id,
    account_type,
    account_status,
    last_updated_ts
from {{ source('raw','raw_accounts') }}
