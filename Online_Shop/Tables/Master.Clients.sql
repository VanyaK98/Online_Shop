CREATE TABLE Master.Clients(
Id int IDENTITY CONSTRAINT PK_Master_Clients PRIMARY KEY,
FirstName varchar(50),
LastName varchar(50),
Email  varchar(100),
Phone varchar(30),
AddressID int CONSTRAINT FK_U_Clients_Address FOREIGN KEY (AddressID) REFERENCES Master.Address(Id)
)