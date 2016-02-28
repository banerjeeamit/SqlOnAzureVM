Param(
  [Parameter(Mandatory=$True)]
   [string]$VMName,
	
   [Parameter(Mandatory=$True)]
   [string]$RGName
) 
# Get the details of the virtual machine
$VM = Get-AzureRMVM -ResourceGroupName $RGName -Name $VMName 
# Check if the recommended machine size is being followed
if ($VM.HardwareProfile.VirtualMachineSize -like ("*_DS*") -or $VM.HardwareProfile.VirtualMachineSize -like "*_G*")
{
    Write-Host "[INFO] Virtual machine size: " $VM.HardwareProfile.VirtualMachineSize -ForegroundColor Green
}
else 
{
    Write-Host "[WARN] Virtual machine size: " $VM.HardwareProfile.VirtualMachineSize -ForegroundColor Yellow
    Write-Host "It is recommended to use DS2 or higher machines for SQL Server Standard Edition" -ForegroundColor Yellow
    Write-Host "It is recommended to use DS3 or higher machines for SQL Server Enterprise Edition" -ForegroundColor Yellow
}