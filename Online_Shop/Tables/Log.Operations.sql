CREATE TABLE Log.Operations(
Id int  IDENTITY CONSTRAINT PK_Log_Operations PRIMARY KEY,
OperationName varchar(100),
Description varchar(100)
)