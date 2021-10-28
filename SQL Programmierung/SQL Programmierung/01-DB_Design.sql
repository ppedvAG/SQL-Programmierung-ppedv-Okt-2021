/*
Stichworte: 
Normalformen (1. 2. 3. BC 4. 5.)
--> Redundanz vermeiden

Redundanz ..ist super für Performance

--ZIEL: gezielt Redundanz

#tabelle temporäre sind redundante Daten

Primärschlüssel -1:N (Beziehung) -> Fremdschlüssel
Beziehung: schnellste einfachste Methode keine verwaisten Daten zu haben

SHOP:


KUNDEN
KdNr int identity
FamName varchar(50)
Vorname varchar(50)
Tel varchar(50)
PLZ int oder 01000 Berlin  --> char(5)
Strasse
HNr
Ort
Land
GebDatum


PRODUKTE
PrNr
Bez
Preis
Lagerbestand


Bestellung
BNr
KdNr
BDatum
LDdatum
Lieferkosten


1	10	5	10,00	13	2.2.2021	7.2.2021	4,99
1	15	1	5,00	13	2.2.2021	7.2.2021	4,99
1	99	100	7,90	13	2.2.2021	7.2.2021	4,99


BestDetails

BNr
PrNr
Menge
Preis

1	10	5	10,00	
1	15	1	5,00	
1	99	100	7,90
2	10	5	10,00
3   10	5	10,00

1  1
1  2


1 10 5 10,00
2 15 1	5,00

Datentypen: Otto

varchar(50)... 'otto'  4 
nvarchar(50).. 'Otto'   4*2  = 8
char(50)..     'Otto                                  '  50
nchar(50)      'Otto                                  ' 50*2= 100

datetime (ms)
datetime2 (ns)
date
time
smalldatetime (sek)
datetimeoffset (ns + Zeitzone)



1 MIO DS jeder DS hat 4100bytes--> wieviele Seiten?--> 1 MIO Seiten
==> 8GB auf HDD ==> auch 8 GB im RAM


1 DS 4000 + 1 DS 100bytes
1 MIO DS 4000--> 2 DS pro Seite --> 500.000 Seiten --> 4 GB
1 MIO DS 100--> 80DS pro Seiten --> 12500 Seiten --> 110 MB
--> 4,1GB auf HDD und 4,1 GB im RAM



weniger IO --> weniger CPU --> weniger RAM!!!





*/

delete Customers where CustomerID = 'FISSA'


/*

SQL speichert seine Datensätze in sog Seiten

1 Seite: 8192bytes fix unveränderlich
1 Seite: hat max Platz für 700 DS
1 Seite: hat Nutzlast von 8072 bytes (Kopf Anzahl der Slots , Nachfolgende Seiten)
1 DS kann max 8060 bytes haben (normalerweise)

Eine Seite wird 1:1 in RAM geladen!..auch wenn die Seiten nicht ganz voll sind!

Ziel : so wenig wie möglich Seiten!!!!

*/


create table t1 (id int identity, sp1 char(4100), sp2 char(4100))
--Fehler beim Erstellen oder Ändern der t1-Tabelle, weil die Mindestzeilengröße 8211 betragen würde, einschließlich 7 Bytes an internen Verwaltungsbytes. Dies überschreitet die maximal zulässige Größe für Tabellenzeilen von 8060 Bytes.

--? Aber warum kan ich dann einen text() Datentyp haben , er 2 GB hat



--was wenn ich für SP1 einen Wert von 4100bytes einfüge
create table t1 (id int identity, sp1 varchar(4100), sp2 char(4100))
--Wie kann ich Seiten messen?

create table t1 (id int identity, sp1 char(4100));
GO

set statistics io, time on 
--Messung Anzahl der Seiten
--Dauer in ms und CPU in ms

set statistics io, time off
--Messe nicht, wenn du es nicht brauchst
--schon gar nicht in Schleifen
--Messung gilt nur in dem Fesnter in dem sie aktiviert wurde


insert into t1
select 'XY'
GO 20000 --27 Sekunden --ginge auch evtl unter 1 Sek


set statistics io, time on 

select * from t1 where id = 100
--logische Lesevorgänge: 20000= Seiten.. wäre auch mit ca 30 Seiten gegangen
--mit Indiozes in 3 ;-)und 0 ms


--Messung der Auslastung der Seiten
dbcc showcontig('t1')
--- Gescannte Seiten.............................: 20000
--- Mittlere Seitendichte (voll).....................: 50.79%  KRANK!!

