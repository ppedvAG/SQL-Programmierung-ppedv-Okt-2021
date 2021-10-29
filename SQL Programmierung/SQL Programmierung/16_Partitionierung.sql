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




