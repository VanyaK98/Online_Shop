CREATE PROCEDURE [dbo].[AddNewOrder]
@ProductsId varchar(100),
@clientsId int
AS
BEGIN
BEGIN TRY
BEGIN TRAN
DECLARE 
@OperationName varchar(20) = 'AddNewOrder',
@Description varchar(30) = 'Add New order',
@ProcName varchar(20) = 'AddNewOrder',
@ErrorMessege varchar(25),
@Date date = GetDate(),
@OrderId int

EXEC dbo.OperationRuns @OperationName = @OperationName,
									    @Description = @Description,
									    @ProcName = @ProcName

INSERT INTO Master.Orders(ClientId,Date,ShippingStatus)
    Values(@clientsId,@Date,'WaitForShipping')

	SET @OrderId = (SELECT Ident_current('Master.Orders'))

INSERT INTO Master.DetailOrders(OrderId,ProductsID)
SELECT @OrderId,value FROM string_split(@ProductsId, ',');


UPDATE master.Warehouse
			SET InStock = 0
				WHERE ProductsID IN (SELECT value FROM string_split(@ProductsId, ','))

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
GO