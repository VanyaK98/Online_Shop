CREATE TABLE Master.Version(
Id int IDENTITY CONSTRAINT PK_Version PRIMARY KEY,
CurrentVersion int,
RunID int CONSTRAINT FK_L_Version_OperationRuns FOREIGN KEY (RunId) REFERENCES Log.OperationRuns(Id),
VersionTypeID int CONSTRAINT FK_M_Version_VersionType FOREIGN KEY (VersionTypeID) REFERENCES Master.VersionTypes(Id))