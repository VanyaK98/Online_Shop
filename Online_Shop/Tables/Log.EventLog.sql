CREATE TABLE Log.EventLog(
Id int  IDENTITY CONSTRAINT PK_Log_EventLog PRIMARY KEY,
[User] varchar(50),
ProcName varchar(max),
OperationRunId int CONSTRAINT FK_L_EventLog_OperationsRuns FOREIGN KEY (OperationRunId) REFERENCES Log.OperationRuns(Id),
EventDetails varchar(250)
)