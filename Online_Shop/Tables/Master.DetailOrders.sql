CREATE TABLE Master.DetailOrders(
ID int IDENTITY CONSTRAINT PK_Master_DetailOrders PRIMARY KEY,
OrderId int CONSTRAINT FK_O_DetailOrders_Orders FOREIGN KEY (OrderId) REFERENCES Master.Orders(Id),
ProductsID int CONSTRAINT FK_O_DetailOrders_Products FOREIGN KEY (ProductsID) REFERENCES Master.Products(Id)
)