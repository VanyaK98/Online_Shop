CREATE PROCEDURE [dbo].[AddNewClient]
@FirstName varchar(50),
@LastName  varchar(50),
@Email varchar(100),
@Phone varchar(30),
@City varchar(50),
@Street varchar(50)
	AS
	 BEGIN
		BEGIN TRY
			BEGIN TRAN
		DECLARE 
		@OperationName varchar(20) = 'AddNewClient',
		@Description varchar(30) = 'Add New Client',
		@ProcName varchar(20) = 'AddNewClient',
		@ErrorMessege varchar(25),
		@IdAddress int 

		EXEC dbo.OperationRuns	@OperationName = @OperationName,
								@Description = @Description,
								@ProcName = @ProcName

		  INSERT INTO Master.Address(City,Street)
		  VALUES (@City,@Street)

		  SET @IdAddress = (SELECT Ident_current('Master.Address'))
  
		  INSERT INTO Master.Clients(FirstName,LastName,Email,Phone,AddressID)
		  VALUES (@FirstName,@LastName,@Email,@Phone,@IdAddress)


		  UPDATE Log.OperationRuns
		  SET EndTime = (SELECT GETDATE()),
						 STATUS = 'Successfully'
						 WHERE id = (SELECT Ident_current('Log.OperationRuns'))

             COMMIT TRAN
			END TRY
				BEGIN CATCH
				ROLLBACK TRAN
					SET @ErrorMessege = ( @ProcName + ' Is faild')
					EXEC Dbo.ErrorLog @ERROR_NUMBER = ERROR_NUMBER,
					 @ERROR_SEVERITY = ERROR_SEVERITY,
					 @ERROR_STATE = ERROR_STATE,
					 @ErrorProc = @ProcName,
					 @ErrorLine = ERROR_LINE,
					 @ErrorMessege = @ErrorMessege
				END CATCH  
	 END