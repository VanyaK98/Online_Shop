CREATE PROCEDURE [dbo].[ErrorLog]
	@ERROR_NUMBER int,
	@ERROR_SEVERITY int,
	@ERROR_STATE int,
	@ErrorProc varchar(25),
	@ErrorLine int,
	@ErrorMessege varchar(50)
	AS 
	 BEGIN 
	 UPDATE Log.OperationRuns
				SET EndTime = (SELECT GETDATE()),
			        STATUS = 'faild'
				WHERE id = (SELECT Ident_current('Log.OperationRuns'))
	    
	INSERT INTO Log.ErrorLog(ErrorNumber,ErrorSeverty,ErrorState,ErrorProc,ErrorLine,ErrorMessege,EventLogId)
	VALUES(@ERROR_NUMBER,@ERROR_SEVERITY,@ERROR_STATE,@ErrorProc,
	       @ErrorLine,@ErrorMessege, (SELECT Ident_current('Log.EventLog')))
	
	 END