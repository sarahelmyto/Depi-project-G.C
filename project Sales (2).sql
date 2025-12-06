---1. General Sales Overview

--1. What is the total sales revenue for the selected period?
SELECT YEAR(Order_Date) AS Year,
       SUM(Sales) AS TotalSalesRevenue
FROM [sales Detailes] 
JOIN [Order] 
ON [sales Detailes].Order_ID = [Order].Order_ID
WHERE YEAR(Order_Date) IN (2015, 2016, 2017, 2018)
GROUP BY YEAR(Order_Date)
ORDER BY Year;

--2. How many total orders have been placed?
SELECT COUNT(*) AS NumOrders
FROM [Order];

--3. How many unique customers made purchases?
SELECT COUNT(*) AS NumCustomers
FROM customer;

--4. Which product category has generated the highest sales?
SELECT p.Category, SUM(s.Sales) AS TotalSales
FROM [sales Detailes] s
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY TotalSales DESC;

--5. Which region (country/state) recorded the most orders?
SELECT Region, COUNT(*) AS TotalOrders
FROM [Order]
GROUP BY Country, Region
ORDER BY TotalOrders DESC;

--6. What is the average sales amount per order?
SELECT TOP 10 o.Order_ID, AVG(s.Sales) AS AvgSalesPerOrder
FROM [sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
GROUP BY o.Order_ID
ORDER BY AvgSalesPerOrder DESC;

---2. Customer Insights

--1. Who are the top 10 customers by total sales?

SELECT TOP 10 c.Customer_Name,C.Customer_ID ,SUM(s.Sales) AS TotalSales
FROM [sales Detailes] s 
JOIN [Order] o ON s.Order_ID = o.Order_ID
JOIN [Customer] c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name,C.Customer_ID
ORDER BY TotalSales DESC;

--2. How many customers placed more than 12 order?

SELECT c.Customer_Name, COUNT(o.Order_ID) AS NumOrders
FROM [Order] o
JOIN [Customer] c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
HAVING COUNT(o.Order_ID) > 12;

--3. How many the num. order for top 10 customer ?

SELECT TOP 10 c.Customer_ID, c.Customer_Name, COUNT(o.Order_ID) AS NumOrders, SUM(s.Sales) AS TotalSales
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
JOIN [Customer] c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY TotalSales DESC;

--4. Which region has the highest number of active customers?
SELECT o.Region, COUNT(DISTINCT o.Customer_ID) AS ActiveCustomers
FROM [Order] o
GROUP BY o.Region
ORDER BY ActiveCustomers DESC;


--5. What percentage of total sales comes from returning customers?

SELECT 
    (SELECT SUM(s.Sales)
     FROM [Sales Detailes] s
     JOIN [Order] o ON s.Order_ID = o.Order_ID
     WHERE o.Customer_ID IN (
         SELECT Customer_ID
         FROM [Order]
         GROUP BY Customer_ID
         HAVING COUNT(Order_ID) > 1
     )) 
    / SUM(s.Sales) * 100 AS ReturningCustomerSalesPercentage
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID;

--6.Which customers have placed only one order?

SELECT o.Customer_ID, c.Customer_Name, COUNT(o.Order_ID) AS NumOrders
FROM [Order] o
JOIN [Customer] c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Customer_Name
HAVING COUNT(o.Order_ID) = 1;

---3. Product & Category Insights

--1.Which products are the top 10 bestsellers overall?
SELECT TOP 10 p.Product_Name, COUNT(s.Order_ID) AS NumOrders
FROM [sales Detailes] s
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY NumOrders DESC;

--2. Which sub-category contributes the most to total sales?
SELECT TOP 1 p.Sub_Category, SUM(s.Sales) AS TotalSales
FROM [Sales Detailes] s
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Sub_Category
ORDER BY TotalSales DESC;

--3. What is the average sales per product category?
SELECT p.Category, AVG(s.Sales) AS AvgSalesPerCategory
FROM [Sales Detailes] s
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY AvgSalesPerCategory DESC;

--4. What is the number of orders per category?
SELECT p.Category, COUNT(o.Order_ID) AS NumOrders
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY NumOrders DESC;

--5.What is the total sales per sup category over the quarterS?
SELECT p.Sub_Category,
       SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 1 THEN s.Sales ELSE 0 END) AS Qtr1_Sales,
       SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 2 THEN s.Sales ELSE 0 END) AS Qtr2_Sales,
       SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 3 THEN s.Sales ELSE 0 END) AS Qtr3_Sales,
       SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 4 THEN s.Sales ELSE 0 END) AS Qtr4_Sales
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Sub_Category
ORDER BY p.Sub_Category;


