-- How many users do we have?
select count(*) NumberOfUsers
from stg_users;
-- Answer:  130 users


-- On average, how many orders do we receive per hour?
with OrdersPerHour as
(
Select day(CREATED_AT), hour(CREATED_AT), count(*) Ct
from stg_orders
group by day(CREATED_AT), hour(CREATED_AT)
order by day(CREATED_AT), hour(CREATED_AT)
)
select avg(Ct) AvgOrdersPerHour
from OrdersPerHour;
-- Answer:  7.52 orders per hour


-- On average, how long does an order take from being placed to being delivered?
-- Interesting that all orders are delivered at the same hour:minute:second as they are created but on a different day!
-- Experimented with formatting the numeric output
with DeliveryMinutes as
(
select datediff(mi, created_at, delivered_at) Minutes
from stg_orders
where delivered_at is not null
),
-- Determine the average number of minutes
AverageMinutes as
(
select avg(DeliveryMinutes.Minutes) AvgDeliveryMinutes
from DeliveryMinutes
)
-- Now for fun, format the delivery time as days, hours, and (fractional) minutes
select AvgDeliveryMinutes Minutes, concat(trunc(AvgDeliveryMinutes / 1440), ' ', to_char(trunc(AvgDeliveryMinutes % 1440 / 60), 'FM00'), ':', to_char(((AvgDeliveryMinutes % 1440) % 60), 'FM00.00')) DaysHoursMinutes
from AverageMinutes;
-- Answer:  3 days, 21 hours, 24.20 minutes


-- How many users have only made one purchase? Two purchases? Three+ purchases?
with UserOrderCounts as
(
select o.user_id, count(o.order_id) UserOrderCount
from stg_orders o
group by o.user_id
)
-- Basic query to check the users by order count, one query at a time
--select count(*) 
--from UserOrderCounts uoc
--where uoc.UserOrderCount = 1 -- ... or = 2 ... or >= 3
-- Version to answer all three questions at one
select sum(iff(uoc.UserOrderCount = 1, 1, 0)) OneOrderUsers,  sum(iff(uoc.UserOrderCount = 2, 1, 0)) TwoOrderUsers,  sum(iff(uoc.UserOrderCount >= 3, 1, 0)) ThreeOrMoreOrderUsers
from UserOrderCounts uoc;
-- Answers:  25 users place one order, 28 placed two orders, 71 placed three or more orders


-- On average, how many unique sessions do we have per hour?
-- This query and the answer were corrected after the week 1 project was submitted and other project reviewed
-- I had been counting the number of events per hour, not sessions per hour
with SessionsPerHour as
(
Select day(e.CREATED_AT), hour(e.CREATED_AT), count(distinct session_id) Sessions
from stg_events e
group by day(e.CREATED_AT), hour(e.CREATED_AT)
order by day(e.CREATED_AT), hour(e.CREATED_AT)
)
select avg(Sessions) AvgSessionsPerHour
from SessionsPerHour;
-- Answer:  16.33 sessions per hours
