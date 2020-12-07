CREATE TABLE Master.Orders(
Id int IDENTITY CONSTRAINT PK_Master_Orders PRIMARY KEY,
ClientId int CONSTRAINT FK_U_Orders_Clients FOREIGN KEY (ClientId) REFERENCES Master.Clients(Id),
Date date,
ShippingStatus varchar(20)
)