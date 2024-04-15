**Part 1:  Snapshots**

**Which products inventory changed for week 4:**
select dp.product_name, ps.dbt_valid_from, ps.dbt_valid_to
from products_snapshot ps
join dim_products dp
  on ps.product_id = dp.product_id
where 1=1
  and ps.dbt_valid_to > '4/14/2024'
order by dp.product_name;

**Results:**
Bamboo
Monstera
Philodendron
Pothos
String of pearls
ZZ Plant

**Which products had the most fluctuations?  A std dev shows variations but variations in larger numbers have larger stddev values.  I like to divide the stddev by the avg value to get a relative variation:**
with

product_changes as
(
select dp.product_name, cast(stddev(ps.inventory) / avg(ps.inventory) as decimal(5,2)) relative_stddev
from products_snapshot ps
join dim_products dp
  on ps.product_id = dp.product_id
where 1=1
group by dp.product_name
)

-- Only interested in the products with SOME variation
select *
from product_changes
where relative_stddev is not null
order by relative_stddev;

**Answer:  String of pearls had the largest relative variation**
PRODUCT_NAME	    RELATIVE_STDDEV
Monstera	        0.36
ZZ Plant	        0.41
Bamboo	            0.41
Philodendron	    0.50
Pothos	            0.82
String of pearls	1.34


**Did any items go out of stock?**
select dp.product_name, ps.* --ps.dbt_valid_from, ps.dbt_valid_to
from products_snapshot ps
join dim_products dp
  on ps.product_id = dp.product_id
where 1=1
  and ps.inventory = 0
order by dp.product_name;

**Answer: Two products**
PRODUCT_NAME	    INVENTORY	DBT_VALID_FROM	        DBT_VALID_TO
Pothos	            0	        2024-04-08 02:09:29.015	2024-04-14 23:39:30.986
String of pearls	0	        2024-04-08 02:09:29.015	2024-04-14 23:39:30.986


**Part 2**
Created a new fact model, fact_product_funnel.  The following query answers the specified questions.  The checkouts count is misleading in that multiple products can be included in the checkout.  The fact table I created makes use of the orders/order_items tables to identify the products that were ordered as a result of the checkout event.  I feel that's a relevant measure of the funnel in addition to the checkouts count.
The Shipments measure was included as well for future exploration!

VIEWS	ADDS	CHECKOUTS	SHIPMENTS	PRODUCTS_ORDERED
1871	986	    361	        335	        862

Created an exposures.yml file to reference the new fact table


**Part 3A**
Our org is starting to use dbt in a very big way.  While the course has highlighted features of dbt, I need more work with it but also with Snowflake (unique SQL syntax variations compared to Oracle or SQL Server), github, and even markdown language

**Part 3B**
We will be using Dagster for orchestration.  So yet another took to learn more about.