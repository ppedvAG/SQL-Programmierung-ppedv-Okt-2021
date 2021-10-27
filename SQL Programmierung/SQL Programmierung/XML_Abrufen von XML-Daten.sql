USE Northwind
GO


select 1 TAG ,NULL parent,* from orders for xml EXPLICIT

select * from customers for xml RAW
select * from customers for xml Auto, elements



-- Tabelle anlegen
CREATE TABLE Orders2
(
	OrderID int PRIMARY KEY,
	OrderDate datetime,
	OrderNumber nvarchar(25),
	CustomerID int,
	OrderDetails xml
)
GO

-- Testdatensatz anlegen
INSERT INTO Orders2 (OrderID, OrderDate, OrderNumber, CustomerID, OrderDetails)
VALUES 
(
43659, '2001-07-01 00:00:00.000', 'SO43659', 676,
N'<Root>
	<OrderDetail OrderDetailID="1" OrderID="43659" Quantity="1" ProductID="776" UnitPrice="2024.9940" />
	<OrderDetail OrderDetailID="2" OrderID="43659" Quantity="3" ProductID="777" UnitPrice="2024.9940" />
	<OrderDetail OrderDetailID="3" OrderID="43659" Quantity="1" ProductID="778" UnitPrice="2024.9940" />
</Root>'
)
GO

-- Zugriff mit der query-Methode (XPath)
SELECT	OrderDetails.query('/Root/OrderDetail[@ProductID = 776]') AS OrderDetails
FROM	Orders2
GO

-- Zugriff mit der query-Methode (XQuery)
SELECT	OrderDetails.query('
		for $i in /Root/OrderDetail
		where /Root/OrderDetail[@ProductID = 776]
		return $i
		') AS OrderDetails
FROM	Orders
GO

-- Zugriff mit der exist-Methode
SELECT	OrderDetails
FROM	Orders2
WHERE	OrderDetails.exist('/Root/OrderDetail[@ProductID = 776]') = 1
GO

-- Zugriff mit der value-Methode
SELECT	OrderDetails.value('(/Root/OrderDetail/@ProductID)[1]', 'int') AS ProductID
FROM	Orders2
WHERE	OrderDetails.exist('/Root/OrderDetail[@OrderDetailID = 1]') = 1
GO

-- Zugriff mit der nodes-Methode
SELECT	Orders2.OrderDetails.query('.') AS OrderDetails
FROM	Orders2
CROSS APPLY OrderDetails.nodes('/Root/OrderDetail[@OrderDetailID]') AS Orders3(OrderDetails)
GO

-- Tabelle enfernen
DROP TABLE Orders2
GO
