{{ config(materialized='table') }}

select
    t.transaction_id,
    t.account_id,
    t.customer_id,
    t.transaction_date,
    t.transaction_amount,

    case
        when t.transaction_amount < 0 then 'REFUND'
        when t.transaction_status = 'FAILED' then 'FAILED'
        else 'SUCCESS'
    end as transaction_type,

    t.transaction_status,
    t.payment_method,
    t.transaction_channel,
    t.currency_code,
    t.merchant_category,

    a.account_type,
    c.city,
    c.state,

    t.created_ts,
    t.last_updated_ts

from {{ ref('stg_transactions') }} t
left join {{ ref('stg_accounts') }} a
    on t.account_id = a.account_id
left join {{ ref('stg_customers') }} c
    on t.customer_id = c.customer_id
