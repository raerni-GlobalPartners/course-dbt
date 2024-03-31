{{
  config(
	materialized='table'
  )
}}

-- select * really
select
  order_id,
  product_id,
  quantity
from {{ ref('stg_order_items') }}
