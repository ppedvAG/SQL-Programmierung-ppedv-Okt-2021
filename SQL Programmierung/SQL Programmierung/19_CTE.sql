/*

CTE 


hilft bei Rekursiven Auflösungen
kann Unterabfragen umschreiben




*/

with ctename (Spalte1, Spalte2,..)
as
(select ....)
select * from ctename

with cte (Land, Stadt)
as
(
select country, city from customers)
select COUNT(Stadt) from cte

--Anzahl der Bestellungen pro Ang im Schnitt

select orderid, employeeid from orders


select avg(anzahl) from 
(
select employeeid, COUNT(orderid) as anzahl from orders
group by employeeid) t



with cte (AngId, Anzahl)
as
(select employeeid, COUNT(*) from orders group by EmployeeID)
select avg(Anzahl)  from cte


--Rekursion auflösen

select employeeid, lastname, reportsto from employees



1 Davolio 2 Fuller
2 Fuller  0 Chef
3 Leverling 2 Fuller
7 King 5 Buchanan 2 Fuller 

--gib mir alle Knechte der 3 eben aus

--früher : SPALTE Hierarchie  zb 

7 King 5 2,5
119 Schmitt  10  2,5,88,10


with cte (SP, SP, SP)
as
(
select ... Suche nach Chef -- Anker  is null bei Reportsto
UNION ALL
select ... Suche nach allen die den Chef haben
		  EMPL JOIN CTE
)
select * from cte;


with cte
as
(
select lastname, employeeid, reportsto from Employees 
				where ReportsTo is null
UNION ALL
select e.lastname, e.employeeid, e.reportsto 
from 
	employees e inner join cte on cte.employeeid = e.reportsto
)
select * from cte


;with cte (FamName, AngID, Rang)
as
(
select lastname, employeeid,1 as RANG from Employees 
				where ReportsTo is null
UNION ALL
select e.lastname, e.employeeid, Rang+1 from employees e
			inner join cte on cte.ANgId = e.reportsto
)
select * from cte where Rang = 3


LASTNAME, EmpID, RANG







