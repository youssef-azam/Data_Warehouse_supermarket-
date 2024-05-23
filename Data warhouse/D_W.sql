 --Create database
CREATE DATABASE Sales_warehouse;
GO

-- Use the database
USE Sales_warehouse;
GO


CREATE TABLE Dim_Products (
    Product_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Product_ID INT,
    Product_Name VARCHAR(50),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    Weight DECIMAL(10, 2),
    Description VARCHAR(500),
    Expiry_Date DATE
);

CREATE TABLE Dim_Customers (
    Customer_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    Mobile VARCHAR(11) UNIQUE,
    Membership_Status VARCHAR(20),
    Gender CHAR(1),
    Age INT,
    Address VARCHAR(50),
    Feedback VARCHAR(100)
);

CREATE TABLE Dim_Employees (
    Employee_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Employee_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Salary DECIMAL(10, 2),
    Age INT,
    Address VARCHAR(100),
    Work_Hours INT,
    Marital_Status VARCHAR(20),
    Ratings DECIMAL(3, 2),
    Phone_Number VARCHAR(15)
);

CREATE TABLE Dim_Branches (
    Branch_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Branch_ID INT,
    Branch_Name VARCHAR(50),
    Contact VARCHAR(15),
    Location VARCHAR(100),
    Opening_Hours VARCHAR(100),
    Staff_Count INT
);

CREATE TABLE Dim_Promotions (
    Promotion_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Promotion_ID INT,
    Promotion_Name VARCHAR(50),
    Description VARCHAR(500),
    Start_Date DATE,
    End_Date DATE,
    Percentage DECIMAL(5, 2)
);

CREATE TABLE Dim_Delivery (
    Delivery_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Delivery_ID INT,
    Delivery_Date DATE,
    Cost_of_Services DECIMAL(10, 2),
    Address VARCHAR(100),
    Status VARCHAR(20)
);

CREATE TABLE Dim_Payment (
    Payment_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Payment_ID INT,
    Billing_Address VARCHAR(100),
    Method VARCHAR(50),
    Transaction_ID VARCHAR(50),
    Payment_Status VARCHAR(20)
);

CREATE TABLE Dim_Date (
    Date_Surrogate_ID INT  IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    Date_ID INT,
    Full_Date DATE,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    Day_of_Week INT,
    Day_of_Year INT,
    Week_of_Year INT,
    Is_Weekend BIT
);
-- Fact Table 
CREATE TABLE Sales_Fact (
    Sales_ID INT IDENTITY(1,1) PRIMARY KEY,
    Product_Surrogate_ID INT,
    Customer_Surrogate_ID INT,
    Employee_Surrogate_ID INT,
    Branch_Surrogate_ID INT,
    Delivery_Surrogate_ID INT,
    Date_Surrogate_ID INT,
    Quantity INT,
    Unit_Price DECIMAL(10, 2),
    Total_Price DECIMAL(15, 2),
    Order_Date DATE,
    Delivery_Date DATE,
    Payment_Surrogate_ID INT,
    Promotion_Surrogate_ID INT,
    Shipping_Cost DECIMAL(10, 2), 
    Discount DECIMAL(5, 2), 
    Net_Sales DECIMAL(15, 2),
    Gross_Margin DECIMAL(10, 2), 
    Avg_Transaction_Value DECIMAL(15, 2), 
    Avg_Quantity_Per_Transaction DECIMAL(10, 2),
    FOREIGN KEY (Date_Surrogate_ID) REFERENCES Dim_Date(Date_Surrogate_ID),
    FOREIGN KEY (Delivery_Surrogate_ID) REFERENCES Dim_Delivery(Delivery_Surrogate_ID),
    FOREIGN KEY (Payment_Surrogate_ID) REFERENCES Dim_Payment(Payment_Surrogate_ID),
    FOREIGN KEY (Product_Surrogate_ID) REFERENCES Dim_Products(Product_Surrogate_ID),
    FOREIGN KEY (Customer_Surrogate_ID) REFERENCES Dim_Customers(Customer_Surrogate_ID),
    FOREIGN KEY (Employee_Surrogate_ID) REFERENCES Dim_Employees(Employee_Surrogate_ID),
    FOREIGN KEY (Branch_Surrogate_ID) REFERENCES Dim_Branches(Branch_Surrogate_ID),
    FOREIGN KEY (Promotion_Surrogate_ID) REFERENCES Dim_Promotions(Promotion_Surrogate_ID)
);

-- Declare start and end date range
DECLARE @startDate DATE = '2000-01-01';
DECLARE @endDate DATE = '2030-12-31';

-- Recursive CTE to generate date series
WITH DateSeries AS (
    SELECT @startDate AS [date]
    UNION ALL
    SELECT DATEADD(DAY, 1, [date])
    FROM DateSeries
    WHERE [date] < @endDate
)

