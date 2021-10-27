set statistics io , time on
select country, city , COUNT(*) from Customers

where city is null and country is null
group by Country, city with rollup --91
order by 1,2

--70000 Seiten , 1 Sek CPU  180ms Dauer
select country, city , COUNT(*) as Anz 
into #t4
from Customers
group by Country, city with rollup --91
order by 1,2

select * from #t4 
where city is null and country is null

--129 Seiten.. Dauer 9ms und CPU = 0ms
