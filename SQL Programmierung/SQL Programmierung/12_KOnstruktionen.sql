/*
IF Bedingung

IF ELSE

IIF

WHILE

*/

IF 1=1 select 100

IF 1=0 select 100

IF 1=0 
	select 100 
else 
	select 200


--was kommt raus?
IF 1=1 
	select 100 
else 
	select 200
	select 300

	--äh 100 und 300????

IF 1=1 
	BEGIN
		select 100 
	END
else 
	BEGIN
		select 200
		select 300
	END


--Hier wieder Fehler... also immer begin end	
IF 1=1 
		select 100 
		select 200
else 	
		select 300


IF (select COUNT(*) from orders ) >1000
	select 100
else
	select 200


IF (select COUNT(*) from orders ) >1000
	OR
	(Select AVG(freight) from orders) < 10
	select 100
else
	select 200


WHILE Bedingung  --Prüfung imm ernur zu Beginn 
	BEGIN
		Code
		BREAK --sofortiger Abbruch der Schleife
		CONTINUE --springt sofort zum Schleifenkopf
		CODE
	END


declare @i as int=1

While @i <10
	begin 
		select @i
		set @i = @i+1
		CONTINUE
		select @i=@i+4
		BREAK 
	end

--Spielwiese zum Testen
select * into o1  from orders

select MIN(freight), MAX(freight), SUM(freight) from o1
--0.02  1007  65000

--Aufgabe: Erhöhe die Frachtkosten
--um 10% ,solange bis entweder der Max Wert 1500 erreicht hat
--oder die Summe 80000
--die Werte dürfen nicht überstiegen werden

declare @summe money
select @summe=SUM(freight) from o1

begin tran
while (select MAX(freight) from o1) <=1500/1.1
	  AND
	  (select SUM(freight) from o1) <=80000/1.1
begin
	Update o1 set Freight = Freight *1.1
	select MAX(freight), SUM(freight) from o1
end
rollback