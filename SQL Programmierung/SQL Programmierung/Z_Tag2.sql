/*
DB Design


Normalisierung
1 NF 2 NF ... --> negativer Aspekt: viele JOINS dafür keine Redundanz
---aber Redundanz ist schnell

Wo finden wir häufig Redundanz in unsererm TSQL Code?
--zusätzliche redundante Spalten wie Rechnugssumme
--temp Tabellen  vs Sicht (keine redundante Daten)
--tmpTabelle.. reale fixe Tabelle 

--temp Tabellen leben
--solange die Session noch steht oder drop table
--lokal (nur in der Ersteller Session erreichbar)
--oder global (alle können darauf zugreifen)




--Wenn Spalten aus verschied Tabellen nebeneinander stehen sollen
--dann brauche ich einen JOIN
--sollten aber die Datensätze untereinander stehen , dann brauch ich 
--einen UNION
--PIVOT Zeilen zu Spalten oder Spalten zu Zeilen













*/



------------------UNION
--Ausgabe Land und Stadt (Employees und Customers)
--wir brauchen alle Länder und Städte in denen entweder Kunden
--oder Angestellte sind


select country, city, 'K' from customers
UNION --filtert doppelte Zeilen aus dem Ergebnisse
select country, city, 'A' from employees
order by 1,2

--Welche Land Stadt Kombi gibts in Customers aber nicht in Employees
select country, city from customers
except
select country, city  from employees

--alle Ang die in einer Land Stadt Kombi sind, an denen kein Kunde ist
select country, city from  employees
except
select country, city  from customers

--wo sind Kunde und Ang am gleichen Ort und Land
select country, city from  employees
intersect
select country, city  from customers




--SICHTEN: haben keine Daten, aber verhalten sich wie Tabellen
--gib bei Sichten immer an: with schemabinding
--kein Stern, exakte Angabe der Tabellen, Sicht hat immer korrekte Ergebnisse
--keine Fehler weil Spalten gelöscht wurde

select .dbo... .Customers
--dbo ? 


create table it.mitarbeiter (id int, itmitarbeiter int)


create table fe.mitarbeiter (id int, itmitarbeiter int)

--Schema = wie Ordner

--jeder User hat ein Std Schema (default = dbo)
--Schemas könne auch rechte haben






