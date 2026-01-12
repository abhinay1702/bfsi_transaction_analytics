{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='customer_id'
) }}

with src as (
    select *,
           row_number() over (
               partition by customer_id
               order by last_updated_ts desc
           ) as rn
    from {{ ref('stg_customers') }}
)

select
    customer_id,
    customer_name,
    email,
    phone,
    gender,
    dob,
    city,
    state,
    country,
    kyc_status,
    customer_segment,
    onboarding_channel,

    -- SCD-ready
    current_timestamp as effective_from_ts,
    '9999-12-31'      as effective_to_ts,
    'Y'               as is_current_flag,

    -- metadata
    '{{ invocation_id }}' as dw_process_id,
    current_timestamp     as dw_load_ts,
    'CRM_SYSTEM'          as dw_source_system,
    'ACTIVE'              as dw_record_status

from src
where rn = 1