-- Insert into Dim_Date table
INSERT INTO Dim_Date (
    Date_ID,
    Full_Date,
    Day,
    Month,
    Year,
    Quarter,
    Day_of_Week,
    Day_of_Year,
    Week_of_Year,
    Is_Weekend
)
SELECT
    CAST(CONVERT(VARCHAR, [date], 112) AS INT) AS Date_ID,  -- YYYYMMDD format
    [date] AS Full_Date,
    DAY([date]) AS Day,
    MONTH([date]) AS Month,
    YEAR([date]) AS Year,
    DATEPART(QUARTER, [date]) AS Quarter,
    DATEPART(WEEKDAY, [date]) AS Day_of_Week,
    DATEPART(DAYOFYEAR, [date]) AS Day_of_Year,
    DATEPART(WEEK, [date]) AS Week_of_Year,
    CASE WHEN DATEPART(WEEKDAY, [date]) IN (1, 7) THEN 1 ELSE 0 END AS Is_Weekend
FROM DateSeries
OPTION (MAXRECURSION 0);

-- Create the Dim_Date table (if it does not already exist)
IF OBJECT_ID('Dim_Date', 'U') IS NULL
BEGIN
    CREATE TABLE Dim_Date (
        Date_Surrogate_ID INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
        Date_ID INT,
        Full_Date DATE,
        Day INT,
        Month INT,
        Year INT,
        Quarter INT,
        Day_of_Week INT,
        Day_of_Year INT,
        Week_of_Year INT,
        Is_Weekend BIT
    );
END






CREATE OR ALTER VIEW vw_PrepareSalesFactDataWithDims AS
SELECT
    sf.Sales_ID AS Order_ID,
    sf.Order_Date,
    sf.Delivery_Surrogate_ID ,
    sf.Date_Surrogate_ID ,
    sf.Payment_Surrogate_ID , 
    sf.Customer_Surrogate_ID , 
    sf.Employee_Surrogate_ID, 
    sf.Branch_Surrogate_ID ,
    sf.Product_Surrogate_ID , 
    sf.Quantity,
    sf.Unit_Price,
    (sf.Quantity * sf.Unit_Price) AS Total_Price,
    d.Cost_of_Services AS Shipping_Cost,
    (sf.Total_Price * (1 - pr.Percentage / 100)) AS Net_Sales,
    (sf.Net_Sales - d.Cost_of_Services) AS Gross_Margin, 
    AVG(sf.Total_Price) OVER () AS Avg_Transaction_Value,
    AVG(sf.Quantity) OVER () AS Avg_Quantity_Per_Transaction,
    sf.Promotion_Surrogate_ID AS Promotion_Surrogate_ID 
FROM 
    Sales_Fact sf
JOIN 
    Dim_Customers dc ON sf.Customer_Surrogate_ID = dc.Customer_Surrogate_ID
JOIN 
    Dim_Employees de ON sf.Employee_Surrogate_ID = de.Employee_Surrogate_ID
JOIN 
    Dim_Branches db ON sf.Branch_Surrogate_ID = db.Branch_Surrogate_ID
JOIN 
    Dim_Products dp ON sf.Product_Surrogate_ID = dp.Product_Surrogate_ID
JOIN 
    Dim_Delivery d ON sf.Delivery_Surrogate_ID = d.Delivery_Surrogate_ID
JOIN 
    Dim_Date dd ON sf.Date_Surrogate_ID = dd.Date_Surrogate_ID
JOIN 
    Dim_Promotions pr ON sf.Promotion_Surrogate_ID = pr.Promotion_Surrogate_ID;





-- Disable foreign key constraints on the fact table
ALTER TABLE Sales_Fact NOCHECK CONSTRAINT ALL;

-- Delete data from dimension tables
DELETE FROM Dim_Products;
DELETE FROM Dim_Customers;
DELETE FROM Dim_Employees;
DELETE FROM Dim_Branches;
DELETE FROM Dim_Delivery;
DELETE FROM Dim_Date;
DELETE FROM Dim_Payment;
DELETE FROM Dim_Promotions;
DELETE FROM Sales_Fact;

-- Reset identity columns (if any) to start from 1
DBCC CHECKIDENT ('Dim_Products', RESEED, 1);
DBCC CHECKIDENT ('Dim_Customers', RESEED, 1);
DBCC CHECKIDENT ('Dim_Employees', RESEED, 1);
DBCC CHECKIDENT ('Dim_Branches', RESEED, 1);
DBCC CHECKIDENT ('Dim_Delivery', RESEED, 1);
DBCC CHECKIDENT ('Dim_Date', RESEED, 1);
DBCC CHECKIDENT ('Dim_Payment', RESEED, 1);
DBCC CHECKIDENT ('Dim_Promotions', RESEED, 1);
DBCC CHECKIDENT ('Sales_Fact', RESEED, 1);

ALTER TABLE Sales_Fact WITH CHECK CHECK CONSTRAINT ALL;


select * from Dim_Customers
select * from Dim_Products
select * from Dim_Employees
select * from Dim_Branches
select * from Dim_Delivery
select * from Dim_Date
select * from Dim_Payment
select * from Dim_Promotions
SELECT * FROM Sales_Fact