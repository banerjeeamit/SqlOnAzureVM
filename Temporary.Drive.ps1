# Script to find out if the temporary drive for an Azure Virtual Machine
$Name = Get-WmiObject -Class Win32_DiskDrive -Filter "InterfaceType = `"IDE`" and SCSITargetId = 1" | Select-Object PAth
$Dependent = Get-WmiObject -Class Win32_DiskDriveToDiskPartition | Where-Object {$_.Antecedent -contains $Name.Path} | Select-Object Dependent
$TempDrive = (Get-WmiObject -Class Win32_LogicalDiskToPartition | Where-Object {$_.Antecedent -eq $Dependent.Dependent} | Select-Object Dependent).Dependent.Split("`"")[1]
Write-Host "[INFO] Temporary drive on the machine is:" $TempDrive -Foregroundcolor Yellow
return $TempDrive