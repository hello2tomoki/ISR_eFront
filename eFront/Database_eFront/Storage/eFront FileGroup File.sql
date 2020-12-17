/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [stg_eFront],
		FILENAME = '$(DefaultDataPath)\$(DatabaseName)_stg_eFront.ndf'
		,SIZE = 50 MB, FILEGROWTH = 5 MB
	) TO FILEGROUP [stg_eFront];
GO;
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [eFront],
		FILENAME = '$(DefaultDataPath)\$(DatabaseName)_eFront.ndf'
		,SIZE = 50 MB, FILEGROWTH = 5 MB
	) TO FILEGROUP [eFront];
GO;
ALTER DATABASE [$(DatabaseName)]
	ADD FILE
	(
		NAME = [History_eFront],
		FILENAME = '$(DefaultDataPath)\$(DatabaseName)_History_eFront.ndf'
		,SIZE = 50 MB, FILEGROWTH = 5 MB
	) TO FILEGROUP [eFront];
GO;
