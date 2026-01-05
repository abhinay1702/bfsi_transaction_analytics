select
  t.transaction_id,
  t.account_id,
  t.customer_id,
  t.transaction_date,
  t.transaction_amount,
  case
        when t.transaction_amount < 0 then 'REFUND'
        when t.status = 'FAILED' then 'FAILED'
        else 'SUCCESS'
    end as transaction_type,
  c.city,
  a.account_type,
  t.last_updated_ts
from {{ ref('stg_transactions') }} t
left join {{ ref('stg_customers') }} c
  on t.customer_id = c.customer_id
left join {{ ref('stg_accounts') }} a
  on t.account_id = a.account_id
