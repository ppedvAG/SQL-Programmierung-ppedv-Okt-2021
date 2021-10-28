/*
Transaction TX

TX gibts es grundsätzlich immer

ein UP DEL INS sind TX

aber man das nicht rückgängig

ausser;

begin transaction 

begin tran


Code... INS UP DEL SEL

ROLLBACK.. alles!! rückgängig eal wieviele TX

COMMIT .. jetzt ist es fix drin.. bei mehreren TX dann auch vielfach Commit

solange TX alufen werden "Dinge" gesperrt bis die TX vorbei ist
wieviel gesperrt wird bestimmt: der INDEX

daher sollte man TX nicht sehr lange laufen lassen

kann TX sehen?

Aktivitätsmonitor

sp_lock


*/

Begin Tran
select @@TRANCOUNT -- 1 eine Aktive

select * from customers
 
 update Customers set City = 'Bonn' 
 where CustomerID = 'ALFKI'


 select * from customers

 rollback



 --Ausflug

 --Erhöhe alle Frachtkosten um 10%
 -- bei denen der Chai Tee verkauft wurden
 begin tran
 update orders set Freight = Freight *1.1
 --zuerst die ABfrage
 --dann select in eine eig Zeile und
 --from in nächste Zeile
 --dann select auskommentieren
  --select o.OrderID, Freight, od.productid
 from orders o
	inner join [Order Details] od on od.OrderID = o.orderid
	inner join products p on p.productid = od.ProductID
	where ProductName like 'Chai%'
select * from Orders

rollback



--Allerdings beachte:
--solange eine TX sind DS gesperrt: LOCKS
select * into c1 from customers

begin tran
update Customers set City = 'Bonn' 
	where CustomerID = 'ALFKI'

update c1 set City = 'Bonn' 
	where CustomerID = 'ALFKI'
ROLLBACK
COMMIT











