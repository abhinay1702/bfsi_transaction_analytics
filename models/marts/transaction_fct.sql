{{ config(
  materialized='incremental',
  unique_key='transaction_id',
  cluster_by=['transaction_date','account_id']
) }}

select
  transaction_id,
  customer_id,
  account_id,
  transaction_date,
  transaction_amount,
  transaction_type,
  last_updated_ts
from {{ ref('int_transactions_enriched') }}

{% if is_incremental() %}
where last_updated_ts >
  (select max(last_updated_ts) from {{ this }})
{% endif %}
