CREATE TABLE Master.ConfigurationModels(
Id int Identity CONSTRAINT PK_Master_Сharacteristics PRIMARY KEY,
Weight varchar(10),
BatteryCapacity varchar(15),
MemoryCapacity varchar(15),
Processor varchar(50),
ScreenDiagonal varchar(29),
Color varchar(20)
)