-- This isn't a great fact either as it also answers a specific question
--   I'd prefer to just query the underlying tables
with
sessions_by_product as
-- Number of sessions that looked at each product
(
select product_id, count(distinct session_id) product_distinct_session_ct
from int_events
group by 1
order by 1
),

sessions_with_product_added_to_cart as
-- Identify sessions that added the product to the cart at least once
(
select distinct product_id, session_id
from int_events
where event_type = 'add_to_cart'
),

sessions_with_checkout as
(
-- Identify sessions that had a checkout event
--   Checking in case a product was added to the cart but then the cart was abandoned
--   Such sessions should be ignored
{{ select_distinct_sessions('int_events', 'checkout') }}
),

checkout_sessions_by_product as
-- Combine the prior two CTEs to count the number of sessions that had a checkout broken down by product that was added to the cart
(
select swpatc.product_id, count(distinct swc.session_id) checkout_session_ct
from sessions_with_checkout swc
join sessions_with_product_added_to_cart swpatc
  on swc.session_id = swpatc.session_id
group by swpatc.product_id
)

select csbp.product_id, csbp.checkout_session_ct, sbp.product_distinct_session_ct--, csbp.checkout_session_ct / sbp.product_session_ct product_conversion_rate
from checkout_sessions_by_product csbp
join sessions_by_product sbp
  on csbp.product_id = sbp.product_id
order by csbp.product_id
