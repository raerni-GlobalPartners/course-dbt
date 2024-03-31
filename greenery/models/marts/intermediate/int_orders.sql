{{
  config(
	materialized='table'
  )
}}

-- minor tweak to include the promo discount if there is one
-- avoids needing to pull the promos into the int and later layers
select
  o.order_id,
  o.user_id,
  ifnull(p.discount, 0) promo_discount,
  o.address_id,
  o.created_at,
  o.order_cost,
  o.shipping_cost,
  o.order_total,
  o.tracking_id,
  o.shipping_service,
  o.estimated_delivery_at,
  o.delivered_at,
  o.status
from {{ ref('stg_orders') }} o
left join {{ ref('stg_promos') }} p
  on o.promo_id = p.promo_id
