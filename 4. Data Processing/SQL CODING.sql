-------------------------------------------------
--- Retrieving rows and columns of the table
-------------------------------------------------
SELECT *
from `workspace`.`default`.`bright_coffeeshop_sales`
LIMIT 100;


-------------------------------------------------
-- 1. Checking the Date Range
-------------------------------------------------
-- They started collecting the data 2023-01-01
SELECT MIN(transaction_date) AS min_date 
from `workspace`.`default`.`bright_coffeeshop_sales`;

-- the duration of the data is 6 months

--  They last collected the data 2023-06-30
SELECT MAX(transaction_date) AS latest_date 
from `workspace`.`default`.`bright_coffeeshop_sales`;


-------------------------------------------------
-- 2. Checking the names of the different stores
------------------------------------------------
-- we have 3 stores and their names are Lower Manhattan, Hell's Kitchen, Astoria
SELECT DISTINCT store_location
from `workspace`.`default`.`bright_coffeeshop_sales`;

SELECT COUNT(DISTINCT store_id) AS number_of_stores
from `workspace`.`default`.`bright_coffeeshop_sales`;


-------------------------------------------------
-- 3. Checking products sold at our stores 
------------------------------------------------
SELECT DISTINCT product_category
from `workspace`.`default`.`bright_coffeeshop_sales`;

SELECT DISTINCT product_detail
from `workspace`.`default`.`bright_coffeeshop_sales`;

SELECT DISTINCT product_type
from `workspace`.`default`.`bright_coffeeshop_sales`;

SELECT DISTINCT product_category AS category,
                MAX(unit_price) As expensive_price
from `workspace`.`default`.`bright_coffeeshop_sales`;
group by product_category;

-------------------------------------------------
-- 1. Checking product prices
------------------------------------------------
SELECT MIN(unit_price) As cheapest_price
from `workspace`.`default`.`bright_coffeeshop_sales`;

SELECT MAX(unit_price) As expensive_price
from `workspace`.`default`.`bright_coffeeshop_sales`;

SELECT store_name, revenue
from `workspace`.`default`.`bright_coffeeshop_sales`;


------------------------------------------------
SELECT 
COUNT(*) AS number_of_rows,
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      COUNT(DISTINCT product_id) AS number_of_products,
      COUNT(DISTINCT store_id) AS number_of_stores
from `workspace`.`default`.`bright_coffeeshop_sales`;


------------------------------------------------
select
      transaction_date as purchase_date,
      Dayname(transaction_date) as day_name,
      Monthname(transaction_date) as month_name,
      dayofmonth(transaction_date) as day_of_month,

      case
          when dayname(transaction_date) in ('Sun', 'Sat') then 'Weekend' 
          else 'Weekday'
          end as day_classification,   
      case
          when date_format(transaction_time, 'HH:mm:ss') between '00:00:00' and '11:59:59' then '0.1 Morning'
          when date_format(transaction_time, 'HH:mm:ss') between '12:00:00' and '16:59:59' then '0.2 Afternoon'
          when date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' then '0.3 Evening'
          end as time_buckets,

---Counts of IDs
      count(*) as number_of_sales,
      count(distinct product_id) as number_of_products,
      count(distinct store_id) as number_stores,
---Revenue
  sum(transaction_qty * cast(replace(unit_price, ',', '.') as decimal(10,2)))
--Categorical Columns
      store_location,
      product_category,
      product_detail

from `workspace`.`default`.`bright_coffeeshop_sales`
group by transaction_date, 
        dayname(transaction_date), 
        monthname(transaction_date),
        dayofmonth(transaction_date), 
  case
          when dayname(transaction_date) in ('Sun', 'Sat') then 'Weekend' 
          else 'Weekday'
          end,  
      case
          when date_format(transaction_time, 'HH:mm:ss') between '00:00:00' and '11:59:59' then '0.1 Morning'
          when date_format(transaction_time, 'HH:mm:ss') between '12:00:00' and '16:59:59' then '0.2 Afternoon'
          when date_format(transaction_time, 'HH:mm:ss') >= '17:00:00' then '0.3 Evening'
          end,       
        store_location, 
        product_category,
        product_detail;
