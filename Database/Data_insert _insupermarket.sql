DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Suppliers (ID, NAME, Contact)
    VALUES (@i, CONCAT('Supplier ', CHAR(64 + @i)), CONCAT('123-456-', RIGHT('000' + CAST(@i AS VARCHAR(3)), 3)));

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Departments (ID, NAME, Budget, Head, Location, Contact, Creation_Date)
    VALUES (@i, CONCAT('Department ', CHAR(64 + @i % 26)), 50000 + (@i * 1000), CONCAT('Head ', @i), CONCAT('Location ', @i), CONCAT('111-111-', RIGHT('000' + CAST(@i AS VARCHAR(3)), 3)), GETDATE());

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Branches (ID, NAME, Contact, Location, Opening_Hours, Staff_Count)
    VALUES (@i, CONCAT('Branch ', CHAR(64 + @i % 26)), CONCAT('111-111-', RIGHT('000' + CAST(@i AS VARCHAR(3)), 3)), CONCAT('Location ', @i), '9AM - 5PM', 10 + (@i % 10));

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Customer (id, name, mobile, Membership_status, Gender, Age, addres, Feedback)
    VALUES (@i, CONCAT('Customer ', CHAR(64 + @i % 26)), CONCAT('111111', RIGHT('0000' + CAST(@i AS VARCHAR(4)), 4)), CASE WHEN @i % 2 = 0 THEN 'Active' ELSE 'Inactive' END, CASE WHEN @i % 2 = 0 THEN 'M' ELSE 'F' END, 20 + (@i % 50), CONCAT('Address ', @i), 'Feedback text');

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Products (ID, NAME, Category, Brand, Weight, Description, Expiry_Date)
    VALUES (@i, CONCAT('Product ', CHAR(64 + @i % 26)), CONCAT('Category ', CHAR(64 + @i % 26)), CONCAT('Brand ', CHAR(64 + @i % 26)), @i % 5 + 1.0, 'Description text', DATEADD(MONTH, @i, GETDATE()));

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Delivery (ID, Delivery_Date, Cost_OF_SERVICES, Address, Status)
    VALUES (@i, DATEADD(DAY, @i, GETDATE()), 50.00 + (@i % 50), CONCAT('Delivery Address ', @i), CASE WHEN @i % 2 = 0 THEN 'Delivered' ELSE 'Pending' END);

    SET @i = @i + 1;
END;



DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO STOCKS (ID, ProductInventory, proudect_id, Branch_id, Avaliable_Quantity)
    VALUES (@i, 100 + (@i % 100), @i, @i, 80 + (@i % 40));

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Employees (ID, F_name, L_name, Salary, Age, Address, Work_hours, Marital_status, ratings, Number, Branch_id, Department_id)
    VALUES (@i, CONCAT('FirstName', CHAR(64 + @i % 26)), CONCAT('LastName', CHAR(64 + @i % 26)), 50000 + (@i * 100), 20 + (@i % 50), CONCAT('Employee Address ', @i), 40 + (@i % 10), CASE WHEN @i % 2 = 0 THEN 'Married' ELSE 'Single' END, 3.0 + (@i % 2), CONCAT('111-111-', RIGHT('000' + CAST(@i AS VARCHAR(3)), 3)), @i % 10 + 1, @i % 10 + 1);

    SET @i = @i + 1;
END;



DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO promotions (ID, NAME, Description, StartDate, EndDate, Percentage)
    VALUES (@i, CONCAT('Promotion ', CHAR(64 + @i % 26)), 'Description text', DATEADD(DAY, @i, GETDATE()), DATEADD(DAY, @i + 10, GETDATE()), @i % 50 + 5);

    SET @i = @i + 1;
END;



DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Payment (Billing_Address, Method, Transaction_ID, Payment_Status, CUSTOMER_ID, EMPLOYEES_ID, Suppliery_id)
    VALUES (CONCAT('Billing Address ', @i), CASE WHEN @i % 3 = 0 THEN 'Cash' WHEN @i % 3 = 1 THEN 'Credit Card' ELSE 'Debit Card' END, RIGHT('0000000000' + CAST(@i AS VARCHAR(10)), 10), CASE WHEN @i % 2 = 0 THEN 'Paid' ELSE 'Pending' END, @i, @i, @i);

    SET @i = @i + 1;
END;



DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO branch_manage_product (branch_id, proudect_id)
    VALUES (@i, @i);

    SET @i = @i + 1;
END;


DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Orders(order_id, order_Date, Delivery_Address, customer_id, Deliver_id, promotion_id)
    VALUES (@i, DATEADD(DAY, @i, GETDATE()), CONCAT('Delivery Address ', @i), @i, @i, @i);

    SET @i = @i + 1;
END;



DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO order_made_proudect (proudect_id, order_id, Quantity, unit_price)
    VALUES (@i, @i, 1 + (@i % 10), 10 + (@i % 20));

    SET @i = @i + 1;
END;



DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN
    INSERT INTO Supplirs_supply_proudect (product_id, Supplier_id, PRODUCT, Quantity, total_cost, Uint_of_price)
    VALUES (@i, @i, CONCAT('Product ', CHAR(64 + @i % 26)), 50 + (@i % 100), 500 + (@i * 10), 10 + (@i % 10));

    SET @i = @i + 1;
END;


