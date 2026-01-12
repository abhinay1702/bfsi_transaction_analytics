{{ config(materialized='table') }}

with date_spine as (
    select
        dateadd(
            day,
            seq4(),
            '2020-01-01'::date
        ) as d
    from table(generator(rowcount => 3650))
)

select
    d as date_key,
    year(d) as year,
    month(d) as month,
    day(d) as day,
    dayofweek(d) as day_of_week,
    week(d) as week_of_year,
    quarter(d) as quarter,
    dayname(d) as day_name,
    monthname(d) as month_name,
    case when dayofweek(d) in (6,7) then 'Y' else 'N' end as is_weekend,
    current_timestamp as dw_load_ts
from date_spine
