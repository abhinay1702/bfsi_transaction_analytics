{{ config(materialized='table') }}

select
    customer_id,
    customer_name,
    city,
    pan_number
from {{ ref('stg_customers') }}
