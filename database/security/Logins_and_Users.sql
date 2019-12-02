create login Administrator with password = 'Administrat0r'

use Rainforest
go
CREATE USER DbAdmin FOR LOGIN Administrator;
ALTER ROLE [db_owner] ADD MEMBER DbAdmin

--and delete like this:
--USE master;
--DROP USER DbAdmin;
--DROP LOGIN Administrator;

CREATE LOGIN business01	WITH PASSWORD = '123'
CREATE USER peter FOR LOGIN business01
ALTER ROLE db_datareader ADD MEMBER peter


-- A user with restricted reading privileges, which will be unable to see invoice-related information
create login restricted01 with password = 'letmein'
create user laura for login restricted01
alter role db_datareader add member laura
deny select on TInvoice to laura
deny select on TInvoiceLine to laura