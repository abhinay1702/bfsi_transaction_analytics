{{ config(materialized='view') }}

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
    last_updated_ts
from {{ source('raw','raw_customers') }}
