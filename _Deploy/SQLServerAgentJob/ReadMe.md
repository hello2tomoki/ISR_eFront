Note: 
We will primary reference dbatools to Deploy SQL Server Agent Job with PowerShell. 
Because Not all functions are available from dbatools, custom user-defined functions will be used.

We are currently using commands (v 0.9.831), and Offline dbatools.0.9.831.nupkg is available

https://dbatools.io/

Documentation on dbatools are available at
https://docs.dbatools.io/

Command list
https://dbatools.io/commands/

offline installs of dbatools
https://dbatools.io/offline/

walk-thru: installing modules from the powershell gallery
https://dbatools.io/soup2nutz/

Full Package Details
https://www.powershellgallery.com/packages/dbatools/0.9.831


Example:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Install-Module dbatools
Import-Module dbatools

#Get-Module dbatools 
PS C:\WINDOWS\system32> Get-Module dbatools 

ModuleType Version    Name                                ExportedCommands                                   
---------- -------    ----                                ----------------                                   
Script     0.9.831    dbatools                            {Select-DbaObject, Set-DbatoolsConfig, Add-DbaAg...


PS C:\WINDOWS\system32> (Get-Module -ListAvailable dbatools*).path
C:\Program Files\WindowsPowerShell\Modules\dbatools\0.9.831\dbatools.psd1


