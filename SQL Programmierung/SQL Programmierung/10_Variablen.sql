--Variablen existier nurt innerhalb einen Batches zur Laufzeit

declare @var1 as int

set @var1 = 10
GO
select @var1 --Variabke ist weg

select @var1=SUM(freight) from orders

--nich erlaubt

select @var1=SUM(freight), , Land,@var1*1.19 from orders