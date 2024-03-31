-- User repeat rate query:
with UserOrderCounts as
(
select user_id, count(*) ct
from stg_orders
group by user_id
)
select to_varchar(div0null(sum(iff(ct >= 2, 1, 0)), sum(ct)) * 100, '99.00"%"') "Repeat Rate"
from UserOrderCounts;

-- 27.42%

My added stg_* tests were mostly basic checks for not null and unique values.  Two checks for positive values.
I didn't add any tests for the int, dim, or fact models as I felt the stg tests were sufficient
No bad data was found other than the demos from week 1


Which products had their inventory change from week 1 to week 2? (All went down)
  Monstera
  Philodendron
  Pothos
  String of pearls
