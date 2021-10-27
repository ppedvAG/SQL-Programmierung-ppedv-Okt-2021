--AGGREGATE SUM MIN MAX COUNT AVG


select	 c.customerid, c.companyname, c.country	, c.city, --Customers
		 o.OrderID, o.freight, o.orderdate, --orders
		 od.unitprice, od.quantity, --oder details
		 p.productname, --products
		 e.Lastname --employees
into #t
from customers c 
inner join orders o				on c.customerid=o.customerid
inner join [Order Details] od	on od.OrderID=o.OrderID
inner join products p			on p.ProductID=od.ProductID
inner join Employees e			on e.EmployeeID=o.EmployeeID
--#temporäre Tabelle

--Umsatz pro Kunde


select * from #t

--Umsatz pro Kunde

--Was wollen wir sehen?

--Firma, Umsatz
--Summe pro Firma
select companyname, sum(UnitPrice*quantity) from #t
group by companyname

--alle Spalten des Select in Group by
--dann AGB entfernen und Aliase

---Umsatz pro Land und Stadt des Kunden

--Ausgabe: Land Stadt Umsatz

--Land, Stadt , Umsatz

select country as Land, city, sum(UnitPrice*quantity) 
from #t
group by country , city
order by Country, city


--aber nur noch die, die mehr als 100000 Umsatz hatten

select country as Land, city, sum(UnitPrice*quantity)  as Umsatz
from #t
group by country , city having sum(UnitPrice*quantity) > 100000
order by Country, city


--Pro Land und Jahr...
select country, YEAR(orderdate), sum(UnitPrice*quantity)  as Umsatz
from #t
group by Country, YEAR(OrderDate)
order by Country



---Wieviele Kunden gibt es pro Land und Stadt
--Customers

select country, city , COUNT(*) from Customers
group by Country, city
order by 1,2 asc


--Wieviele sind in UK?
--Wieviele sind Bonn?
--Wieviele sind es weltweit?

select country, city , COUNT(*) from Customers
group by Country, city with cube --160
order by 1,2
--jede Variante

select country, city , COUNT(*) from Customers
group by Country, city with rollup --91
order by 1,2

select country,  COUNT(*) from Customers
group by Country 

select   COUNT(*) from Customers

order by 1,2
--nach Hierarchie

select country, city , COUNT(*) as Anzahl
into #t2
from Customers
group by Country, city with rollup --91
order by 1,2
--Zwischenergebnisse

select * from #t2 where Country is null and City is null
