use Northwind;

--Gib alle DS aus KU wieder aus dem Jahr 1996

--Orderdate
--belibt beim SCAN trotz idealen IX

set statistics io, time on
--SCAN
select freight, customerid from ku
	where orderdate like '%1996%'
	--9518-- 6 Sek und 3,5 sek

select freight, customerid from ku
	where datediff(yy,orderdate, getdate()) >=65

select freight, customerid from ku
	where orderdate between '1.1.1996' and '31.12.1996'

--Wenn im Where um eine Spalte eine f() ist, 
--dann wird das immer ein SCAN
--da jede Zeile jeden Wert errechnen muss
--Ziel.. die F() muss auf die andere Seite



--alle Ang die im Rentenalter sind: 65
--Birthdate in Employees
--die Abfrage muss auch morgen , in 100 Tagen oder 2 Jahren 
--genauso funktionieren

select DATEDIFF --errechnetg eine Diff in Int (Jahr, Tage, Stunde)
select DATEADD (zu einen DAtum etwas dazurechnen

select DATEADD(yy, 5, '1.1.1996')
select DATEDIFF(yy, '1.1.2001', '3.4.2019')

select * from Employees	
	where BirthDate > DATEADD(yy,-65,getdate())


select * from Employees	
	where BirthDate > '1.1...' --..gut wenn auch nicht dynmisch



--Aufpassen bei Datum

--alle DS der Orders aus dem Jahr 1997

select * from Orders
	where OrderDate 
				between '1.1.1997' and '31.12.1997 23:59:59.999'
--1998???

--der datetime wird intern als int gespeichert
--allerdings ist der dann ungenau (ca 2 bis 3 ms Varianz)

select * from Orders
	where YEAR(OrderDate) = 1997

	--evtl im DB Design statt datetime ein date
	--eine Spalte mit Jahr  oder Quartal

--andreasr@ppedv.de schick an alle ppedvler ein Email
--like '%ppedv.de'

--2 Spalten : PreMEail EmailDomain
			andreasr	ppedv.de




select * from Orders
	where OrderDate 
				between '1.1.1996' and ''



--NGR IX gut bei rel wenigen Ergebniszeilen
--Variablen können eigt nur geschätzt werden 
--vor allem wenn sie mit Abfragen gefüllt werden
--Es kann also durchaus sein, dass ein Code mit Variablen 
--schlechter läuft als ohne...

declare @Heute as datetime = getdate()
declare @Damals as datetime
select @damals = dateadd(yy,-65,@heute)

select * from employees 
	where birthdate <= @damals

	--HEAP kein IX
select top 3 * from ku

--TABLE SCAN
select * from ku where ID < 2

--mit NGR IX auf ID-- IX SEEK mit Lookup
select * from ku where ID < 2


--Schlaumaier: cooler weil schneller mit Proz

create or alter proc gpdemo9 @par1 as int
as
select * from ku where id < @par1;
GO


exec gpdemo9 2


dbcc showcontig('ku') --24000


select * from ku where ID < 2 --4 Seiten 0 sek

select * from ku where ID < 1000000 --4 Seiten 0 sek --51000
-- 3406 ms, verstrichene Zeit = 29577 ms.

--?? Warum lesen wir 51000 Seiten, wo die Tabelle nur 24 000 hat??


exec gpdemo9 2 --4 Seiten 0 sek


exec gpdemo9 1000000 -- Seiten 0 sek
--wtf: 1026706 Seiten ???????
--Drecksding macht immer noch Seek

--wie erkenn ich sowas.. und was ich dann besser

--Grenze lag etwa bei 11500
--Fragst du oft unter 11500 ab-- dann SEEK
--dagegen oft über 11500 dann besser scan

--Plan ändern auf SCAN, weil häufiger 
--Abfragen auf Werte über 11500


dbcc freeproccache -- damit leeren wir den Proz cache alle DBS
--neu ab SQL 2016 .. nur in der DB
ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;

exec gpdemo9 1000000



exec gpdemo9 2

--wie hätte ich das sehen können

--Wir haben den Abfragespeicher in der DB aktiviert
--QueryStore

--Was wäre besser..?

--mach keine benutzerfreundlichen Prozeduren!!!
--eine , wenige oder alle

exec gpKdsuche 'ALFKI'
exec gpKdsuche 'A'
exec gpKdsuche 


create proc gpkdsuche @id int
as
if @id<11500
	exec procwenigewerte --seek
else	
	exec procvielewerte --SCAN


--auch ein nogo

create proc gpdemo10 @wert int
as
If @wert = 10
select * from orders where OrderID < @wert
else
select * from products where unitprice < @wert


exec gpdemo10 5 --optimier teil 1.. teil 2 wird grob geschätzte




