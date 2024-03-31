{{
  config(
	materialized='table'
  )
}}

select
  user_id,
  first_name,
  last_name,
  email,
  phone_number,
  updated_at,
  datediff(d, created_at, updated_at) "days_as user",
  address_id as user_address_id
from {{ ref('int_users') }}
