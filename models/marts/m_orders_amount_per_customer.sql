{{ config(
    materialized='table'
) }}


with
    amount_orders as (
        select
            hc.customer_pk,
            hc.customer_key,
            sc.first_name,
            sc.last_name,
            sum(case when so.order_pk is not null
                     then 1
                     else 0
                 end) as orders_amount_completed
        from
            {{ ref('hub_customer') }} hc
            left join {{ ref('link_customer_order') }} l on hc.customer_pk = l.customer_pk
            left join {{ ref('sat_customer') }} sc on sc.customer_pk = hc.customer_pk
            left join {{ ref('hub_order') }} ho on ho.order_pk = l.order_pk
            left join {{ ref('sat_order') }} so on (
                so.order_pk = ho.order_pk
                and so.status in ('completed')
            )
        group by
            1,2,3,4
        order by
            5 desc
    )
select
    *
from
    amount_orders