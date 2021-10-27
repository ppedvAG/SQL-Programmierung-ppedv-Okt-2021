/*
temp Tabellen sind physikalische Tabellen

2 Sorten von temp Tabellen

..leben nicht ewig

#tabelle: lokale temp Tabelle
die #tabelle gibts nur in der Session, in der sie erstellt
--also zb SID = 72, dann nicht in Session 101


##tabelle: globale temp Tabelle
die temp Tabelle gibt es auch in anderen Sessions

temporär???
temp Tabellen existieren solange bis:
--der Ersteller sie löscht
--der Ersteller seine Session schliesst
--bei globalen: was wenn jemand eine Abfrage ausführt
				die ca 5 min dauert..
				und der Ersteller schliesst bereits nach 5 sek seine Session
				die Abfragen lüft bis zu Ende und dann ist die ##t auch weg 
				aber andere können sie trotzdem nicht verwenden


Was kommt denn häufiger in der Praxis vor:

#t fast immer die 
##t  kein Einfluss wann wie wie lange


die #tablle liegen in der DB tempdb

Idee für temp tabellen: Zwischenergebnisse wegschreiben
     um nicht jedes mal neu Abfrage auszuführen
	 aber: die Ergebniszeilen werden nicht aktualisiert

	 Umfangreiche JOINS 

	 Tempdb ist auf Geschwindigkeit optimiert (Admin)


	 Komplexe Abfragen können durch #tabellen extrem vereinefacht werden
	 besser prozedural lösen

	 also Einsatzgebiet wohl ehere kurzzeitig



*/



select * into #t1 from sysfiles

select * from #t1

select * into ##t1 from sysfiles

select * from ##t1

----
--wer ist der beste Angestellte
--und wer ist der schlechteste Angestellte
--gut: wer die geringsten Frachkosten in Summe hat
--schlecht: der in Summe die höchsten Frachtkosten

select employeeid, freight from orders

--2 199999
--4  400

--zuerst: Liste alle Ang (employeeid) auf und deren Summe der Frachtkosten

select EmployeeID, sum(freight) as Summe from orders
group by EmployeeID
order by Summe

--wenn man sortiert und dann steht einer ganz oben...
--dann halt nur den einen ausgeben

--geringsten Frachtkosten
select top 1 EmployeeID, sum(freight) as Summe from orders
group by EmployeeID
order by Summe asc


--mit höchsten Frachtkosten
select top 1 EmployeeID, sum(freight) as Summe from orders
group by EmployeeID
order by Summe desc

--Cool ..ist ja einfach:-)
--Idee UNION

--geringsten Frachtkosten
--geht nicht wg 2 mal order by im UNION

select top 1 EmployeeID, sum(freight) as Summe from orders
group by EmployeeID
order by Summe asc
UNION ALL
select top 1 EmployeeID, sum(freight) as Summe from orders
group by EmployeeID
order by Summe desc


select * from 
(
select top 1 EmployeeID, sum(freight) as Summe from orders
group by EmployeeID
order by Summe asc
) t1
UNION ALL
select * from 
(
select top 1 EmployeeID, sum(freight) as Summe from orders
group by EmployeeID
order by Summe desc
) t2





--besser prozedural.. schrittweise
select top 1 EmployeeID, sum(freight) as Summe
into #bestbadAng
from orders
group by EmployeeID
order by Summe asc


select * from #bestbadAng

insert into #bestbadAng
select top 1 EmployeeID, sum(freight) as Summe
from orders
group by EmployeeID
order by Summe desc


select * from #bestbadAng