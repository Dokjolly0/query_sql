USE TestDB;
GO

-- Simulare inserimenti
DECLARE @i INT = 0;
WHILE @i < 2000000
BEGIN
    INSERT INTO Orders (OrderDate, CustomerName, Amount)
    VALUES (GETDATE(), 'Customer' + CAST(@i AS NVARCHAR(10)), RAND() * 1000);
    SET @i = @i + 1;
END;
GO