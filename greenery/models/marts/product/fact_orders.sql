{{
  config(
	materialized='table'
  )
}}

-- identifies orders, a bit redundant as facts go
select
  order_id,
  user_id,
  promo_discount,
  address_id,
  created_at,
  order_cost,
  shipping_cost,
  order_total,
  tracking_id,
  shipping_service,
  estimated_delivery_at,
  delivered_at,
  status
from {{ ref('int_orders') }}
