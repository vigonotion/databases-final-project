create login Administrator with password = 'Administrat0r'

use Rainforest
go
CREATE USER DbAdmin FOR LOGIN Administrator;
ALTER ROLE [db_owner] ADD MEMBER DbAdmin

--and delete like this:
--USE master;
--DROP USER DbAdmin;
--DROP LOGIN Administrator;
