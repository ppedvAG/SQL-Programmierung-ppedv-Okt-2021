


DECLARE @cars xml
 
SELECT @cars = C
FROM OPENROWSET (BULK 'D:\Cars.xml', SINGLE_BLOB) AS Cars(C)
    
SELECT @cars
    
DECLARE @hdoc int
select @cars
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @cars
SELECT *
FROM OPENXML (@hdoc, '/Cars/Car' , 1)
WITH(
    Stocknumber VARCHAR(100) 'StockNumber', --Node
    Make VARCHAR(100) 'Make',
	Model varchar(100) 'Model'
    )
    
    
EXEC sp_xml_removedocument @hdoc