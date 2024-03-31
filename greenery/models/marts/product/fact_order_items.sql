{{
  config(
	materialized='table'
  )
}}

-- identifies what gets ordered most
select
  order_id,
  product_id,
  quantity qty
from {{ ref('int_order_items') }}
