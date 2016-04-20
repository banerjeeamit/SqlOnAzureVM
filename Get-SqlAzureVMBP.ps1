cls
$VMName = ""
$RGName = ""
$sqlserver = ""
# Find out the temporary drive as it is needed for other checks
$TempDrive = & '.\Temporary Drive.ps1'
# Check if the correct VM size is being used
Write-Host "***** Check for storage best practices"
&'.\Get-AllocationUnitCheck.ps1' 
&'.\Get-StorageAccountBP.ps1' $VMName $RGName
&'.\Get-VMSize.ps1' $VMName $RGName
&'.\Get-IFI.ps1'
&'.\Get-LPIM.ps1' $sqlserver
Write-Host "***** Check for server best practices"
&'.\Get-PowerPlan.ps1' 
Write-Host "***** Check for instance best practices"
&'.\Get-MaxDop.ps1' $sqlserver
&'.\Get-MaxServerMemory.ps1' $sqlserver
Write-Host "***** Check for database best practices"
&'.\Get-OSFilesDB.ps1' $sqlserver
&'.\Get-DBProperties.ps1' $sqlserver
&'.\Get-FilesOnTemp.ps1' $sqlserver $TempDrive 
&'.\Get-AutoShrinkClose.ps1' $sqlserver
&'.\Get-TempdbFiles.ps1' $sqlserver


