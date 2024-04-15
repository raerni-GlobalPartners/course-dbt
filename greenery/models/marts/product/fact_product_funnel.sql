with
basic_funnel_info as
(
-- Basic info about a session and its views, adds, checkout, and shipments
select
  ie.session_id,
  max(ie.user_id) user_id,
  min(ie.created_at) start_time,
  datediff(minute, min(ie.created_at), max(ie.created_at)) duration,
  sum(iff(ie.event_type = 'page_view', 1, 0)) views,
  sum(iff(ie.event_type = 'add_to_cart', 1, 0)) adds,
  sum(iff(ie.event_type = 'checkout', 1, 0)) checkouts,
  sum(iff(ie.event_type = 'package_shipped', 1, 0)) shipments
from int_events ie
where 1=1
group by ie.session_id
),

order_funnel_info as
(
-- The items ordered have to be counted separately.  A given checkout event
--   creates an order but that order could include multiple products.  To
--   determine how views and adds result in product orders, this CTE needs
--   to be included
select ie.session_id, count(*) ordered_items
from int_events ie
join int_orders io
  on ie.order_id = io.order_id
join int_order_items ioi
  on io.order_id = ioi.order_id
where 1=1
  and ie.event_type = 'checkout'
group by ie.session_id
)

-- Now combine the basic session/funnel info with the item order info
select bfi.session_id, bfi.views, bfi.adds, bfi.checkouts, bfi.shipments, ifnull(ofi.ordered_items, 0) products_ordered
from basic_funnel_info bfi
left join order_funnel_info ofi
  on bfi.session_id = ofi.session_id
order by bfi.session_id