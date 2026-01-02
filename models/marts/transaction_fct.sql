{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='transaction_id'
) }}

{%- set v_dbt_job_name = 'transaction_fct' -%}

--Batch control
{%- set v_watermark = process_batch_control(v_dbt_job_name) -%}
{%- set v_lwm = v_watermark[0] -%}
{%- set v_hwm = v_watermark[1] -%}
{%- set v_process_id = v_watermark[2] -%}

--Success update SQL
{% set v_sql_upd_success_batch %}
    call {{ target.database }}.CONTROL.batch_success_proc('transaction_fct')
{% endset %}

{{ config(post_hook=v_sql_upd_success_batch) }}


--Fact load
select
    t.transaction_id,
    t.account_id,
    t.customer_id,
    t.transaction_amount,
    t.transaction_type,
    t.transaction_date,
    t.last_updated_ts,

    -- batch & audit columns
    '{{ process_id }}' as dw_process_id,
    current_timestamp as dw_load_ts

from {{ ref('int_transactions_enriched') }} t

{% if is_incremental() %}
where t.last_updated_ts > '{{ v_lwm }}'
  and t.last_updated_ts <= '{{ v_hwm }}'
{% endif %}
