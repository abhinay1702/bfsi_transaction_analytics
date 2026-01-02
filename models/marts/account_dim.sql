{{ config(materialized='table') }}

select
    account_id,
    account_type,
    account_status
from {{ ref('stg_accounts') }}
