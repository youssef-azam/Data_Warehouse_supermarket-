--------- بسم الله الرحمن الرحيم ---------------
----We strart to  convert sechema into database system-------
---- create database -----------
--create database supermarket 

--use supermarket


--create tables table_name + datatype + conistrain 
CREATE TABLE Suppliers(
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    Contact VARCHAR(15) NOT NULL
	);

CREATE TABLE Departments(
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    Budget DECIMAL(15, 2) NOT NULL,
    Head VARCHAR(50) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Contact VARCHAR(15) NOT NULL,
    Creation_Date DATE NOT NULL
);

CREATE TABLE Branches (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    Contact VARCHAR(15) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Opening_Hours VARCHAR(100) NOT NULL,
    Staff_Count INT NOT NULL
);

CREATE TABLE Customer (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    mobile VARCHAR(11) UNIQUE NOT NULL,
    Membership_status VARCHAR(20) CHECK (Membership_status IN ('Active', 'Inactive', 'Pending')) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')) NOT NULL,
    Age INT CHECK (Age >= 10) NOT NULL,
	addres varchar(50) ,
    Feedback VARCHAR(100)
);

CREATE TABLE Products(
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Brand VARCHAR(50) NOT NULL,
    Weight DECIMAL(10, 2) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    Expiry_Date DATE NOT NULL
	);

CREATE TABLE Delivery(
    ID INT PRIMARY KEY,
    Delivery_Date DATE NOT NULL,
    Cost_OF_SERVICES DECIMAL(10, 2) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Status VARCHAR(20) NOT NULL
);

CREATE TABLE STOCKS (
    ID INT PRIMARY KEY,
    ProductInventory INT NOT NULL,
    proudect_id INT NOT NULL,
    Branch_id INT NOT NULL,
	Avaliable_Quantity int not null ,
    FOREIGN KEY (proudect_id) REFERENCES Products(ID),
    FOREIGN KEY (Branch_id) REFERENCES Branches(ID)
);

CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    F_name VARCHAR(50) NOT NULL,
    L_name VARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Age INT NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Work_hours INT NOT NULL,
    Marital_status VARCHAR(20) NOT NULL,
    ratings DECIMAL(3, 2) NOT NULL,
    Number VARCHAR(15) NOT NULL,
    Branch_id INT NOT NULL,
    Department_id INT NOT NULL,
    FOREIGN KEY (Branch_id) REFERENCES Branches(ID),
    FOREIGN KEY (Department_id) REFERENCES Departments(ID)
);

CREATE TABLE promotions(
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Percentage DECIMAL(5, 2) NOT NULL
);

CREATE TABLE Payment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Billing_Address VARCHAR(100) NOT NULL,
    Method VARCHAR(50) NOT NULL,
    Transaction_ID VARCHAR(50) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL,
    CUSTOMER_ID INT,
    EMPLOYEES_ID INT,
    Suppliery_id INT,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES Customer(id),
    FOREIGN KEY (EMPLOYEES_ID) REFERENCES Employees(ID),
    FOREIGN KEY (Suppliery_id) REFERENCES Suppliers(ID)
);

CREATE TABLE branch_manage_product (
    branch_id INT NOT NULL,
    proudect_id INT NOT NULL,
    PRIMARY KEY (branch_id, proudect_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(ID),
    FOREIGN KEY (proudect_id) REFERENCES Products(ID)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_Date DATE NOT NULL,
    Delivery_Address VARCHAR(50),
    customer_id INT,
    Deliver_id INT,
    promotion_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(id),
    FOREIGN KEY (Deliver_id) REFERENCES Delivery(ID),
    FOREIGN KEY (promotion_id) REFERENCES promotions(ID)
);

CREATE TABLE order_made_proudect (
    proudect_id INT,
    order_id INT,
	Quantity int NOT NULL,
    unit_price int NOT NULL,
    FOREIGN KEY (proudect_id) REFERENCES Products(ID),
    FOREIGN KEY (order_id) REFERENCES order_detail(order_id),
    PRIMARY KEY (proudect_id, order_id)
);

create table Supplirs_supply_proudect
(
product_id int,
Supplier_id int,
PRODUCT varchar(50),
Quantity int,
total_cost int,
Uint_of_price int
FOREIGN KEY (product_id) REFERENCES Products(ID),
FOREIGN KEY (Supplier_id) REFERENCES Products(ID),
PRIMARY KEY (product_id, Supplier_id)
);


CREATE OR ALTER VIEW vw_PrepareSalesFactData AS
SELECT
    od.order_id AS Order_ID,
    od.order_Date AS Order_Date,
    d.ID AS Delivery_ID,
    d.Delivery_Date AS Delivery_Date,
    pay.id AS Payment_ID,
    od.customer_id AS Customer_ID,
    e.ID AS Employee_ID,
    e.Branch_id AS Branch_ID,
    odl.proudect_id AS Product_ID,
    odl.Quantity AS Quantity,
    odl.unit_price AS Unit_Price,
    (odl.Quantity * odl.unit_price) AS Total_Price,
    d.Cost_OF_SERVICES AS Shipping_Cost,
    pr.Percentage AS Discount,
    ((odl.Quantity * odl.unit_price) - ((odl.Quantity * odl.unit_price) * pr.Percentage / 100)) AS Net_Sales,
    (((odl.Quantity * odl.unit_price) - ((odl.Quantity * odl.unit_price) * pr.Percentage / 100)) - d.Cost_OF_SERVICES) AS Gross_Margin,
    ((odl.Quantity * odl.unit_price) / COUNT(od.order_id) OVER ()) AS Avg_Transaction_Value,
    AVG(odl.Quantity) OVER () AS Avg_Quantity_Per_Transaction,
    pr.ID AS Promotion_ID -- Make sure Promotion_ID is included
FROM 
    Orders od
JOIN 
    order_made_proudect odl ON od.order_id = odl.order_id
LEFT JOIN 
    Products p ON odl.proudect_id = p.ID
LEFT JOIN 
    Customer c ON od.customer_id = c.id
LEFT JOIN 
    Employees e ON od.customer_id = e.ID -- Adjust if necessary
LEFT JOIN 
    Branches b ON e.Branch_id = b.ID -- Adjust if necessary
LEFT JOIN 
    Delivery d ON od.Deliver_id = d.ID
LEFT JOIN 
    Payment pay ON od.customer_id = pay.CUSTOMER_ID -- Adjust if necessary
LEFT JOIN 
    promotions pr ON od.promotion_id = pr.ID;
