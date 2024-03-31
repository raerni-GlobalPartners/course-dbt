{{
  config(
	materialized='table'
  )
}}

-- select * really
select
  product_id,
  name,
  price,
  inventory
from {{ ref('stg_products') }}
