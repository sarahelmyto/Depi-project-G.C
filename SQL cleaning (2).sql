Use Project 

Product


--1 LTRIM / RTRIM 
UPDATE [Product]

SET [Product_ID]   = LTRIM(RTRIM([Product_ID])),
    [Category]     = LTRIM(RTRIM([Category])),
    [Sub_Category] = LTRIM(RTRIM([Sub_Category])),
    [Product_Name] = LTRIM(RTRIM([Product_Name]));

 --double spaces 
UPDATE [Product]
SET [Product_Name] = REPLACE([Product_Name],'  ',' ');

-- 2  Upper/Lower/Capitalization 
-- A) 
UPDATE [Product]
SET [Product_ID] = UPPER([Product_ID]);
-- B) 
UPDATE [Product]
SET [Category] = CONCAT(UPPER(LEFT([Category],1)), LOWER(SUBSTRING([Category],2,LEN([Category])))),
    [Sub_Category] = CONCAT(UPPER(LEFT([Sub_Category],1)), LOWER(SUBSTRING([Sub_Category],2,LEN([Sub_Category]))));
-- C) 
UPDATE [Product]
SET [Product_Name] = CONCAT(UPPER(LEFT([Product_Name],1)), LOWER(SUBSTRING([Product_Name],2,LEN([Product_Name]))));

--3  NULL
-- A) 
SELECT
    SUM(CASE WHEN [Product_ID]   IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN [Category]     IS NULL THEN 1 ELSE 0 END) AS Null_Category,
    SUM(CASE WHEN [Sub_Category] IS NULL THEN 1 ELSE 0 END) AS Null_SubCategory,
    SUM(CASE WHEN [Product_Name] IS NULL THEN 1 ELSE 0 END) AS Null_Product_Name
FROM [Product];
-- B)
SELECT [Product_ID], [Category], [Sub_Category], [Product_Name]
FROM [Product]
WHERE [Product_ID] IS NULL
   OR [Category] IS NULL
   OR [Sub_Category] IS NULL
   OR [Product_Name] IS NULL;

-- 4 duplicated rows
-- A)  Product ID
SELECT [Product_ID], COUNT(*) AS DupCount
FROM [Product]
GROUP BY [Product_ID]
HAVING COUNT(*) > 1
ORDER BY DupCount DESC;
-- B)
SELECT COUNT(*) AS TotalProducts
FROM [Product];
-- D)
SELECT [Product_ID], COUNT(*) AS NumOfProducts
FROM [Product]
GROUP BY [Product_ID]
HAVING COUNT(*) > 1;

Use Project 
---Order 

--1 LTRIM / RTRIM 
UPDATE [Order]
SET 
    [Order_ID]     = LTRIM(RTRIM([Order_ID])),
    [Ship_Mode]    = LTRIM(RTRIM([Ship_Mode])),
    [Customer_ID]  = LTRIM(RTRIM([Customer_ID])),
    [Country]      = LTRIM(RTRIM([Country])),
    [City]         = LTRIM(RTRIM([City])),
    [State]        = LTRIM(RTRIM([State])),
    [Postal_Code]  = LTRIM(RTRIM([Postal_Code])),
    [Region]       = LTRIM(RTRIM([Region]));

--2 Upper / Lower / Concatenation
A.
UPDATE [Order]
SET [Country] = UPPER([Country]);
B.
UPDATE [Order]
SET [Region] = LOWER([Region]);
C.
UPDATE [Order]
SET 
    [City]  = UPPER(LEFT([City],1)) + LOWER(SUBSTRING([City],2,LEN([City]))),
    [State] = UPPER(LEFT([State],1)) + LOWER(SUBSTRING([State],2,LEN([State])));
D.
UPDATE [Order]
SET [Order_ID] = UPPER([Order_ID]),
    [Customer_ID] = UPPER([Customer_ID]);
E.
--  (Ship Mode)
UPDATE [Order]
SET [Ship_Mode] = CONCAT(UPPER(LEFT([Ship_Mode],1)), LOWER(SUBSTRING([Ship_Mode],2,LEN([Ship_Mode]))));
F.
UPDATE [Order]
SET Order_Date = FORMAT(CONVERT(date, Order_Date, 103), 'yyyy-MM-dd');
UPDATE [Order] 
SET Ship_Date = FORMAT(CONVERT(date, Ship_Date, 103), 'yyyy-MM-dd');

