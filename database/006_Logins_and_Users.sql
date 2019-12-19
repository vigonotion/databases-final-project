USE master
GO

CREATE LOGIN admin01 WITH PASSWORD = 'Rkk9W!#7Xbjg6n'
CREATE USER carl FOR LOGIN admin01;
ALTER ROLE [db_owner] ADD MEMBER carl

USE Rainforest
GO

CREATE LOGIN business01	WITH PASSWORD = '@VBuQ@Pf&2ae4A'
CREATE USER peter FOR LOGIN business01
ALTER ROLE db_datareader ADD MEMBER peter


-- A user with restricted reading privileges, which will be unable to see invoice-related information
CREATE LOGIN restricted01 WITH PASSWORD = 'j&a!Q5%7Qbmg8Q'
CREATE USER laura FOR LOGIN restricted01
ALTER ROLE db_datareader ADD MEMBER laura
DENY SELECT ON TInvoice TO laura
DENY SELECT ON TInvoiceLine TO laura