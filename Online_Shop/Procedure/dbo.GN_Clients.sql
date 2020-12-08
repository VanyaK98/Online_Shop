CREATE PROCEDURE [dbo].[GN_Clients]
	AS 
	BEGIN 
		BEGIN TRY
			DECLARE 
			@OperationName varchar(20) = 'GN_Clients',
			@Description varchar(30) = 'Populate table Clients,Address',
			@StartTime dateTime  = (SELECT GETDATE()),
			@EndTime dateTime,
			@Status varchar(20) = 'Runs',
			@User varchar(25) = (SELECT USER_NAME()),
			@ProcName varchar(20) = 'GN_Clients',
			@ErrorMessege varchar(25),
			@CountRows int

			EXEC dbo.OperationRuns @OperationName = @OperationName,
								  @Description = @Description,
								  @ProcName = @ProcName
	
			CREATE TABLE #StagingTable (
				FirstName varchar(50),
				LastName varchar(50),
				Email varchar(100),
				Phone varchar(30) ,
				City varchar(50),
				Street varchar(50),
				)
				BULK INSERT #StagingTable 
				FROM 'C:\Users\ikozlov\source\repos\Online_Shop\Online_Shop\CSV\Clients_Address.csv'
				WITH (FIRSTROW = 2,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );
	
				INSERT INTO Master.Address(City,Street)
				SELECT City,Street FROM #StagingTable

				SET @CountRows = (SELECT COUNT(*) FROM Master.Address)

				INSERT INTO Master.Clients(FirstName,LastName,Email,Phone,AddressId)
				SELECT FirstName,LastName,Email,Phone, ABS(CHECKSUM(NEWID()) % @CountRows) + 1 as AddressId 
				FROM #StagingTable
		
				UPDATE Log.OperationRuns
				SET EndTime = (SELECT GETDATE()),
			        STATUS = 'Successfully'
				WHERE id = (SELECT Max(id) FROM Log.OperationRuns)
		END TRY
			BEGIN CATCH
				SET @ErrorMessege = ( @ProcName + ' Is faild')
				EXEC dbo.ErrorLog @ERROR_NUMBER = ERROR_NUMBER,
				 @ERROR_SEVERITY = ERROR_SEVERITY,
				 @ERROR_STATE = ERROR_STATE,
				 @ErrorProc = @ProcName,
				 @ErrorLine = ERROR_LINE,
				 @ErrorMessege = @ErrorMessege
			END CATCH  
	END
GO
