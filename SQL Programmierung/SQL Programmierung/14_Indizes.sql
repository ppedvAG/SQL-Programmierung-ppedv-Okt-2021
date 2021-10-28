select top 3 * from kunden

set statistics io, time on
select * from kunden 
where customerid = 'aduad'


/*
wie Telefonbuch
IX bei where

 NGR Index .. wie Telefonbuch
	best Datenwerte werden rauskopiert in neue Seiten
	und dort sortiert abgelegt
	Auf diese abgelegten Seiten wird ein Baum generiert
	der bei der Suche hilft
 pro Tabelle auch 1000 Stück
 Wann ist der gut?
	bei rel wenigen Ergebnissen  kann auch 1 % sein
	typisch: bei = ; ID bzw PK
	LookUp ist sehr teuer
	daher versucht man, alle Infos in den IX zu bringen
	damit er immer ein Seek machen kann

 GR Index = Tabelle in immer sortierter Form
 nur 1 mal pro Tabelle
  Wann ist der gut?
	Wenn rel viele Zeilen rauskommen  bzw Bereichsabfragen
	typisch. PLZ, Quartal, Jahr
	auch bei rel geringen Ergebnissen 

HEAP durchsuchen: Table, SCAN

SCAN a bis z suchen
SEEK herauspicken



GR IX und NGR IX

zusammengestzter IX .. gut bei mehr Where Spalten

IX mit eingeschl Spalten.. belasten den Baum und es geht um die SELCT Baum

eindeutiger IX.. Wert im IX Schlüsselspalten (where) nur 1 mal


--durch Indizes können gezielt Sperren auf DS gemacht werden
--wir wissen ja 1:704:02  

--wenn wir mehr ändern, dann kann das Niveau der Sperre auf Seite steigen


*/


select * from customers

select * from orders


insert into Customers (CustomerID, CompanyName)
values
					 ('ppedv', 'Fa ppedv AG')




SELECT c.CustomerID, c.CompanyName, c.Country, c.City, od.OrderID, o.Freight, o.OrderDate, od.UnitPrice, od.Quantity, p.ProductName, e.LastName
into ku
FROM   dbo.Customers AS c INNER JOIN
         dbo.Orders AS o ON c.CustomerID = o.CustomerID INNER JOIN
         dbo.[Order Details] AS od ON od.OrderID = o.OrderID INNER JOIN
         dbo.Products AS p ON p.ProductID = od.ProductID INNER JOIN
         dbo.Employees AS e ON e.EmployeeID = o.EmployeeID

--solange bis 1,1 Mio DS
insert into ku
select * from ku

set statistics io, time on
--HEAP + eindeutiger Wert, aber kein IX
alter table ku add id int identity

--kein IX--> Plan: TABLE SCAN
select ID from ku where ID = 100 --54000 Seiten

--muss schneller sein..
-- Nicht gr IX auf ID

--Plan jetzt: SEEK  IX SEEK
select ID from ku where ID = 100 --3 Seiten 0 sec

--IX SEEK aber Anruf
select ID, freight from ku where ID < 11500 --ab ca 11500 T SCAN

--was kann man denn tun, um nicht anrufen zu müssen

--IX mit den Werten inklusive
--NIX_ID_FR -- zusammengesetzter IX
--Problem: max 16 Spalten
select ID, freight from ku where ID < 11500

select ID, freight from ku where ID < 900000

--die Spalten des zusm. Index braucht man nur dann,
.-- wenn sie im where gefragt werden

--besser geht so:
--IX mit eingeschloss. Spalten

CREATE NONCLUSTERED INDEX [NIX_CITY_INKL] ON [dbo].[ku]
(	[City] ASC )
INCLUDE([Freight],[ProductName],[id]) 
GO



select ID, freight, productname from ku
	where City = 'Berlin'


select country, city, SUM(unitprice*quantity) as Umsatz
from ku
	where Lastname = 'Davolio' and OrderID < 10300
	group by Country, city


CREATE NONCLUSTERED INDEX [NonClusteredIndex-20211028-150447] ON [dbo].[ku]
(
	[OrderID] ASC,
	[LastName] ASC
)
INCLUDE([Country],[City],[UnitPrice],[Quantity]) 



CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[ku] ([LastName],[OrderID])
INCLUDE ([Country],[City],[UnitPrice],[Quantity])


--bei OR macht der SQL schlapp

select country, city, SUM(unitprice*quantity) as Umsatz
from ku
	where Lastname = 'Davolio' OR OrderID < 10300
	group by Country, city