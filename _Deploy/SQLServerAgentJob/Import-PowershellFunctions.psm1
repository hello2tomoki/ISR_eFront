foreach ($function in (Get-ChildItem -Path (Resolve-Path -Path ".\powershell_functions\") -Recurse | Where-Object Extension -EQ '.ps1')) {
    . $function.FullName
    Write-Output $function.FullName
}
Write-Output "Loading SQLServerAgent Job Functions"