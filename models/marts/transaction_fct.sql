{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='transaction_id',
     cluster_by=['last_updated_ts']
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


with src as (

    select
        t.*,
        row_number() over (
            partition by transaction_id
            order by last_updated_ts desc
        ) as rn
    from {{ ref('int_transactions_enriched') }} t
)

select
    transaction_id,
    account_id,
    customer_id,
    transaction_amount,
    transaction_type,
    city,
    transaction_date,
    last_updated_ts,

    '{{ v_process_id }}' as dw_process_id,
    current_timestamp as dw_load_ts

from src
where rn = 1

{% if is_incremental() %}
  and last_updated_ts > '{{ v_lwm }}'
{% endif %}
