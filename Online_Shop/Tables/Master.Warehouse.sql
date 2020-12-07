CREATE TABLE Master.Warehouse(
ID INT IDENTITY CONSTRAINT PK_Master_Warehouse PRIMARY KEY,
ProductsID int CONSTRAINT FK_G_Products_Warehouse FOREIGN KEY (ProductsID) REFERENCES Master.Products(Id),
ConfigurationModelId int CONSTRAINT FK_M_ConfigurationModels_Warehouse FOREIGN KEY (ConfigurationModelID) REFERENCES Master.ConfigurationModels(Id),
ReceivingDate Date,
StartVersion int,
EndVersion int DEFAULT 999999999,
Price Money,
InStock bit DEFAULT 1,
)