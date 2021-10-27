/*
select sp, 'text', Mathe, (unterabfragen), Alias
from
	inner|left|right|cross join Tabelle on
where
group by ...having
order by
*/
use Northwind;
GO

select country as land, city from Customers c
where c.City like  'A%'
order by c.city


--Warum kann ich den Alias im Order by verwenden, aber nicht im where!!!

select country as land, city from Customers c
where land = 'UK'--and land='USA'
order by land

--wieso kann man einen Alias auch nicht im Group by verwenden
select country as land, COUNT(*) as Anzahl
from Customers
where
group by Land
order by land


select country as land, COUNT(*) as Anzahl
from Customers
group by Land having anzahl >0
order by anzahl


select country as land, COUNT(*) as Anzahl
from Customers
group by country having COUNT(*) >0
order by anzahl


--Logischer Fluss

--FROM (ALIAS der Tabellen) --> JOIN (Alias) -->
--> where (alias der Tabellen)-->
--> GROUP BY --> HAVING  --> 
--> SELECT (ALiasnamen der Spalten, Berechnungen)-->
--> Order by -->DISTINCT | TOP  Ausgabe



select distinct | top

--aha.. daher darf ich folgendes nicht tun
--das ist schlecht

select country, COUNT(*) from customers -- 91 Zeilen
group by Country having Country = 'USA' --91 Zeilen
order by country

select country, COUNT(*) from customers -- 91 Zeilen
where Country = 'USA' --12 Zeilen
group by Country --nur noch USA gruppieren
order by country

--Tu nie etwas mit einem Having filtern, was ein where kann!
--Having sollte nur AGG filtern müssen


---JOIN
--Wenn Spalten nebeneinander stehen sollen dann join
--Wenn DAten untereinandenr dann UNION


--INNER Ergebnisse nur von beiden Seiten identisch

--LEFT von der linken Seite alle und von rechts die identischen




--was steht links vom Join
select * 
from Customers c left join orders o on c.CustomerID=o.CustomerID


--identisch
select * 
from orders o right join Customers c  on c.CustomerID=o.CustomerID


--cross join
--91 * 830
select * from Customers c cross join orders o

--wo könnte man denn einen cross join brauchen
--zB.. Menüs im Restaurant
--alle Varianten anzeigen lassen


--
select * from employees --9  Lastname

select lastname, city, country from Employees

--Ein Mitarbeiter ist krank... wir brauchen auf der Stelle 
--einen Ersatz: Merkmal .. gleiche Stadt gleiches Land

--Ausgaben: Lastname city,   Lastname, city
		--  Davolio  Seattle  Callahan Seattle
		--  Callahan Seatttle   Davolio Seattle


			
select e1.lastname, e1.city , e2.lastname, e2.city
from Employees e1 inner join Employees e2
	ON e1.City = e2.city
where e2.LastName != e1.lastname

--
	
--Liate aller Kunden und MItarbeiter und deren Wohnort und Land

--Kunde(name)| Mitarbeiter |Stadt, Land

ALFKI	Berlin	GER--aus Customers
Davolio Seattle Canada --aus Employees



select companyname from customers
UNION
select lastname from employees