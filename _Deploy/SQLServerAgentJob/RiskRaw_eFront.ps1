param (
    [parameter(Mandatory=$true)]
    [String]
    $DeploymentServerName
)

Write-Output ""
Write-Output "*************** Beginning SQL Server Agent Job Deployment Process ***************"
Write-Output ""

$JobName              = 'RiskRaw_eFront'
$JobDescription       = 'Load PCO Tracking'
$JobCategory          = 'InfoService'
$StepId               = 0

#IMPORT MODULE USED FOR THIS PROJECT
Import-Module dbatools
#Import-Module .\powershell_functions\SQLServerAgent_Functions.psm1

Import-Module  .\Import-PowershellFunctions.psm1 -Force

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
              -StepName               'RiskRaw eFront Controller'                         `
              -ProxyName              'SSIS_Proxy'                                        `
              -folderName             'RiskRaw'                                           `
              -projectName            'RiskRaw_eFront'                                    `
              -masterPackage          'eFront_Controller.dtsx'                           `
              -environmentName        'RiskRaw_eFront'                                               `
              -catalogName            'SSISDB'
                               


Write-Output ""
Write-Output "*************** Deployment Complete ***************"
Write-Output ""