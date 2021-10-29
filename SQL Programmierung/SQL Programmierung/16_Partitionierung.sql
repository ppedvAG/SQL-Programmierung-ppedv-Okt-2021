/*

Welche Tabelle liefert schneller das Ergebnis?

TAB A  10000
TAB B  100000

A und B sind absolut identisch (Spalten , Datentypen, Indizes, Stat)

ABFRAGE liefert 10 Zeilen (egal ob A oder B abgefragt)


--> kleinere Tabellen sind schneller!

--wieso machen wir Tabellen dann nicht kleiner?


--ähhh hmmm ??

--Wie

Idee1: statt einer großen Umsatztabelle--> u2021 u2020 u2019
aber: wie bekomme ich meine Abfrage select * from umsatz wieder laufen

--das geht




*/

use Northwind;
GO

create table u2021(id int identity, jahr int, spx int)

create table u2019(id int identity, jahr int, spx int)

create table u2018(id int identity, jahr int, spx int)

create table u2020(id int identity, jahr int, spx int)

--geht auch mit u2021KW03...
--geht auch UJan  UFeb


--Wie bekomme ich nun "UMSATZ" wieder

select * from umsatz --??

--ahhhhhh.. Sicht ..mit UNION ALL
create view UMSATZ
as
select * from u2021
UNION ALL
select * from u2020
UNION ALL
select * from u2019
UNION ALL
select * from u2018


select * from umsatz

select * from UMSATZ where jahr = 2019 --noch nix gewonnen

--Garantiesiegel!--> CHECK Constraint
--für jedes jahr wiederholen
ALTER TABLE dbo.u2021 ADD CONSTRAINT
	CK_u2021 CHECK (jahr=2021)

--im Plan nur noch eine Tabelle
select * from UMSATZ where jahr = 2021


select * from UMSATZ where id= 5 --wieder alle and jahr = 2021

select * from UMSATZ where id= 5 and jahr = 2021

--Idee nicht nachsehen zu müssen gibts auch noch wo anders
--  Datentyp: not null .. ein Suche nach null kostet nix

--Nachteile:

--geht ein INS UP DEL .. ja geht, aber:
------ nur wenn kein identity Wert mehr drin ist
-----PK muss drin sein und eindeutig über die Sicht (ID, JAHR)
-----

--error wg s.o
insert into umsatz (jahr, spx)
values (2020,  10)

--geht aber auch einfacher--komfortabler


--Salamitaktik auf der pyhsikalischen Ebene anwenden



--1. Dateigruppe
--2. Partitionierungsfunktion
--3. Part Schema
--4 Tabelle auf Schema legen


create table t1 (id int) ON [PRIMARY]
--PRIMARY = db.mdf 
--HOT   COLD  ?? hä??

create table messdaten (id int) on HOT
--HOT = dateiname.ndf



--4 Dateigruppen: 
-- Bis100  bis200   bis5000 rest


USE [master]
GO

GO
ALTER DATABASE [Northwind] ADD FILEGROUP [bis100]
GO
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'bis100daten', FILENAME = N'D:\_SQLDB\bis100daten.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [bis100]
GO
ALTER DATABASE [Northwind] ADD FILEGROUP [bis200]
GO
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'bis200daten', FILENAME = N'D:\_SQLDB\bis200daten.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [bis200]
GO
ALTER DATABASE [Northwind] ADD FILEGROUP [bis5000]
GO
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'bis5000daten', FILENAME = N'D:\_SQLDB\bis5000daten.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [bis5000]
GO
ALTER DATABASE [Northwind] ADD FILEGROUP [rest]
GO
ALTER DATABASE [Northwind] ADD FILE ( NAME = N'restdaten', FILENAME = N'D:\_SQLDB\restdaten.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) TO FILEGROUP [rest]
GO

-- Funktion

-----------100]----------------200]--------------------------------------- int

--    1				2						3

select f(117)---> 2

--kein solchen Unfug schreiben

create function fdingens(@zahl int) returns int
as
begin
If @zahl <=100 return 1
IF @zahl >200 return 3
else
return 2

