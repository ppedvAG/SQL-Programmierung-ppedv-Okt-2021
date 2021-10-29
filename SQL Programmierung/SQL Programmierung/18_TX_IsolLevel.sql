/*
begin tran

commit  | rollback

alles was in der TX stattfindet INS UP DEl etc.. 
..wird gesperrt bis TX vorbei

TX sollen daher sehr kurz ausfallen



Wieviel sperrt er denn:

Falls IX evtl die Zeile 
Falls etwas mehr geändert wird, dann auch die Seiten
Falls mehr Seiten betroffen sind, dann auch Blöcke
Falls kein IX oder sehr viele Seiten, dann Tabelle
Fall Partition , dann auch die eine partition


Aber egal wie: Sobald wir auf das Niveau Seiten werden mehr 
DS gesperrt als du verwendest

--------------
Xfdsfsdffdsdf
Xfsdfsfsfsdfs
X3434234242423
Xrwewrrwe
we
rwe
rwr
----------------X Seite


4 ISOLATION LEVEL
READ COMMITTED  ..erst lesen wenn commit
READ UNCOMMITTED ..auch lesen während Änderung

Ändern hindert Lesen

Lesen hindert Ändern

*/
use northwind
GO

begin tran
select * from customers
update Customers set City = 'Münster' 
	where CustomerID = 'ALFKI'
select * from customers

rollback

--2 . Session
select * from Customers where CustomerID = 'ALFKI' --dauert



--REAPEATBLE READ

set transaction isolation level REPEATABLE READ


begin tran

select * from customers


--während dessen keine Änderung in anderen Sessions
--Idee..keine darf Daten ändern die ich eben gelesen habe

--betrifft nur DS die man gelesen hat

--betrifft aber nicht den INSERT

--wenn man den INS auch verhindern will


set transaction isolation level SERIALIZABLE
--in anderen Session kein INS und kein UP


--es gibt noch eine bessere Lösung

rollback

--STD Verhalten der DB ändern auf Snapshotisolation
use master; --alle runter von DB
GO
ALTER DATABASE [Northwind] SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
ALTER DATABASE [Northwind] SET ALLOW_SNAPSHOT_ISOLATION ON


begin tran
update customers set city= 'XXXX'
where customerid = 'ALFKI'

rollback



--Zeilenversionierung kopiert die OrgDS in die Tempdb
--es werden keine Sperren mehr gestetzt bei Ändern (Lesen ist erlaubt)
--man liest den Org DS aus der Tempdb
--bis die Ändernung bzw TX abegschlossen wird..



set transaction isolation level read committed
select * from Customers where CustomerID = 'ALFKI'--  dauert...

set transaction isolation level read uncommitted
select * from Customers where CustomerID = 'ALFKI'

--bekommt den aktuelle Wert, auch wenn noch nicht committed

--

