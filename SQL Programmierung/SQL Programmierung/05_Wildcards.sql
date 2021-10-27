/*
Wildcards


where = < >  <= =>  between in != like not like is null is not null

nur das like beherrscht Wildcards


where spalte like:
					% steht für beliebig viele unbekannte Zeichen
					_ steht für genau ein Zeichen	
					[] stehen für genau ein Zeichen
						und können einen Wertebereich abbilden
						[0-5] [d-g] [acgh]
				
						patterns

Wildcards sind mischbar


*/
--Alle Bestellungen, die eine Customerid haben, die mit T endet
select * from orders
	where CustomerID like '%t'

select * from orders
	where CustomerID like 't%'


select * from orders
	where CustomerID like '%t%' --t das irgendwo auch zu Beginn oder am Ende

--Disco Problem
--der vorletzte Buchstabe ist ein E im Namen der Customerid

select * from orders where CustomerID like '%e%' --irgendow ein e


select * from orders where CustomerID like '%e_' --Lösung


--alle Bestellungen, wo Customerid 
--beginnt   mit A od B od C od D
--und endet mit A od B od C od D

--ein Teil sehr leicht
select * from Orders
	where
		customerid < 'E'
	order by customerid

--aber die mit abcd enden


	
select * from orders 
where customerid like '%a'
	 or
		customerid like '%b'
	or
		customerid like '%c'
	or
		customerid like '%d'


--und jetzt mit UNION

--besser

select * from orders
where 
		CustomerID like '[a-d]%[a-d]'


--Tabelle für Bankkarten--> PIN
--über Handy darf die PIN geändert werden
--durch dummen Fehler waren auch Buchstaben erlaubt!!!!


--PIN a12b

--Spalte PIN .. Suche nach alle PINS die falsch sind oder korrekt

select * from bank where pin like '[1-9]%[1-9]'

--was wäre bei 1xx8.. korrekt

select * from bank where pin like '[0-9][0-9][0-9][0-9]'

--was wäre bei : 0110 ..

--andere Idee: > 1    0002 klappt nicht 


select * from orders 
	where CustomerID like '[adgrt]%'-- eine auswahl an Zeichen statt Bereich


	where sp like 'A%[1-9]_X'


--Wie suche ich nach einem % Zeichen?
--Suche nach dem Kunden mit einem % im Namen
select * from Customers where CompanyName like '%[%]%'


--Suche nach dem Kunden mit einem '  im Namen
--select * from Customers where CompanyName like '%[']%' --geht nicht


select * from Customers where CompanyName like '%''%' --geht 

--wir suchen alle aus Customers, die in Region nicht drin stehen haben

select * from Customers where Region = NULL --warum keinen??

--weil jede math Operation und Vergleich mit NULL zu NULL führt

select * from Customers where Region is NULL 






