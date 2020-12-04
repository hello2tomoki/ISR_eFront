param (
    [parameter(Mandatory=$true)]
    [String]
    $DeploymentServerName
)

Write-Output ""
Write-Output "*************** Beginning SQL Server Agent Job Deployment Process ***************"
Write-Output ""

$JobName              = 'SCD_RiskRaw'
$JobDescription       = 'Loads SCD_Simpcorp data'
$JobCategory          = 'InfoService'
$StepId               = 0

#IMPORT MODULE USED FOR THIS PROJECT
Import-Module dbatools
#Import-Module .\powershell_functions\SQLServerAgent_Functions.psm1
Import-Module .\Import-PowershellFunctions.psm1 -Force

#REPLACE WITH THIS IF YOU WANT TO KEEP THE EXISTING JOB
New-SQLAgentJob                                                                           `
              -SqlInstance              $DeploymentServerName                             `
              -Job                      $JobName                                          `
              -JobDescription           $JobDescription                                   `
              -JobCategory              $JobCategory                             


#ADD JOB STEPS
$StepId = $StepId + 1;
New-SQLAgentJobSSISPackageStep                                                            `
              -SqlInstance            $DeploymentServerName                               `
              -Job                    $JobName                                            `
              -StepId                 $StepId                                             `
              -StepName               'SCD_RiskRaw Controller'                       `
              -ProxyName              'SSIS_Proxy'                                        `
              -folderName             'RiskRaw'                                           `
              -projectName            'SCD_EDM_ETL_RiskRaw'                                `
              -masterPackage          'SCD_EDM_Controller.dtsx'                    `
              -environmentName        'SCD'                                              `
              -catalogName            'SSISDB'
                               


Write-Output ""
Write-Output "*************** Deployment Complete ***************"
Write-Output ""