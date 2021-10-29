/*


a)SEL   b)SICHT   c)PROZ   d)F()

--langsam-------------> schnell
f()---> SEL|SICHT ---> PROZ

Prozedur ist schnell, weil der PLan vorkompiliert ist
und auch nach Neustart vorhanden ist


Messbar: set statistics time on --> Ananylse und Kompilierzeit
--Eigt 0

Ist aber auch der Nachteil: Was wenn ein anderer Plan pl�tzlich besser w�re

Plan? Besser und schlechter

SCAN geht alles durch
SEEK holt eien direkt heraus  (herauspicken)

*/


--Wieso sch�tzt SQL Server vorab die Anzahl der Zeilen
--und das ziemlich gut

--damit er den richtigen IX w�hlen kann 
--oder einen SCAN am Ende macht

--Warum geht die gleiche Abfrage auf dem DEvRechner besser als
--auf dem Produktivrechner

---> STATISTIKEN

--WA_SYS.. 

--wo er zieml�ich bl�de sein kann: er macht keine kombinierten Statis.
--automatisch --kann dazu f�hren SCAN statt seek
--ausserdem: wann wird die Stats aktualsiert?
--20%+500 + Abfrage nun Stst Aktualisierung
---> wenn zu alt sprich falsch--> flascher Plan


select * into ku1 from ku

select * from ku1 where ID=100 --1 Zeile gesch�tzt


select * from ku1 where city = 'Berlin' --5766 --6144

select * from ku1 where ID = 3123452 --1,14

select * from ku1 where country= 'USA' --183000 gesch�tzt .. real 180000


select * from ku1 
	where country= 'USA'  and freight < 5 --statt 42000 9700

	sp_updatestats



--Prozeduren sollte nie benutzerfreundlich geschrieben sein!



