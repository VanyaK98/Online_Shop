CREATE PROCEDURE [dbo].[Exec_All]
AS
BEGIN

Exec dbo.GN_Clients;
EXEC dbo.GN_Products;
EXEC dbo.GN_Orders

END