{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='account_id'
) }}

with src as (
    select *,
           row_number() over (
               partition by account_id
               order by last_updated_ts desc
           ) as rn
    from {{ ref('stg_accounts') }}
)

select
    account_id,
    account_type,
    account_status,

    -- metadata
    '{{ invocation_id }}' as dw_process_id,
    current_timestamp     as dw_load_ts,
    'ACCOUNT_SYSTEM'      as dw_source_system,
    'ACTIVE'              as dw_record_status

from src
where rn = 1
