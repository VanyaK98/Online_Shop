CREATE TABLE Log.ErrorLog(
Id int IDENTITY CONSTRAINT PK_Log_ErrorLog PRIMARY KEY,
ErrorNumber int,
ErrorSeverty int,
ErrorState int,
ErrorProc varchar(100),
ErrorLine int,
ErrorMessege varchar(25),
EventLogId int CONSTRAINT FK_L_ErrorLog_EventLog FOREIGN KEY (EventLogId) REFERENCES Log.EventLog(Id)
)