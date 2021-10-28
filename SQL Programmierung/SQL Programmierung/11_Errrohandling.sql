/*
keine schlechte Idee eine Fehlerbehandlung im Code zu haben

*/

--Ebenen 16... 208
select * from orderssss --Objekt exisitiert

--Ebene 15 .. 102
select * orders

--Ebene 14 = Security

--Ab Ebene 17 wird der Admin etwas unruhig
--bei Ebene 25 wird der Admin eine Lastminutereise gebucht haben

--Ebene 0 bis 10 .. Infos
--Ebene bis 16 sind DAU Fehler .. der User ist schuld


select * from sysmessages where msglangid = 1031


Begin try
	select 1/0
	select 100
End try
Begin catch
	select ERROR_MESSAGE(), ERROR_SEVERITY()
end catch


--keinen Fehlerbehandlung, sondern sofort fehler
Begin try
	select * from orderssssss
End try
Begin catch
	select ERROR_MESSAGE(), ERROR_SEVERITY()
end catch


--Ausser bei dem hier

create proc gpdemo8
as
select * from orderssssssss



--die Syntax ist korrekt und daher läufts
Begin try
	exec gpdemo8
End try
Begin catch
	select ERROR_MESSAGE(), ERROR_SEVERITY()
		, GETDATE(), ERROR_PROCEDURE(), ERROR_LINE()
end catch


