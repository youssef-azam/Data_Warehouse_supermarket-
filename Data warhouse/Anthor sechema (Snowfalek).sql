create database sales_house_snowfalk

-- Dimension Tables
CREATE TABLE Dim_Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50) NOT NULL,
    Category_ID INT NOT NULL,
    Brand_ID INT NOT NULL,
    Weight DECIMAL(10, 2) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    Expiry_Date DATE NOT NULL,
    FOREIGN KEY (Category_ID) REFERENCES Dim_Product_Category(Category_ID),
    FOREIGN KEY (Brand_ID) REFERENCES Dim_Product_Brand(Brand_ID)
);

CREATE TABLE Dim_Product_Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Product_Brand (
    Brand_ID INT PRIMARY KEY,
    Brand_Name VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50) NOT NULL,
    Mobile VARCHAR(11) UNIQUE NOT NULL,
    Membership_Status VARCHAR(20) NOT NULL,
    Gender CHAR(1) NOT NULL,
    Age INT NOT NULL,
    Address VARCHAR(50),
    Feedback VARCHAR(100)
);

CREATE TABLE Dim_Employees (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Age INT NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Work_Hours INT NOT NULL,
    Marital_Status VARCHAR(20) NOT NULL,
    Ratings DECIMAL(3, 2) NOT NULL,
    Phone_Number VARCHAR(15),
    Branch_ID INT NOT NULL,
    Department_ID INT NOT NULL,
    FOREIGN KEY (Branch_ID) REFERENCES Dim_Branches(Branch_ID), -- Corrected reference
    FOREIGN KEY (Department_ID) REFERENCES Dim_Departments(Department_ID)
);


CREATE TABLE Dim_Branches (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(50) NOT NULL,
    Contact VARCHAR(15) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Opening_Hours VARCHAR(100) NOT NULL,
    Staff_Count INT NOT NULL
);

CREATE TABLE Dim_Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50) NOT NULL,
    Head VARCHAR(50) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Budget DECIMAL(15, 2) NOT NULL,
    Creation_Date DATE NOT NULL
);

CREATE TABLE Dim_Promotions (
    Promotion_ID INT PRIMARY KEY,
    Promotion_Name VARCHAR(50) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Percentage DECIMAL(5, 2) NOT NULL
);

CREATE TABLE Dim_Delivery (
    Delivery_ID INT PRIMARY KEY,
    Delivery_Date DATE NOT NULL,
    Cost_of_Services DECIMAL(10, 2) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Status VARCHAR(20) NOT NULL
);

CREATE TABLE Dim_Payment (
    Payment_ID INT PRIMARY KEY,
    Billing_Address VARCHAR(100) NOT NULL,
    Method VARCHAR(50) NOT NULL,
    Transaction_ID VARCHAR(50) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL
);

CREATE TABLE Dim_Date (
    Date_ID INT PRIMARY KEY,
    Full_Date DATE NOT NULL,
    Day INT NOT NULL,
    Month INT NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Day_of_Week INT NOT NULL,
    Day_of_Year INT NOT NULL,
    Week_of_Year INT NOT NULL,
    Is_Weekend BIT NOT NULL
);

-- Fact Table 
CREATE TABLE Fact_Sales (
    Sales_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    Branch_ID INT NOT NULL,
    Delivery_ID INT NOT NULL,
    Payment_ID INT NOT NULL,
    Promotion_ID INT NOT NULL,
    Date_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10, 2) NOT NULL,
    Total_Price DECIMAL(15, 2) NOT NULL,
    Shipping_Cost DECIMAL(10, 2) NOT NULL,
    Discount DECIMAL(5, 2) NOT NULL,
    Net_Sales DECIMAL(15, 2) NOT NULL,
    Gross_Margin DECIMAL(10, 2) NOT NULL,
    Avg_Transaction_Value DECIMAL(15, 2) NOT NULL,
    Avg_Quantity_Per_Transaction DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES Dim_Payment(Payment_ID),
    FOREIGN KEY (Product_ID) REFERENCES Dim_Products(Product_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customers(Customer_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Dim_Employees(Employee_ID),
    FOREIGN KEY (Branch_ID) REFERENCES Dim_Branches(Branch_ID),
    FOREIGN KEY (Delivery_ID) REFERENCES Dim_Delivery(Delivery_ID),
    FOREIGN KEY (Payment_ID) REFERENCES Dim_Payment(Payment_ID),
    FOREIGN KEY (Promotion_ID) REFERENCES Dim_Promotions(Promotion_ID),
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID)
);