--- 4. Time & Shipping Analysis

--1. What are the monthly  sales trends?

SELECT MONTH(o.Order_Date) AS Month,
       SUM(s.Sales) AS TotalSales
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
GROUP BY MONTH(o.Order_Date)
ORDER BY  TotalSales ;

--2.What is the average shipping time (Ship_Date – Order_Date)?
SELECT AVG(DATEDIFF(DAY, o.Order_Date, o.Ship_Date) + 1) AS AvgShippingTime
FROM [Order] o;




--3. Which shipping mode is most frequently used?
SELECT TOP 1 o.Ship_Mode, COUNT(o.Order_ID) AS NumOrders
FROM [Order] o
GROUP BY o.Ship_Mode
ORDER BY NumOrders DESC;

--4. Do certain months show peaks in order volume?
SELECT MONTH(o.Order_Date) AS Month,
       COUNT(o.Order_ID) AS NumOrders
FROM [Order] o
GROUP BY MONTH(o.Order_Date)
ORDER BY NumOrders DESC;

--5. Is there a correlation between long shipping times and lower repeat orders?
SELECT YEAR(o.Order_Date) AS Year,
        AVG(DATEDIFF(DAY, o.Order_Date, o.Ship_Date)+1) AS AvgShippingTime,
        COUNT(o.Customer_ID) - COUNT(DISTINCT o.Customer_ID) AS RepeatOrders
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
GROUP BY YEAR(o.Order_Date)
ORDER BY Year DESC;

---5. Business Performance & Forecast Insights
--1. Which product categories show consistent growth over time (for forecasting)?
SELECT p.Category,
       SUM(CASE WHEN YEAR(o.Order_Date) = 2015 THEN s.Sales ELSE 0 END) AS Sales_2015,
       SUM(CASE WHEN YEAR(o.Order_Date) = 2016 THEN s.Sales ELSE 0 END) AS Sales_2016,
       SUM(CASE WHEN YEAR(o.Order_Date) = 2017 THEN s.Sales ELSE 0 END) AS Sales_2017,
	   SUM(CASE WHEN YEAR(o.Order_Date) = 2018 THEN s.Sales ELSE 0 END) AS Sales_2018
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY p.Category;




--2. Which regions have stable sales patterns suitable for prediction models?

SELECT DATEPART(QUARTER, o.Order_Date) AS Quarter,
     SUM(CASE WHEN YEAR(o.Order_Date) = 2015 THEN s.Sales ELSE 0 END) AS Sales_2015,
       SUM(CASE WHEN YEAR(o.Order_Date) = 2016 THEN s.Sales ELSE 0 END) AS Sales_2016,
       SUM(CASE WHEN YEAR(o.Order_Date) = 2017 THEN s.Sales ELSE 0 END) AS Sales_2017,
	   SUM(CASE WHEN YEAR(o.Order_Date) = 2018 THEN s.Sales ELSE 0 END) AS Sales_2018
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
GROUP BY DATEPART(QUARTER, o.Order_Date)
ORDER BY DATEPART(QUARTER, o.Order_Date);


--3. What are the top products to focus on for next-month sales forecasting?
SELECT TOP 5 p.Product_Name, 
             p.Product_ID, 
             SUM(s.Sales) AS TotalSales
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
JOIN Product p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name, p.Product_ID
ORDER BY TotalSales DESC;

