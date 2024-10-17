USE TestDB;
GO

-- Simulare cancellazioni
DELETE TOP (100000) FROM Orders WHERE Amount < 500;
GO