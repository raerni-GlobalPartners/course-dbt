-- This is a poor fact as it answers just one question.  Rather than creating a model (as requested),
--   I'd prefer to just query the underlying int or even stg tables!
with
sessions_with_checkout as
(
{{ select_distinct_sessions('int_events', 'checkout') }}
),

distinct_sessions as
(
select distinct session_id
from int_events
)

select
  count(distinct swc.session_id) checkout_session_ct,
  count(distinct ds.session_id) all_session_ct
from sessions_with_checkout swc
cross join distinct_sessions ds

