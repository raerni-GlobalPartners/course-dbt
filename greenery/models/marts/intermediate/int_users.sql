{{
  config(
	materialized='table'
  )
}}

-- select * really
select
  user_id,
  first_name,
  last_name,
  email,
  phone_number,
  created_at,
  updated_at,
  address_id
from {{ ref('stg_users') }}
