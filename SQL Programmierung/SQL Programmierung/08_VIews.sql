/*
Sichten bzw Views

Sichten sin gemerkte Abfragen
enthalten keine Daten
verhalten sich aber wie Tabellen

join! INS ! UP ! SEL ! DEL ! Security!



create view VName
as
select ......

select * from VName where ...


Einsatzgebiet

komplexe Statements - weil umfangreich .. 10 Joins... deutlich weniger Schreibaufwand

Tipp: Tu nie eine Sicht zeweckentdfremden .. sprich :
Sicht enthält 10 Joins .. man braucht aber nur eine Tabelel für Ergebnis
--also nur für Abfragen die diese 10 (9) Tabellen auch wirklich brauchen

schreibe jede Sich mit schemabinding (exakte Formulierungen)

weitere Einsatzgebiet: Security
Sicht kann eig unabhängig von tabellen Rechte haben

Select * from Angestellte -- wurde verboten
select * from SichtAng --geht (aber Infos wie Gehalt und Religion fehlen)




*/

create view KundeUmsatz
as
select	 c.customerid, c.companyname, c.country	, c.city, --Customers
		 o.OrderID, o.freight, o.orderdate, --orders
		 od.unitprice, od.quantity, --oder details
		 p.productname, --products
		 e.Lastname --employees
from customers c 
inner join orders o				on c.customerid=o.customerid
inner join [Order Details] od	on od.OrderID=o.OrderID
inner join products p			on p.ProductID=od.ProductID
inner join Employees e			on e.EmployeeID=o.EmployeeID


--man muss jetzt keinen einzigen JOIN schreiben...cool
--immer aktuelle Daten
select * from kundeumsatz where CustomerID = 'ALFKI'

select * from (select .....from ..join join join ) kundeumsatz

--Frage 
--In welchem Land wohnt ALFKI?

set statistics io, time on
select country from KundeUmsatz where CustomerID = 'ALFKI' --12 mal


select distinct country from KundeUmsatz where CustomerID = 'ALFKI' --12 mal-- 76--0,04 SQL Dollar

select country from Customers where CustomerID = 'ALFKI'


--Aufpassen bei folgendem



create table slf (id int identity, stadt int, Land int)


insert into slf
select 10,100
UNION all
select 20,200
UNION all
select 30,300+

select * from slf

create view vdemo
as
select * from slf

select * from vdemo --alle Spalten ID STadt Land

alter table slf add Fluss int
update slf set fluss = id *1000


select * from vdemo --Fluss fehlt
--anscheinden intreressiert der * nicht

alter table slf drop column Land

select * from vdemo --falsches Ergbenis.. es kommt Land obwohl Kand nicht mehr exisitiert
--zudem die Werte von Fluss in Land


--ein Stern in der Sich t= Katastrope.. Warum: weil er sich die Spaltenbez merkt
--Nie ein * in Sichten!!!

.--kann man verhindern wenn man das macht
alter view vdemo with schemabinding --penible genau Angabe notwendig
as
select id, stadt, fluss from dbo.slf

--cool

alter table slf drop column Stadt --das geht nicht mehr