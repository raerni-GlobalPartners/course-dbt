{{
  config(
	materialized='table'
  )
}}

select
  product_id,
  name as product_name,
  price as product_price,
  inventory as qty_on_hand
from {{ ref('int_products') }}
