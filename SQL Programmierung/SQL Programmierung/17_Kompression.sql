/*
Ziel: weniger IO --> weniger RAM--> weniger CPU

-- Fall 1 : Partitionieren

Kompression ;-)

Seitenkompression und Zeilenkompression

ZKompression: char(50)  'Otto          ' 50
-->                      'Otto'  4

mehr "kleinere" DS pro Seiten


Seitenkompression
setzt zuerst die Zeilenkompression
Präfixkompression 
Sch = 1
Schweden
Schweiz
Schwenegal

--> normalerweise : ca 40 bis 60%


*/
set statistics io, time on
select * from ku1 where id = 117-- 24230.. 125ms 125ms


ALTER TABLE dbo.ku1 REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = PAGE);   


select * from ku1 where id = 117--6948, Seiten-- Dauer 350ms
--Trotzdem cool weil 6948 Seiten in RAM kamen und nicht 24230


--Seiten kommen 1:1 in RAM !!!

--Der Client bekommt dekomprimierte DAten.. das muss die 
--CPU leisten


--Es lassen sich auch Partitionen komprimieren
--Thema Archivierung muss dann wohl nicht immer sein


select * into ku2 from ku1 --nicht komprimiert

--Abfrage auf ku1 und auf ku2 
--Abfrage mit where , mit AGG
select top 3 * from ku1


--Summe(fracht) pro Firma
--aber die wo Uniprice < 9


select companyname, SUM(freight) from ku1
where 
	unitprice < 9
group by companyname


--NIX_UP_incl_cnfr -- 1299   30ms DAuer und CPU


select companyname, SUM(freight) from ku2
where 
	unitprice < 9
group by companyname --24227,  230ms Dauer

--CSIX Columnstore IX ... man musste nichts weiter ausfüllen

select companyname, SUM(freight) from ku2
where 
	unitprice < 9
group by companyname  --Seiten 0  16 / 2 ms Dauer


--im Prinzip egal was ich suche.. immer pfeilschnell!!
--und das ohne neue IX zu  erstellen!!!!
select companyname,city, SUM(freight) from ku2
where 
	lastname = 'Davolio'
group by companyname , city --Seiten 0  16 / 2 ms Dauer

--Tabelle hat nur noch 3,6 MB statt 200MB

ALTER TABLE dbo.ku2 REBUILD PARTITION = ALL  
WITH (DATA_COMPRESSION = COLUMNSTORE_ARCHIVE);   
--und nun 2,9 MB

select 200/2.8

--naja.. auch im Speicher (RAM)

--!!!! mit weniger IO und weniger RAM und weniger CPU ...schneller


--why not????
select * from sys.dm_db_column_store_row_group_physical_stats

--INS schiebet neue DS in einen delta Store = HEAP
--Sauhaufen

--DEL: markiert nur als gelöscht... aber es wird vorerst nichts gelöscht

--UP = INS un DEL