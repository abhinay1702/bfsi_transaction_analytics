select distinct
    transaction_date as date,
    year(transaction_date) as year,
    month(transaction_date) as month,
    day(transaction_date) as day
from {{ ref('stg_transactions') }}
