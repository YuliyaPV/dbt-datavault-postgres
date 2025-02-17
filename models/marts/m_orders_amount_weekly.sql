{{ config(
    materialized='table'
) }}


with orders as (
select date_trunc('week',so.order_date)::date as week_start,
       so.status as order_status, 
       count(*)
from {{ ref('hub_order') }} as ho
left join {{ ref('sat_order') }} as so
on ho.order_pk = so.order_pk
group by 1,2
order by date_trunc('week',so.order_date)::date
)

select * from orders