--3 Null
--A.null
SELECT 
    SUM(CASE WHEN [Order_ID]    IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN [Order_Date]  IS NULL THEN 1 ELSE 0 END) AS Null_Order_Date,
    SUM(CASE WHEN [Ship_Date]   IS NULL THEN 1 ELSE 0 END) AS Null_Ship_Date,
    SUM(CASE WHEN [Ship_Mode]   IS NULL THEN 1 ELSE 0 END) AS Null_Ship_Mode,
    SUM(CASE WHEN [Customer_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN [Country]     IS NULL THEN 1 ELSE 0 END) AS Null_Country,
    SUM(CASE WHEN [City]        IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN [State]       IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN [Postal_Code] IS NULL THEN 1 ELSE 0 END) AS Null_Postal_Code,
    SUM(CASE WHEN [Region]      IS NULL THEN 1 ELSE 0 END) AS Null_Region
FROM [Order];
--Bnull
SELECT [City],[State],COUNT(*) AS NullCount
FROM [Order]
WHERE [Postal_Code] IS NULL
GROUP BY [City], [State]
ORDER BY NullCount DESC;
--C
SELECT 
    [Order_ID],[Order_Date],[Ship_Date],[Ship_Mode],[Customer_ID],[Country],[City],[State],[Postal_Code],[Region]
FROM [Order]
WHERE [Postal_Code] IS NULL;

--D Null Postal_Code = 05401
UPDATE [Order]
SET [Postal_Code] = '05401'
WHERE 
    [Postal_Code] IS NULL
    AND [City] = 'Burlington'
    AND [State] = 'Vermont'
    AND ([Country] = 'United States');

--4 duplicated rows
--A 
SELECT [Order_ID],COUNT(*) AS DupCount
FROM [order]
GROUP BY [Order_ID]
HAVING COUNT(*) > 1
ORDER BY DupCount DESC;
--Bduplicated rows
;WITH Duplicates AS (SELECT *,ROW_NUMBER() OVER (PARTITION BY [Order_ID] 
ORDER BY [Order_ID]) AS rn
FROM [order])
DELETE FROM Duplicates
WHERE rn > 1;
--C  duplicatedrows
SELECT COUNT(*) AS TotalOrders
FROM [order];
-- D --duplicated Order_ID
SELECT [Order_ID], COUNT(*) AS NumOfOrders
FROM [order]
GROUP BY [Order_ID]
HAVING COUNT(*) > 1;

create database Project

---Customer table:

--1 LTRIM .. RTRIM

UPDATE Customer
SET 
    Customer_Name = LTRIM(RTRIM(Customer_Name)),
    Segment       = LTRIM(RTRIM(Segment));


--2 Uper..lower..concat
A.
UPDATE Customer
SET Customer_Name = CONCAT( 
                UPPER(LEFT(Customer_Name,1)),
                LOWER(SUBSTRING(Customer_Name,2,LEN(Customer_Name))));
B.
UPDATE Customer
SET Segment = CONCAT(
        UPPER(LEFT(LTRIM(RTRIM(Segment)),1)),
        LOWER(SUBSTRING(LTRIM(RTRIM(Segment)),2,LEN(LTRIM(RTRIM(Segment))))));

--3 Null

SELECT * FROM Customer
WHERE [Customer_ID] IS NULL 
   OR [Customer_Name] IS NULL 

--4 duplicated rows
A.
SELECT 
  [Customer_ID],[Customer_Name],[Segment], COUNT(*) AS DupCount
FROM customer
GROUP BY [Customer_ID],[Customer_Name],[Segment]
HAVING COUNT(*) > 1
ORDER BY DupCount DESC;
B.
-- duplucated rows
;WITH Duplicates AS (SELECT  *,ROW_NUMBER() OVER (PARTITION BY Customer_ID, Customer_Name, Segment
ORDER BY Customer_ID ) AS rn
FROM Customer)
DELETE FROM Duplicates
WHERE rn > 1;
C.
-- Count of rows
SELECT COUNT(*) AS TotalCustomers FROM Customer;
D.
-- duplicated Customer_ID
SELECT Customer_ID, COUNT(*) AS NumOfCustomer
FROM Customer
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

--sales Detailes
--duplicates
SELECT 
  [Order_ID], [Product_ID],sales, COUNT(*) AS DupCount
FROM [sales Detailes]
GROUP BY [Order_ID], [Product_ID], sales
HAVING COUNT(*) > 1
ORDER BY DupCount DESC;

---Key

ALTER TABLE [dbo].[sales Detailes]
ADD CONSTRAINT [PK_sales_Detailes]
PRIMARY KEY ([Order_ID], [Product_ID]);

SELECT [Order_ID], [Product_ID], COUNT(*) AS DupCount
FROM [dbo].[sales Details]
GROUP BY [Order_ID], [Product_ID]
HAVING COUNT(*) > 1;


SELECT COUNT(*) as [sales Detailes]
FROM [sales Detailes]; 
SELECT COUNT(*) as Customer
FROM Customer; 
SELECT COUNT(*) as [order]
FROM [order];
SELECT COUNT(*) as Product
FROM Product;



 SELECT COUNT(*) Customer_ID FROM dbo.customer as NumCustomer

 SELECT COUNT(DISTINCT Order_ID) FROM dbo.[order] as NumOrder
 
 SELECT SUM(Sales) FROM [sales Detailes] as TotalSales