--4. Is there a seasonal pattern in the order volume (monthly or quarterly)?
SELECT 
    YEAR(o.Order_Date) AS Year,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 1 THEN 1 ELSE 0 END) AS Qtr1_Orders,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 2 THEN 1 ELSE 0 END) AS Qtr2_Orders,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 3 THEN 1 ELSE 0 END) AS Qtr3_Orders,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 4 THEN 1 ELSE 0 END) AS Qtr4_Orders
FROM [Order] o
GROUP BY YEAR(o.Order_Date)
ORDER BY Year DESC;

SELECT 
    YEAR(o.Order_Date) AS Year,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 1 THEN s.Sales ELSE 0 END) AS Qtr1_Sales,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 2 THEN s.Sales ELSE 0 END) AS Qtr2_Sales,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 3 THEN s.Sales ELSE 0 END) AS Qtr3_Sales,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 4 THEN s.Sales ELSE 0 END) AS Qtr4_Sales
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
GROUP BY YEAR(o.Order_Date)
ORDER BY Year DESC;

--5. Can we identify early signals of sales slowdown (drop in order count or value)?
--the same

--Product dashboard 

--1.	Total number of categories 
SELECT COUNT(DISTINCT Category) FROM product ;

--2.	Total number of subcategories
SELECT COUNT(DISTINCT Sub_Category) FROM product ;
--3.	Total number of products 
SELECT COUNT(DISTINCT Product_ID) FROM product ;
--4.	All subcategory in each category 
SELECT DISTINCT  Category,Sub_Category FROM Product
ORDER BY  Category, Sub_Category;
--5.	Total number of products in each category and subcategory
SELECT Category, Sub_Category, COUNT(*) AS TotalProducts
FROM Product
GROUP BY Category, Sub_Category;
--6.	Top 5 products per sales 
SELECT TOP 5 p.Product_Name, SUM(s.Sales) AS TotalSales
FROM Product p
JOIN [sales Detailes] s ON p.Product_ID = s.Product_ID
GROUP BY p.Product_Name
ORDER BY TotalSales Desc;

--7.	Less 5 products per sales  
SELECT TOP 5 p.Product_Name, SUM(s.Sales) AS TotalSales
FROM Product p
JOIN [sales Detailes] s ON p.Product_ID = s.Product_ID
GROUP BY p.Product_Name
ORDER BY TotalSales Asc;

--8.	Top 5 products per sales per category and subcategory 
SELECT TOP 5 p.Category, p.Sub_Category, p.Product_Name, SUM(s.Sales) AS TotalSales
FROM Product p
JOIN [sales Detailes] s ON p.Product_ID = s.Product_ID
GROUP BY p.Category, p.Sub_Category, p.Product_Name
ORDER BY p.Category, p.Sub_Category, TotalSales DESC;

--9.	Less 5 products per sales per category and subcategory 
SELECT TOP 5 p.Category, p.Sub_Category, p.Product_Name, SUM(s.Sales) AS TotalSales
FROM Product p
JOIN [sales Detailes] s ON p.Product_ID = s.Product_ID
GROUP BY p.Category, p.Sub_Category, p.Product_Name
ORDER BY p.Category, p.Sub_Category, TotalSales ASC;


--Customers dashboard 
--1.	Total number of customers 
SELECT COUNT(DISTINCT Customer_ID) AS TotalCustomers
FROM Customer;

--2.Top region by customer count
SELECT o.Region,COUNT(DISTINCT o.Customer_ID) AS Customer_Count
FROM [order] o
GROUP BY o.Region
ORDER BY Customer_Count DESC;
 --3.	Top 10 customers per sales
SELECT TOP 10 c.Customer_Name,C.Customer_ID ,SUM(s.Sales) AS TotalSales
FROM [sales Detailes] s 
JOIN [Order] o ON s.Order_ID = o.Order_ID
JOIN [Customer] c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name,C.Customer_ID
ORDER BY TotalSales DESC;

