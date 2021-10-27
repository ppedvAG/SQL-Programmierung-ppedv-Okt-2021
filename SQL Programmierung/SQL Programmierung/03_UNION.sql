--Im Gegensatz zum JOIN  bringt der UNION die DS untereinander
--und nicht nebeneinander

--UNION ist ergebnisorientiert

select companyname from customers
UNION
select lastname from employees


select 100
union
select 200

--der Alias wird im ersten Slect festgelegt

select 100
union
select 200 as SP


select 100 as SPX --!!
union
select 200 

--immer gleich viele Spalten
Select 100, 200
union
select 300 --error


Select 100, 200
union
select 300, NULL --geht


--und ein komtablibler Datentyp
select 100
union 
select 'A'--Error


select '100'
UNION
select 'A'

--oder direkt konvertieren
select CONVERT(varchar(50), freight) from Orders
UNION
select companyname from customers


--UNION macht automatisch distinct.. filter von doppelten Zeilen
select 100
UNION 
select 100
UNION 
select 100
UNION 
select 200
UNION 
select 200

select distinct country from customers


--UNION ALL sucht keine doppelten
--vermeide UNION, wenn es keine doppelte Ergebnisse geben kann

select 100
UNION ALL
select 100
UNION ALL
select 100
UNION ALL
select 200
UNION ALL
select 200


--In der Tabelle orders gibts Frachtkosten

select * from orders

--min 0.02  max 1007

--A Kunden: unter 100 
--C Kunden: über 500
-- alle anderen sind B Kunden

--Liste der Customerid, Freight, Bewertung (A B C)

--MIT UNION ALL

select Customerid, freight,'A' as Typ from orders where Freight < 100
UNION ALL
select Customerid, freight,'B' from orders 
		where Freight between 100 and 500
UNION ALL
select Customerid, freight,'C' from orders where Freight > 100

--weitere Idee.. nur die B Kunden
--Unterabfragen

select * from 
(
select Customerid, freight,'A' as Typ from orders where Freight < 100
UNION ALL
select Customerid, freight,'B' from orders 
		where Freight between 100 and 500
UNION ALL
select Customerid, freight,'C' from orders where Freight > 100
) t
where t.Typ='B'
