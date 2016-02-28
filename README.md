# SqlOnAzureVM
PowerShell scripts to perform best practices health check for SQL Server instances running on Azure VM

List of PowerShell scripts files available
Get-AllocationUnitCheck.ps1 - Checks if the allocation unit size for the disks attached to the VM is 64K
Get-DBProperties.ps1 - Checks if any database has AUTO CLOSE or AUTO SHRINK enabled
Get-FilesOnTemp.ps1 - Checks to see if any database files are hosted on the temporary drive 
Get-IFI.ps1 - Checks to see if the SQL Server service account has instant file initialization security privileges
Get-LPIM.ps1 - Checks to see if Lock Pages in Memory privilege is granted to the SQL Server service account
Get-OSFilesDB.ps1 - Checks to see if database files are hosted on the OS drive
Get-StorageAccountBP.ps1 - Checks to see if the storage account has replication enabled
Get-VMSize.ps1 - Checks if the right virtual machine tier is being used
Temporary Drive.ps1 - Finds out the temporary drive on the virtual machine 
