/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/* Please do not change the database path or name variables. It will be properly coded for build 
and deployment.  This example is using sqlcmd variable substitution. */


--ALTER DATABASE [$(DatabaseName)]
-- MODIFY FILE
-- (
--  NAME = [$(DatabaseName)],
--  FILEGROWTH = 2048 MB
-- )
--GO     
--ALTER DATABASE [$(DatabaseName)]
-- MODIFY FILE
-- (
--  NAME = [$(DatabaseName)_log],
--  FILEGROWTH = 2048 MB
-- )
--GO  