Part 1:
-- The overall converstion rate is defined by:
select checkout_session_ct / all_session_ct overall_conversion_rate
from fact_session_checkouts
Answer:  0.624567

-- The product conversion rate is defined by:
select dp.product_name, fpc.checkout_session_ct / fpc.product_distinct_session_ct product_conversion_rate
from fact_product_checkouts fpc
join dim_products dp
  on fpc.product_id = dp.product_id
order by dp.product_name

Answers:
PRODUCT_NAME	PRODUCT_CONVERSION_RATE
Alocasia Polly	0.411765
Aloe Vera	0.492308
Angel Wings Begonia	0.393443
Arrow Head	0.555556
Bamboo	0.537313
Bird of Paradise	0.45
Birds Nest Fern	0.423077
Boston Fern	0.412698
Cactus	0.545455
Calathea Makoyana	0.509434
Devil's Ivy	0.488889
Dragon Tree	0.467742
Ficus	0.426471
Fiddle Leaf Fig	0.5
Jade Plant	0.478261
Majesty Palm	0.492537
Money Tree	0.464286
Monstera	0.510204
Orchid	0.453333
Peace Lily	0.409091
Philodendron	0.483871
Pilea Peperomioides	0.474576
Pink Anthurium	0.418919
Ponytail Palm	0.4
Pothos	0.344262
Rubber Plant	0.518519
Snake Plant	0.39726
Spider Plant	0.474576
String of pearls	0.609375
ZZ Plant	0.539683

The new fact models I created for these are very poor as they can only answer single questions!


Part 2:
Created a "select_distinct_sessions" to count distince sessions based on an event_type.
Again, limited usage
Used the macro in the fact_session_checkouts and fact_product_checkouts models
Documented the macro is macros/local_macros.yml

Per the instructions, added the "grant" macro


Part 3:
Created the post-hook in the dbt_project.yml
Verified by checking the Snowflake Query History that it was applied to tables after "dbt run"


Part 4:
Installed dbt-labs/dbt_utils and calogica/dbt_expectations
Tried to add an "expression_is_true" test to the stg_orders table to ensure delivered_at (when not null) was later than created_at but got syntax errors I couldn't resolve for now.  Will investigate further


Part 5:
Generated an updated DAG.


Part 6:
Ran "dbt snapshot" and then ran the following query in Snowflake:
with
updated_products as
(
select distinct product_id
from products_snapshot
where dbt_valid_to is not null
)

select name, inventory, dbt_valid_from, dbt_valid_to
from updated_products up
join products_snapshot ps
  on up.product_id = ps.product_id
order by name, dbt_valid_from


This returned 16 rows for 6 unique products:
NAME	INVENTORY	DBT_VALID_FROM	DBT_VALID_TO
Bamboo	56	2024-03-24 13:45:39.190	2024-04-08 02:09:29.015
**Bamboo	44	2024-04-08** 02:09:29.015	null
Monstera	77	2024-03-24 13:45:39.190	2024-03-31 23:02:37.091
Monstera	64	2024-03-31 23:02:37.091	2024-04-08 02:09:29.015
**Monstera	50	2024-04-08** 02:09:29.015	null
Philodendron	51	2024-03-24 13:45:39.190	2024-03-31 23:02:37.091
Philodendron	25	2024-03-31 23:02:37.091	2024-04-08 02:09:29.015
**Philodendron	15	2024-04-08** 02:09:29.015	null
Pothos	40	2024-03-24 13:45:39.190	2024-03-31 23:02:37.091
Pothos	20	2024-03-31 23:02:37.091	2024-04-08 02:09:29.015
**Pothos	0	2024-04-08** 02:09:29.015	null
String of pearls	58	2024-03-24 13:45:39.190	2024-03-31 23:02:37.091
String of pearls	10	2024-03-31 23:02:37.091	2024-04-08 02:09:29.015
**String of pearls	0	2024-04-08** 02:09:29.015	null
ZZ Plant	89	2024-03-24 13:45:39.190	2024-04-08 02:09:29.015
**ZZ Plant	53	2024-04-08** 02:09:29.015	null