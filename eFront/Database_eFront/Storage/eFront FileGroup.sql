﻿/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILEGROUP [stg_eFront];
GO;

ALTER DATABASE [$(DatabaseName)]
	ADD FILEGROUP [eFront];
GO;

ALTER DATABASE [$(DatabaseName)]
	ADD FILEGROUP [History_eFront];
GO;