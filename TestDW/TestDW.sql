SELECT *
FROM ddw2DW.DimCustomer;
GO

SELECT *
FROM ddw2DW.DimProduct;
GO

-- TRUNCATE TABLE ddw2DW.FactSales;

SELECT *
FROM ddw2DW.FactSales;
GO

SELECT *
FROM ddw2DW.OrderBadData;
GO

SELECT count(1)
FROM ddw2DW.DimTime;
GO

SELECT *
FROM ddw2DW.DimTime;
GO

SELECT *
FROM ddw2DW.DimTime
WHERE TimeKey = 367;
GO

SELECT CustomerID, ProductID, SUM(TotalAmount) AS Total
FROM ddw2DW.FactSales
-- WHERE TimeKey = 369
GROUP BY CustomerID, ProductID
ORDER BY CustomerID

