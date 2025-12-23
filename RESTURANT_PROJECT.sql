USE Restaurant_Order
SELECT * FROM MENU_ITEMS
SELECT * FROM ORDER_DETAILS

-- Checking Null Values
select 
sum(case when order_id is null then 1 else 0 end) as order_id_nulls,
sum(case when order_date is null then 1 else 0 end) as order_date_nulls,
sum(case when order_time is null then 1 else 0 end) as order_time_nulls,
sum(case when item_id is null then 1 else 0 end) as item_id_null
from order_details

--item id have 137 null values
--other column don't have any null values

alter table ORDER_DETAILS
alter column item_id int


-- KPI'S

-- Total Orders
select count(distinct(order_id)) as Total_Order from order_details

-- Total Revenue
select round(sum(m.price),2) as total_amount from menu_items m
inner join order_details o on m.menu_item_id = o.item_id

-- Average Order Value
select round(avg(Total_spend),2) as Avg_Order_Value from (select sum(m.price) as Total_spend from menu_items m
inner join order_details o on m.menu_item_id = o.item_id
group by order_id) t

-- Highest Order Value
select round(max(Total),2) as Highest_Order from (select sum(m.price) as Total from menu_items m
inner join order_details o on m.menu_item_id = o.item_id
group by order_id)t

-- Lowest Order Value
select round(min(Total),2) as Lowest_Order from (select sum(m.price) as Total from menu_items m
inner join order_details o on m.menu_item_id = o.item_id
group by order_id)t


-- Granular Requirements

-- Menu Item Performance Analysis

-- Item Wise Quantity Sold and Revenue

select m.item_name, count(o.item_id) as Quantity_Sold,
round(sum(m.price),2) as Total_Revenue from order_details o
inner join menu_items m on m.menu_item_id = o.item_id
group by o.item_id,m.item_name
order by Total_Revenue desc

-- Top 5 High Performing Items

select top 5 m.item_name, count(o.item_id) as Quantity_Sold,
round(sum(m.price),2) as Total_Revenue from order_details o
inner join menu_items m on m.menu_item_id = o.item_id
WHERE o.item_id IS NOT NULL
group by o.item_id,m.item_name
order by Total_Revenue desc

-- Low Performing Items

select top 2 m.item_name, count(o.item_id) as Quantity_Sold,
round(sum(m.price),2) as Total_Revenue from order_details o
inner join menu_items m on m.menu_item_id = o.item_id
group by o.item_id,m.item_name
order by Total_Revenue asc


-- Category Performance Analysis

-- Total Orders, Revenue and Average_order_Price per Category

select m.category, count(o.item_id) as Total_Order,
round(sum(m.price),2) as Revenue,
round(avg(price),2) as Average_Order_Price from menu_items m
inner join order_details o on m.menu_item_id = o.item_id
group by m.category
order by Revenue desc


-- Time-Based Order Analysis

-- top 5 peak hour
select top 5 datepart(hour,order_time) as Peak_Hour,
count(distinct(order_id)) as Total_Order from order_details
group by datepart(hour,order_time)
order by Total_Order desc

-- lowest peak hour
select top 2 datepart(hour,order_time) as Lowest_Order_Hour,
count(distinct(order_id)) as Total_Order from order_details
group by datepart(hour,order_time)
order by Total_Order asc

-- Customer Spending Analysis
-- Average Spend per Order
select round(avg(Total_spend),2) as Avg_Order_Value from (select sum(m.price) as Total_spend from menu_items m
inner join order_details o on m.menu_item_id = o.item_id
group by order_id) t

-- High_Value_Order_Frequence
select round(count(case when total_Amount >= 100 then 1 end) * 100.0 / count(*),2) as High_Value_Order_Frequency_Per from 
(select sum(m.price) as total_Amount from menu_items m
inner join order_details o on m.menu_item_id = o.item_id
group by o.order_id)t

