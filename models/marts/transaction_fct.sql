{% set job_name = 'transaction_fct' %}
{% set wm = process_batch_control(job_name) %}
{% set lwm = wm[0] %}
{% set hwm = wm[1] %}
{% set process_id = wm[2] %}


{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='transaction_id',
    cluster_by=['transaction_date'],
     post_hook="{{ batch_success('transaction_fct') }}"
) }}

with src as (
    select *,
           row_number() over (
               partition by transaction_id
               order by last_updated_ts desc
           ) as rn
    from {{ ref('int_transactions_enriched') }}

    {% if is_incremental() %}
      where last_updated_ts > '{{ v_lwm }}'
        and last_updated_ts <= '{{ v_hwm }}'
    {% endif %}
)

select
    transaction_id,
    account_id,
    customer_id,
    transaction_date,
    transaction_amount,
    transaction_type,
    transaction_status,
    payment_method,
    transaction_channel,
    currency_code,
    merchant_category,
    account_type,
    city,
    state,
    created_ts,
    last_updated_ts,

    -- metadata
    '{{ invocation_id }}' as dw_process_id,
    current_timestamp     as dw_load_ts,
    'TXN_APP'             as dw_source_system,
    'ACTIVE'              as dw_record_status

from src
where rn = 1

{% if is_incremental() %}
  and last_updated_ts >
      (select coalesce(max(last_updated_ts),'1900-01-01') from {{ this }})
{% endif %}
