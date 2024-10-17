USE TestDB;
GO

-- Creare una tabella di esempio
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1),
    OrderDate DATETIME,
    CustomerName NVARCHAR(100),
    Amount DECIMAL(10, 2)
);
GO