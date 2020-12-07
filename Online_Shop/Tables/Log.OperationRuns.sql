CREATE TABLE Log.OperationRuns(
Id int  IDENTITY CONSTRAINT PK_Log_OperationRun PRIMARY KEY,
OperationId int CONSTRAINT FK_L_OperationRuns_Operations FOREIGN KEY (OperationId) REFERENCES Log.Operations(Id),
StartTime DATETIME,
EndTime DATETIME,
Status varchar(25)
)