{{
  config(
	materialized='table'
  )
}}

-- identifies how much users spend
select
  u.user_id,
  o.order_id,
  o.created_at,
  datediff(d, o.created_at, o.delivered_at) days_to_deliver, -- defaults to null if not delivered (yet)
  o.status,
  o.order_cost,
  o.shipping_cost,
  o.order_total
from {{ ref('stg_users') }} u
join {{ ref('stg_orders') }} o
  on u.user_id = o.user_id