end

--die part function kann auch date, datetime, varchar etc...
--die Grenze sind "harte" Grenzen.. kein Like etc Wildcards
create partition function fzahl(int)
as
range left for values(100,200)

--Test
select $partition.fzahl(117) --2


--Part Scheme--geht nur wenn f() und Dgruppen existieren

create partition scheme schZahl
as
partition fzahl to (bis100,bis200,rest)
---                   1     2      3



--Tabelle auf Schema

create table ptab (id int identity, nummer int, spx char(4100))
ON schZahl(nummer)


--Daten rein..

--Schleife mit 20000 DS

--zu errinnerung: tag 1 20000 mal Go mit der gleichen Datenmenge
--ca knapp unter 30 sek
--Tipp: tats Pläne ausschalten und stats ausschalten

--der GO muss ja immer Pläne erstellen, analysieren
--bei Go 20000 --> 20000 Batches mit jeweils 1 TX.. also 20000 TX


set statistics time, io off

--so nur 1 Batch und 1 TX
declare @i as int=1
begin tran
while @i<=20000
	begin
	
		insert into ptab (nummer, spx) values (@i, 'XY')
		set @i+=1 --set @i=@i+1
	
	end
commit

--schneller
--PLAN und STATS
set statistics io, time on
select * from ptab where id = 117
select * from ptab where nummer = 117 --deutlich besser

--cool
---------100--------200---------------------------------20000
select * from ptab where nummer = 1117  --braucht viel.. zu viel

--wie wollen den Bereich über 200 optimieren

--neue Grenze 5000

------------100-----------------200-----------5000---------------------
--    1				2					3				4

--Dgruppen, Tabelle, F(), Schema
--Tabelle mnuss nie geändert werden
--f(1117) -- 3
--f(51117) --> 4
--zuerst das Schem ändern.. muss wissen was mit Bereich 4 (f()) passieren soll

ALTER partition scheme schzahl next used bis5000 --wenn dann
--bis dato keine Änderungen...

select * from ptab where nummer = 1117 --19800 Seiten

--F() anpassen


ALTER partition function fzahl() split range(5000)

select * from ptab where nummer = 1117 --4800 Seiten ;-)

--Grenzen entfernen
--Tabelle, Dgruppen, F() , Schema
--nix Tabelle, nix Dgruppe, nix schema, nur F()

--Die Daten sind immer dort wo sie sein müssen!!!

----100-----200--------5000-------------------
--1     2

alter partition function fzahl() merge range (100)

select * from ptab where nummer =117


select * from ptab where nummer = 117

select * from ptab where id = 117

--Sperren können auch auf Niveau Part gemacht werden


--Wir wollen Archivierung haben
--Alte Daten raus in Archivtabelle verschieben
--Befehl für das Verschieben von DS? kein Move für DS--> INS DEL


--zuerst Archivtabelle

create table Archiv(id int not null, nummer int, spx char(4100))
ON bis200


alter table ptab switch partition 1 to archiv

select * from archiv
select * from ptab


--100MB/Sek
--1000MB --> 10sek
--real
--auch bei 100000000000MB --> ein paar ms

--die Archivtabelle muss dort sein (Gruppe) wo auch die Partition ist


--man kann IX auch auf Part legen


--Jahresweise
create partition function fzahl(datetime)--warum nicht date?
as
range left for values('31.12.2020 23:59:59.999','','')


--Kunden nach Namen einteilen

--A bis M   N bis R   S bis z

--A-------------------M]-------------------------------X-------------

create partition function fzahl(varchar(50))--warum nicht date?
as
range left for values('N','S')--wäre ok..

--was ist größer wie M... zb Maier

--macht Sinn ?  15000 Bereiche sind möglich
create partition scheme schZahl
as
partition fzahl to ([PRIMARY],[PRIMARY],[PRIMARY])

--ist auch schneller, weill alles kleiner beim SCAN
--allerdings bei gleichzeitigen Zugriffen wären mehr HDDs besser

--Wie bekomme ich die best Tabelle auf das Schema..

--eigtl dumme Geschichte...
