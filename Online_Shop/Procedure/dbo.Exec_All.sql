CREATE PROCEDURE [dbo].[Exec_All]
AS
BEGIN

Exec GN_Clients;
EXEC GN_Products;
EXEC ST_Orders

END