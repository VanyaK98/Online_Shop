CREATE   FUNCTION RandomProducts (@date date)
RETURNS TABLE
AS
RETURN
SELECT   P.ID FROM Master.Products P
		JOIN Master.Warehouse W ON P.ID = W.ProductsID 
		WHERE ReceivingDate >= @date
			AND InStock = 1 