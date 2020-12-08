CREATE PROCEDURE [dbo].[GN_Products]
AS 
BEGIN 
BEGIN TRY
	DECLARE 
	@Name varchar(25),
	@Type varchar(15),
	@Weight varchar(10),
	@BatteryCapacity varchar(20),
	@Processor varchar(20),
	@ScreenDiagonal Varchar(20), 
	@MemoryCapacity varchar(20),
	@Color varchar(20),
	@date date,
	@Price money,
	@Counter int,
	@OperationName varchar(20) = 'GN_Products',
	@Description varchar(30) = 'Populate tables Сharacteristics,Products,Warehouse',
	@ProcName varchar(20) = 'GN_Products',
	@ErrorMessege varchar(25),
	@CurrentVersion int,
    @RunID int

	EXEC dbo.OperationRuns @OperationName = @OperationName,
								  @Description = @Description,
								  @ProcName = @ProcName

	CREATE TABLE #StagingTable (
	Name varchar(20),
	Type varchar(20),
	Weight varchar(20),
	BatteryCapacity varchar(20),
	MemoryCapacity varchar(20),
	Processor varchar(20),
	ScreenDiagonal varchar(29) ,
	Color varchar(20),  
	date date,
	Price money
	)

	BULK INSERT #StagingTable 
	FROM 'C:\Users\ikozlov\source\repos\Online_Shop\Online_Shop\CSV\Сharacteristics.csv'
	WITH (FIRSTROW = 2,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );
	BULK INSERT #StagingTable 
	FROM 'C:\Users\ikozlov\source\repos\Online_Shop\Online_Shop\CSV\СharacteristicsIPad.csv'
	WITH (FIRSTROW = 2,
				  FIELDTERMINATOR = ',',
				  ROWTERMINATOR='\n'
				  );

	DELETE  FROM #StagingTable 
	WHERE Name + Type + Weight + BatteryCapacity +
	Processor + MemoryCapacity + Color  + ScreenDiagonal is null 
	DECLARE Cursor1 Cursor LOCAL READ_ONLY FOR SELECT * FROM #StagingTable
	OPEN Cursor1

	




		WHILE  @@FETCH_STATUS = 0
			BEGIN 
				FETCH NEXT FROM Cursor1 
				INTO @Name,@Type,@Weight,@BatteryCapacity,@MemoryCapacity,@Processor,@ScreenDiagonal,@Color, @date,@Price

				INSERT INTO Master.Products(Name,Type)
				VALUES (@Name,@Type)

				INSERT INTO Master.ConfigurationModels(Weight,BatteryCapacity,MemoryCapacity,Processor,ScreenDiagonal,Color)
				VALUES (@Weight,@BatteryCapacity,@MemoryCapacity,@Processor,@ScreenDiagonal,@Color)

				INSERT INTO Master.VersionTypes(CreatedDate)
				VALUES(@date)

		     
				SET @RunID = (SELECT Ident_current('Log.OperationRuns'))
				SET @CurrentVersion = ( SELECT  Ident_current('Master.VersionTypes'))
				INSERT INTO Master.Version(RunID,CurrentVersion,VersionTypeID)
				VALUES(@RunID,10000 + @CurrentVersion,@CurrentVersion)
				

				INSERT INTO Master.Warehouse(ProductsID,ConfigurationModelId,ReceivingDate,StartVersion, Price)
				VALUES ((SELECT Ident_current('Master.Products')),(SELECT Ident_current('Master.ConfigurationModels')),@date,(10000 + @CurrentVersion),@Price)

			END 
			UPDATE Log.OperationRuns
				SET EndTime = (SELECT GETDATE()),
			        STATUS = 'Successfully'
				WHERE id = (SELECT Ident_current('Log.OperationRuns'))
		END TRY
			BEGIN CATCH
				SET @ErrorMessege = ( @ProcName + ' Is faild')
				EXEC dbo.ErrorLog @ERROR_NUMBER = ERROR_NUMBER,
				 @ERROR_SEVERITY = ERROR_SEVERITY,
				 @ERROR_STATE = ERROR_STATE,
				 @ErrorProc = @ProcName,
				 @ErrorLine = ERROR_LINE,
				 @ErrorMessege = @ErrorMessege
				 	Close Cursor1 
					DEALLOCATE  Cursor1
					DROP TABLE #StagingTable 
			END CATCH  


	Close Cursor1 
	DEALLOCATE  Cursor1
	DROP TABLE #StagingTable 
END
GO