{{
  config(
	materialized='table'
  )
}}

-- used to identify products which are viewed but not ordered ... abandonded carts
with product_views_adds as
(
select
  e.session_id,
  e.created_at,
  e.user_id,
  e.event_type,
  e.product_id
from {{ ref('int_events') }} e
where e.event_type in ('add_to_cart', 'page_view')
),
product_views as
(
select *
from product_views_adds
where event_type = 'page_view'
),
product_adds as
(
select *
from product_views_adds
where event_type = 'add_to_cart'
)
select
  pv.session_id,
  pv.product_id,
  pv.user_id,
  min(pv.created_at) session_started_at,
  count(*) product_viewed,
  sum(iff(pa.product_id is not null, 1, 0)) product_added
from product_views pv
left join product_adds pa
  on pv.session_id = pa.session_id
	and pv.product_id = pa.product_id
group by
  pv.session_id,
  pv.product_id,
  pv.user_id