--4. Top 10 customers per sales in each segment
SELECT c.Segment, COUNT(DISTINCT o.Customer_ID ) AS Number_of_Customer, SUM(sd.Sales) AS Total_Sales
FROM customer c
JOIN [order] o ON c.Customer_ID = o.Customer_ID
JOIN [sales Detailes] sd ON o.Order_ID = sd.Order_ID
GROUP BY c.Segment
ORDER BY c.Segment, Total_Sales DESC;

--5.Top 10 loyal customers per number of orders
SELECT TOP 10 o.Customer_ID, COUNT(DISTINCT o.Order_ID) AS Orders_Count
FROM [order] o
GROUP BY o.Customer_ID
ORDER BY Orders_Count DESC;

 --6.	total number of customer per category& subcategory, products 
 SELECT  p.Category, p.Sub_Category,COUNT(DISTINCT o.Customer_ID) AS Total_Customers
FROM [sales Detailes] SD
JOIN product p ON SD.Product_ID = p.Product_ID
JOIN [order] o ON sd.Order_ID = o.Order_ID
GROUP BY p.Category, p.Sub_Category
ORDER BY p.Category, p.Sub_Category;

--7.Customer segment versus category sales
SELECT c.Segment,COUNT(DISTINCT o.Customer_ID )AS Number_of_Customer, p.Category,SUM(sd.Sales) AS Total_Sales
FROM customer c
JOIN [order] o ON c.Customer_ID = o.Customer_ID
JOIN [sales Detailes] sd ON o.Order_ID = sd.Order_ID
JOIN product p ON sd.Product_ID = p.Product_ID
GROUP BY c.Segment, p.Category
ORDER BY c.Segment, p.Category;


---Sales dashboard
--1.Total sales 
SELECT SUM(Sales) AS TotalSales
FROM [sales Detailes];
--2.What is the total sales amount over time (monthly, quarterly, yearly)?
--Year
 SELECT YEAR(Order_Date) AS Year,
       SUM(Sales) AS TotalSalesRevenue
FROM [sales Detailes] 
JOIN [Order] 
ON [sales Detailes].Order_ID = [Order].Order_ID
WHERE YEAR(Order_Date) IN (2015, 2016, 2017, 2018)
GROUP BY YEAR(Order_Date)
ORDER BY Year;
 -- Quarterly Sales
SELECT 
    YEAR(o.Order_Date) AS Year,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 1 THEN s.Sales ELSE 0 END) AS Qtr1_Sales,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 2 THEN s.Sales ELSE 0 END) AS Qtr2_Sales,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 3 THEN s.Sales ELSE 0 END) AS Qtr3_Sales,
    SUM(CASE WHEN DATEPART(QUARTER, o.Order_Date) = 4 THEN s.Sales ELSE 0 END) AS Qtr4_Sales,
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
GROUP BY YEAR(o.Order_Date)
ORDER BY Year DESC;
-- Monthly Sales
SELECT 
    MONTH(o.Order_Date) AS MONTH,
    SUM(CASE WHEN YEAR(o.Order_Date) = 2015 THEN s.Sales ELSE 0 END) AS Sales_2015,
    SUM(CASE WHEN YEAR(o.Order_Date) = 2016 THEN s.Sales ELSE 0 END) AS Sales_2016,
    SUM(CASE WHEN YEAR(o.Order_Date) = 2017 THEN s.Sales ELSE 0 END) AS Sales_2017,
    SUM(CASE WHEN YEAR(o.Order_Date) = 2018 THEN s.Sales ELSE 0 END) AS Sales_2018
FROM [Sales Detailes] s
JOIN [Order] o ON s.Order_ID = o.Order_ID
GROUP BY MONTH(o.Order_Date)
ORDER BY MONTH(o.Order_Date);


--3.	Total sales per region. 
SELECT 
    o.Region,SUM(sd.Sales) AS Total_Sales
