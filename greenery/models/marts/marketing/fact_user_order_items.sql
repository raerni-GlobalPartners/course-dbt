{{
  config(
	materialized='table'
  )
}}

-- identifies what users buy and how long it takes to get delivered ... may affect decision to reorder and/or place new orders
select
  u.user_id,
  o.order_id,
  oi.product_id,
  o.created_at,
  datediff(d, o.created_at, o.delivered_at) days_to_deliver, -- defaults to null if not yet delivered
  o.status,
  oi.quantity order_item_qty
from {{ ref('stg_users') }} u
join {{ ref('stg_orders') }} o
  on u.user_id = o.user_id
join {{ ref('stg_order_items') }} oi
  on o.order_id = oi.order_id
join {{ ref('stg_products') }} p
  on oi.product_id = p.product_id
