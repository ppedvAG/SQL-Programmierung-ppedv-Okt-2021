use Northwind;
GO

select companyname, country, city
into KundenEU 
from customers
where 
	Country IN ('France', 'Italy', 'Germany', 'Austria')
--27 Datensätze! von 91

--ACCESS Problem.. Wenn verschied Versionen einer Tabelle existieren
--wie kann ich gleiche DS finden oder unterschiedliche

update KundenEU set City = 'Münster' 
where CompanyName = 'Alfreds Futterkiste'

insert into KundenEU values ('ppedv AG', 'Germany', 'Burghausen')


select * from Customers
select * from kundeneu


---Fall 1: gleiche Datensätze in beiden Tabellen


--Idee:
--Hashfunktion geht pro Spalte--man bräcuhte den Haswert der gesamten DS

--Idee: per join über ID.. leider nein, weil sich der DS evtl nur in der Stadt unterscheidet
--JOIN über alle Spalten, was wenn 100 Spalten
select * from Customers c
	inner join KundenEU keu 
		on 
			c.CompanyName!=keu.CompanyName
			and
			c.City = keu.city
			and
			c.Country = keu.country


--Idee 2: da gibts was dafür ;-)
select companyname , city, country from kundeneu
intersect
select companyname , city, country from customers --26 stimmt


select companyname ,  country from kundeneu
intersect
select companyname ,  country from customers --27, weil die City keine Rolle spielt


--Fall 2: und welche sind unterschiedlich?

--Idee Join.. aber bei 100 Spalten ziemlilch irre

--Idee: except.. Wichtig Reihenfolge
select companyname , city, country from kundeneu
except
select companyname , city, country from customers --2 stimmt
--der neue und der geänderte

select companyname , city, country from customers --91-27
except
select companyname , city, country from kundeneu --64 Stück