FROM [sales Detailes] sd
JOIN [order] o ON sd.Order_ID = o.Order_ID
GROUP BY o.Region
ORDER BY Total_Sales DESC;

--4.Top 5 subcategories per sales  
SELECT TOP 5 p.Sub_Category,SUM(sd.Sales) AS Total_Sales
FROM product p
JOIN [sales Detailes] sd ON p.Product_ID = sd.Product_ID
GROUP BY p.Sub_Category
ORDER BY Total_Sales DESC;
--5.	Less 5 subcategories per sales 
SELECT TOP 5 p.Sub_Category, SUM(sd.Sales) AS Total_Sales
FROM product p
JOIN [sales Detailes] sd ON p.Product_ID = sd.Product_ID
GROUP BY p.Sub_Category
ORDER BY Total_Sales ASC;
--6.	Which regions, states, or cities generate the highest total sales
SELECT Top 1
    o.Region,
    o.State,
    o.City,
    SUM(sd.Sales) AS Total_Sales
FROM [sales Detailes] sd
JOIN [order] o ON sd.Order_ID = o.Order_ID
GROUP BY o.Region, o.State, o.City
ORDER BY Total_Sales DESC;
--7.	Top 5 products per sales  
SELECT TOP 5
    p.Product_Name,
    SUM(sd.Sales) AS Total_Sales
FROM product p
JOIN [sales Detailes] sd ON p.Product_ID = sd.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sales DESC;

--8.	Less 5 products per sales  
SELECT TOP 5
    p.Product_Name,
    SUM(sd.Sales) AS Total_Sales
FROM product p
JOIN [sales Detailes] sd ON p.Product_ID = sd.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sales ASC;
--9.	What is the average sales per order
SELECT  AVG(OrderSales) AS Avg_Sales_Per_Order
FROM (SELECT  o.Order_ID, SUM(sd.Sales) AS OrderSales FROM [sales Detailes] sd
    JOIN [order] o ON sd.Order_ID = o.Order_ID
    GROUP BY o.Order_ID) AS t;
--10.	Which product categories or sub-categories generate the most sales?
--Category
SELECT p.Category,SUM(sd.Sales) AS Total_Sales
FROM product p
JOIN [sales Detailes] sd ON sd.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Sales DESC;
--Subcategory
SELECT p.Sub_Category,SUM(sd.Sales) AS Total_Sales
FROM product p
JOIN [sales Detailes] sd ON sd.Product_ID = p.Product_ID
GROUP BY p.Sub_Category
ORDER BY Total_Sales DESC;
--11.	Sales category from (1-1000) &(1000-10000) &(10000-25000) per category 
SELECT  p.Category,CASE 
        WHEN sd.Sales BETWEEN 1 AND 1000 THEN '1–1000'
        WHEN sd.Sales BETWEEN 1000 AND 10000 THEN '1000–10000'
        WHEN sd.Sales BETWEEN 10000 AND 25000 THEN '10000–25000'
    END AS Sales_Range,
    count (sd.Sales) AS Num_Sales
FROM product p
JOIN [sales Detailes] sd ON sd.Product_ID = p.Product_ID
GROUP BY 
    p.Category,
    CASE 
        WHEN sd.Sales BETWEEN 1 AND 1000 THEN '1–1000'
        WHEN sd.Sales BETWEEN 1000 AND 10000 THEN '1000–10000'
        WHEN sd.Sales BETWEEN 10000 AND 25000 THEN '10000–25000'
    END
ORDER BY p.Category, Sales_Range;

--12.	 Sales per week days 
SELECT 
    DATENAME(WEEKDAY, o.Order_Date) AS Weekday,
    SUM(sd.Sales) AS Total_Sales
FROM [sales Detailes] sd
JOIN [order] o ON sd.Order_ID = o.Order_ID
GROUP BY DATENAME(WEEKDAY, o.Order_Date)
ORDER BY Total_Sales DESC;






























