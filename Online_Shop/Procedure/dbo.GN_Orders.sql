CREATE PROCEDURE [dbo].[GN_Orders]
AS
	BEGIN 
	 BEGIN TRY
		DECLARE 
		@OperationName varchar(20) = 'GN_Orders',
		@Description varchar(30) = 'Populate table Orders',
		@ProcName varchar(20) = 'GN_Orders',
		@ErrorMessege varchar(100),
		@ClientID int,
		@Date date,
		@FromDate date = '2020-01-10',
		@ToDate date = '2020-12-06',
		@CountOrders int = 5000,
		@OrderId int


		EXEC dbo.OperationRuns 
					@OperationName = @OperationName,
					@Description = @Description,
					@ProcName = @ProcName




		WHILE @CountOrders > 1
			BEGIN
 	
					SET @ClientID = (SELECT top 1 Id FROM Master.Clients ORDER BY NEWID())
				    SET @Date = (select dateadd(day, 
								 rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), 
								 @FromDate))

				    INSERT INTO Master.Orders(ClientId,Date)
					VALUES(@ClientID,@Date)

					SET @OrderId = (SELECT Ident_current('Master.Orders'))

					INSERT INTO master.DetailOrders(OrderId,ProductsID)
					SELECT TOP 1 @OrderId,   * FROM RandomProducts(@Date)ORDER BY NEWID()
		           
			UPDATE master.Warehouse
			SET InStock = 0
				WHERE ProductsID = (SELECT ProductsID 
									FROM master.DetailOrders
									where ID =(SELECT Ident_current('master.DetailOrders')))
			SET @CountOrders -=1
			END

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
		Update Master.Orders
		SET ShippingStatus = 'Sent'

END
GO