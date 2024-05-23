---- Apply adavanced topic in sql ---
--- Stored Procedures-- one or more statmint group stored and call it and stored in database as named object
--ex 
select od.order_id,order_Date,unit_price,op.Quantity,(unit_price*op.Quantity)as total_price,p.Category,p.NAME,p.Brand from order_detail od 
join order_made_proudect op 
on op.order_id=od.order_id
join Products p
on op.proudect_id=p.ID

--- User Diffend funcation 
--- local varibles 
-- Delcare @x
---- Assigain
---- set @x=10
---- select @x=100
--- select @x=age from student where id =1

--- gloab var
---cant declar gloabl var and cant assign global var
---@@
--select @@SERVERNAME
--select @@rowcount
--select @@VERSION
--select @@ERROR
--select @@IDENTITY
-- declear table and insert dased in select 
declare @t table(x int ,y varchar(20))
insert into @t
select id,name from Customer 
select * from  @t

  
-- copy data from table into anthor table 

select * into table3
from stocks

insert into table3



---we can use agg funaction with having ? when we agg and dont use anthor columns 
select sum(salary) from Employees
having count(ID)>2


-- Ranking funcation
-- Row_Number()
--Dense_Rank()group
--Ntiles()
--Rank()

select * from (
select * ,ROW_NUMBER()over(order by salary desc)as rn,
DENSE_RANK()over(order by salary desc)as DR,
NTILE(3)over(order by salary desc)as NL,
Rank()over(order by salary desc)as r
from Employees )as new_table

-- ranking funcation + partion
--- group by columns and sort by columns and start anthor group 
select * from (
select * ,DENSE_RANK()over(partition by Marital_status order by salary desc)as DR
from Employees )as new_table

-----sechema
--create schema sales
--alter schema sales transfer order_detail

-- we can create to table same name but in two differrent sechema 


--- drop  table  m --> data & metadata
--- delet form table---> data  we can use where and we can reteun data use rollback but it is low not & rest idintiy
--- trunct form table--- > data  fast & reset idintiny


----- coinstrain 
--primary key idinitys , defult, we can use funaction when use defult same getdate()
--- null and not null
--- draivin columns as (x+y) -- > persisted  it mean this drivin columns it stored in hard dask
--- we can use in one columns more conistrain same check and uinqe 





-----what it is important kpi for Owner (Measurment )
--- sum of sales , count of a proudect , profit,reven bar month 
--- Quantity Sold

select * from Customer

CREATE VIEW All_order_info AS
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    c.Age AS customer_age,
    o.order_id,
    o.order_Date,
    p.name AS product_name,
    p.category AS product_category,
    p.brand AS product_brand,
    omp.Quantity,
    omp.unit_price,
    pr.Percentage AS promotion_percentage,
    pr.EndDate AS promotion_end_date,
    pa.Method AS payment_method,
    pa.Payment_Status AS payment_status,
    o.Delivery_Address
FROM 
    Orders o
JOIN 
    Customer c ON o.customer_id = c.id
JOIN 
    order_made_proudect omp ON omp.order_id = o.order_id
JOIN 
    Products p ON p.id = omp.proudect_id
JOIN 
    Promotions pr ON pr.id = o.promotion_id
JOIN 
    Payment pa ON pa.customer_id = c.id;


