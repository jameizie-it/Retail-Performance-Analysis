/* PROJECT: Coffee Sales Q1 Performance Analysis
TOOLS: SQL Server (SSMS)
SKILLS: Data Wrangling, Views, Joins, Conditional Logic (CASE), Aggregations
GOAL: Transform raw order data into actionable regional and product-level insights.
*/

-- 1. DATA CLEANING: Create a baseline of valid, unique orders
go
create OR alter view cleaned_orders as
select distinct 
    OrderID, 
    OrderDate, 
    Region, 
    ProductID, 
    Quantity, 
    Sales
from coffee_orders
where Sales IS NOT NULL;
go

-- 2. JOIN TABLE: Combine orders with product
go
create OR alter view vw_join_table AS
select 
    o.OrderID,
    o.OrderDate,
    o.Region,
    o.ProductID,
    o.Quantity,
    o.Sales,
    p.ProductName,
    p.ProductCategory,
    p.UnitPrice
from cleaned_orders o
LEFT JOIN coffee_products p 
on o.ProductID = p.ProductID;
go

-- 3. ANALYSIS: Regional Revenue Segmentation
-- INSIGHT: Find which regions dominate high-value sales (> $100)
select Region, sum(sales) as Total_Revenue, count(OrderID) as Total_Orders,
case 
when sales > 100 then 'High-Value'
when sales between 50 and 99  then 'Mid-Value'
else 'Low-Value'
end as Order_Segment
from vw_join_table
group by Region,
case 
when sales > 100 then 'High-Value'
when sales between 50 and 99  then 'Mid-Value'
else 'Low-Value'
end
order by Total_Revenue desc;

-- 4. ANALYSIS: Product Category Popularity
-- INSIGHT: Evaluate which categories have the most growth
select ProductCategory, sum(sales) as Total_Revenue
from vw_join_table
group by ProductCategory
order by Total_Revenue desc;

select *
from vw_join_table;