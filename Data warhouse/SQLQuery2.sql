use Data_warehouse
go 


-- Create a log table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MOCK_DATA]') AND TYPE IN (N'U'))
BEGIN
    CREATE TABLE [dbo].[audit_log](
        id INT IDENTITY,
        packagename VARCHAR(200),
        tablename VARCHAR(200),
        recordsinserted INT,
        recordsupdate INT,
        Date datetime
    );
END

-- Create MOCK_DATA table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MOCK_DATA]') AND TYPE IN (N'U'))
BEGIN
    CREATE TABLE [dbo].[MOCK_DATA](
        ID INT NULL,
        FIRST_NAME VARCHAR(50) NULL,
        LAST_NAME VARCHAR(50) NULL,
        EMAIL VARCHAR(50) NULL,
        GENDER VARCHAR(50) NULL
    );
END

-- Drop MOCK_DATA_update table if it exists
IF OBJECT_ID(N'[dbo].[MOCK_DATA_update]', N'U') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MOCK_DATA_update];
END
ELSE
BEGIN
    PRINT 'Table [dbo].[MOCK_DATA_update] does not exist.';
END

-- Create MOCK_DATA_update table
CREATE TABLE [dbo].[MOCK_DATA_update](
    ID INT NULL,
    FIRST_NAME VARCHAR(50) NULL,
    LAST_NAME VARCHAR(50) NULL,
    EMAIL VARCHAR(50) NULL,
    GENDER VARCHAR(50) NULL
);
declare @row_update int
update m 
set m.EMAIL=u.EMAIL,
m.FIRST_NAME=u.FIRST_NAME,
m.LAST_NAME=u.LAST_NAME,
m.GENDER=u.GENDER
from MOCK_DATA m inner join MOCK_DATA_update u on m.ID=u.ID
set @row_update=@@ROWCOUNT 

insert into audit_log
select 'load.dtxs','MOCK_DATA',?,@row_update,getdate()