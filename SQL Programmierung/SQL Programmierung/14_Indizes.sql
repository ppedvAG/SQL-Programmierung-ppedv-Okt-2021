select top 3 * from kunden

set statistics io, time on
select * from kunden 
where customerid = 'aduad'


/*
wie Telefonbuch
IX bei where

 NGR Index .. wie Telefonbuch
	best Datenwerte werden rauskopiert in neue Seiten
	und dort sortiert abgelegt
	Auf diese abgelegten Seiten wird ein Baum generiert
	der bei der Suche hilft
 pro Tabelle auch 1000 Stück
 Wann ist der gut?
	bei rel wenigen Ergebnissen  kann auch 1 % sein
	typisch: bei = ; ID bzw PK
	LookUp ist sehr teuer
	daher versucht man, alle Infos in den IX zu bringen
	damit er immer ein Seek machen kann

 GR Index = Tabelle in immer sortierter Form
 nur 1 mal pro Tabelle
  Wann ist der gut?
	Wenn rel viele Zeilen rauskommen  bzw Bereichsabfragen
	typisch. PLZ, Quartal, Jahr
	auch bei rel geringen Ergebnissen 

HEAP durchsuchen: Table, SCAN

SCAN a bis z suchen
SEEK herauspicken



GR IX und NGR IX

zusammengestzter IX .. gut bei mehr Where Spalten

IX mit eingeschl Spalten.. belasten den Baum und es geht um die SELCT Baum

eindeutiger IX.. Wert im IX Schlüsselspalten (where) nur 1 mal


--durch Indizes können gezielt Sperren auf DS gemacht werden
--wir wissen ja 1:704:02  

--wenn wir mehr ändern, dann kann das Niveau der Sperre auf Seite steigen


*/


select * from customers

select * from orders


insert into Customers (CustomerID, CompanyName)
values
					 ('ppedv', 'Fa ppedv AG')




SELECT c.CustomerID, c.CompanyName, c.Country, c.City, od.OrderID, o.Freight, o.OrderDate, od.UnitPrice, od.Quantity, p.ProductName, e.LastName
into ku
FROM   dbo.Customers AS c INNER JOIN
         dbo.Orders AS o ON c.CustomerID = o.CustomerID INNER JOIN
         dbo.[Order Details] AS od ON od.OrderID = o.OrderID INNER JOIN
         dbo.Products AS p ON p.ProductID = od.ProductID INNER JOIN
         dbo.Employees AS e ON e.EmployeeID = o.EmployeeID

--solange bis 1,1 Mio DS
insert into ku
select * from ku

set statistics io, time on
--HEAP + eindeutiger Wert, aber kein IX
alter table ku add id int identity

--kein IX--> Plan: TABLE SCAN
select ID from ku where ID = 100 --54000 Seiten

--muss schneller sein..
-- Nicht gr IX auf ID

--Plan jetzt: SEEK  IX SEEK
select ID from ku where ID = 100 --3 Seiten 0 sec

--IX SEEK aber Anruf
select ID, freight from ku where ID < 11500 --ab ca 11500 T SCAN

--was kann man denn tun, um nicht anrufen zu müssen

--IX mit den Werten inklusive
--NIX_ID_FR -- zusammengesetzter IX
--Problem: max 16 Spalten
select ID, freight from ku where ID < 11500

select ID, freight from ku where ID < 900000

--die Spalten des zusm. Index braucht man nur dann,
.-- wenn sie im where gefragt werden

--besser geht so:
--IX mit eingeschloss. Spalten

CREATE NONCLUSTERED INDEX [NIX_CITY_INKL] ON [dbo].[ku]
(	[City] ASC )
INCLUDE([Freight],[ProductName],[id]) 
GO



select ID, freight, productname from ku
	where City = 'Berlin'


select country, city, SUM(unitprice*quantity) as Umsatz
from ku
	where Lastname = 'Davolio' and OrderID < 10300
	group by Country, city


CREATE NONCLUSTERED INDEX [NonClusteredIndex-20211028-150447] ON [dbo].[ku]
(
	[OrderID] ASC,
	[LastName] ASC
)
INCLUDE([Country],[City],[UnitPrice],[Quantity]) 



CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[ku] ([LastName],[OrderID])
INCLUDE ([Country],[City],[UnitPrice],[Quantity])


--bei OR macht der SQL schlapp

select country, city, SUM(unitprice*quantity) as Umsatz
from ku
	where Lastname = 'Davolio' OR OrderID < 10300
	group by Country, city




--Welche Indizes sind überflüssig und welche fehlen?

--Zuviele Inidzes sind schlecht?

--jeder INS UP DEL ist erst dann fertig, wenn die IX stimmen

--Überflüssige

--DMV
---os = SQL Server
--db die Datenbank

select * from sys.dm_db_index_usage_stats

select db_id('Northwind') --5

--ObjectID = Tabelle
--INdex_ID 
	--   0 = HEAP
	--   1 = CL IX
	--   >1 = N GR IX

	select * from sys.indexes


	--aufpassen: nach Neustart wird das resettet
select object_name(i.object_id) as TableName
      ,i.type_desc,i.name
      ,us.user_seeks, us.user_scans
      ,us.user_lookups,us.user_updates
      ,us.last_user_scan, us.last_user_update
  from sys.indexes as i
       left outer join sys.dm_db_index_usage_stats as us
                    on i.index_id=us.index_id
                   and i.object_id=us.object_id
 where objectproperty(i.object_id, 'IsUserTable') = 1
go

--Fehlende Indizes
select p.query_plan
   from sys.dm_exec_cached_plans
        cross apply sys.dm_exec_query_plan(plan_handle) as p
  where p.query_plan.exist(
         'declare namespace
          mi="http://schemas.microsoft.com/sqlserver/2004/07/showplan";
            //mi:MissingIndexes')=1
go


--besser QueryStore: repräsentativ-.-> typischer Workload
--auch nach Neustart sind die Pläne noch da
--Häufigkeit
--grafische Berichte


SELECT
    SUM(qrs.count_executions) * AVG(qrs.avg_logical_io_reads) as est_logical_reads,
    SUM(qrs.count_executions) AS sum_executions,
    AVG(qrs.avg_logical_io_reads) AS avg_avg_logical_io_reads,
    SUM(qsq.count_compiles) AS sum_compiles,
    (SELECT TOP 1 qsqt.query_sql_text FROM sys.query_store_query_text qsqt
        WHERE qsqt.query_text_id = MAX(qsq.query_text_id)) AS query_text,    
    TRY_CONVERT(XML, (SELECT TOP 1 qsp2.query_plan from sys.query_store_plan qsp2
        WHERE qsp2.query_id=qsq.query_id
        ORDER BY qsp2.plan_id DESC)) AS query_plan,
    qsq.query_id,
    qsq.query_hash
FROM sys.query_store_query qsq
JOIN sys.query_store_plan qsp on qsq.query_id=qsp.query_id
CROSS APPLY (SELECT TRY_CONVERT(XML, qsp.query_plan) AS query_plan_xml) AS qpx
JOIN sys.query_store_runtime_stats qrs on qsp.plan_id = qrs.plan_id
JOIN sys.query_store_runtime_stats_interval qsrsi on qrs.runtime_stats_interval_id=qsrsi.runtime_stats_interval_id
WHERE    
    qsp.query_plan like N'%<MissingIndexes>%'
    and qsrsi.start_time >= DATEADD(HH, -24, SYSDATETIME())
GROUP BY qsq.query_id, qsq.query_hash
ORDER BY est_logical_reads DESC
GO
