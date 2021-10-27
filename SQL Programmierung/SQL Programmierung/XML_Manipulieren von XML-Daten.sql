USE AdventureWorks2014
GO

-- Variable mit XML erstellen
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

-- Daten löschen mit der delete-Methode
SET @OrderDetails.modify(
'delete /Root/OrderDetail[@OrderDetailID = 1]'
)

select @OrderDetails


-- Daten einfügen mit der insert-Methode
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify
(
'insert <OrderDetail OrderDetailID="3"/> 
 into
 (/Root)[1]'
 ) 

select @OrderDetails


-- Daten am Anfang einfügen mit insert/first
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify
(
'insert <OrderDetail OrderDetailID="2"/>
as first
into (/Root)[1]'
) 

-- Daten löschen mit der delete-Methode
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify('
delete /Root/OrderDetail[@OrderDetailID = 1]')
select @OrderDetails


-- Daten ändern mit der replace value of-Methode
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify('
replace value of (/Root/OrderDetail/@OrderDetailID)[1]
with 100')

select @OrderDetails