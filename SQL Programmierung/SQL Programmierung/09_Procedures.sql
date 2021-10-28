/*

create proc procname
as
Code....


create procedure gpname @par1 int, @par2 int
as
select * from tabelle where sp = @par1
update tabelle2 set spx =  @par2

schreibe immer am Ende der Pro das GO


--ähnlich einer Windows Batchdatei


Wofür brauche ich Procs?

1. Komplexe Logik abbilden
2. Code liegt gekapselt auf dem Server
	zentrale Codepflege
3. schneller als normal
	aber evtl auch verflucht langsamer (Indizes)
	der Vorteil der Proz ist auch ihr Nachteil


*/


*/

create proc gpdemo
as
select GETDATE()

exec gpdemo

alter proc gpdemo @par1 int
as
select @par1 * 100


exec gpdemo 15

drop proc gpdemo



select * into kunden from NwindBig..customers

set statistics io, time on

select country, city, COUNT(*) from kunden
	group by Country, city

	--Anlayse Zeit: SQL Server-Analyse- und Kompilierzeit: 
--, CPU-Zeit = 547 ms, verstrichene Zeit = 583 ms.

--Idee bei 2ten mal ausführen kennt er ja schon den Weg..
--Analysezeit = 0
--aber irgtendwann ist der Plan weg!


--Die Proz dagegen legt den Plan dauerhaft an..
--bei ersten Aufruf
--auch nach Neustart immer noch vorhanden



--create procedure gpname @par1 int, @par2 int
--as
--select * from tabelle where sp = @par1
--update tabelle2 set spx =  @par2

select * from Customers 
where customerid  'A%'



exec gpKdSuche 'ALFKI' -- 1 Treffer
exec gpKdSuche 'A%'    --4 Treffer
exec gpKdSuche '%'     --alle 



create proc gpKdSuche @Kdid nchar(5)
as
select * from Customers where CustomerID like @Kdid

exec gpKdSuche 'ALFKI'

exec gpKdSuche 'A%' --nix

--char (5).. 5 Stellen fix
-- 'a%...'


alter proc gpKdSuche @Kdid varchar(5)
as
select * from Customers where CustomerID like @Kdid


exec gpKdSuche 'A%' --jetzt klappts

--ohne Parameter und auch ohne %
alter proc gpKdSuche @Kdid varchar(5)='%'
as
select * from Customers where CustomerID like @Kdid+'%'


exec gpKdSuche 

exec gpKdSuche 'A'

--was kommt hier raus...?
create proc gpdemo2
as
select 100

exec gpdemo2 


select * from Orders;
GO --Batchdelimiter


create proc gpdemo3
as
select 100;
GO

exec gpdemo3



--Mehr Parameter und auch Output
--OUTPUT .. das Ergebnis der Proz weiter verwenden

create or alter proc gpdemo4 @par1 int=100, @par2 int
as
select @par1 + @par2;
GO

exec gpdemo4 200 --error

exec gpdemo4 @par2=300 --jetzt gehts

exec gpdemo4 @par2=50, @par1=45 --

--OUTPUT

--Idee: exec gpdemo1 50 ---> 100  

create or alter proc gpdemo6 
		@par1 int,
		@par2 int output --= INPUT und OUTPUT
as
select @par1*100
set @par2=@par1+33
--select @par2

exec gpdemo6 100, --Error 

--Weg dazu
--Variabale erstellen ausserhalb der Proz
--Proz Outputparamweter der variablen zuweisen
--dann mit Variabel weiterarbeiten

declare @i as int=1000

exec gpdemo6 100, @par2=@i OUTPUT
		--          -------->
select @i

select * from orders where Freight < @i


--Aufgabe: 
--Idee proz errechnet den Schnitt der Frachtkosten in 
--einem Land (UK USA

--dananch wollen wir alle Bestellungen sehen, die
--über diesem Schnitt liegen


exec gpLandSchnittFracht 'USA'

--45

select * from orders where Freight > 45


--zuerst der schnitt
select AVG(freight) from orders where shipcountry = 'USA'


--als Proz

create or alter proc gpSchnittLandFracht @Land varchar(50)
as
select AVG(freight) from orders where shipcountry = @Land
GO

exec gpSchnittLandFracht 'USA'
--mit Output


create or alter proc gpSchnittLandFracht
	@Land varchar(50), 
	@Schnitt money output
as
select @schnitt=AVG(freight) from orders where shipcountry = @Land
GO


declare @LandSchnitt as money
exec gpSchnittLandFracht 'USA', @Schnitt=@LandSchnitt output

select * from orders where Freight > @LandSchnitt
order by Freight asc



--Idee:-)


create or alter procedure gpdemo7 @par1 int,@par2 int
as
select (@par1 *@par2) as Ergebnis into ##t1
select * from ##t1 --mit loakler #t gehts nicht --mit global gehts
GO

exec gpdemo7 13, 14

select * from ##t1 --aber Vorsicht.. 
--es kann immer nur eine mit diesem Namen geben..

--hier würde ich tats. den drop table empfehlen
select * from ##t1









