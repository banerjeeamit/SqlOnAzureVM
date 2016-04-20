# SqlOnAzureVM
PowerShell scripts to perform best practices health check for SQL Server instances running on Azure VM

List of PowerShell scripts files available 

1. Get-AllocationUnitCheck.ps1 - Checks if the allocation unit size for the disks attached to the VM is 64K  
2. Get-DBProperties.ps1 - Checks if any database has AUTO CLOSE or AUTO SHRINK enabled  
3. Get-FilesOnTemp.ps1 - Checks to see if any database files are hosted on the temporary drive   
4. Get-IFI.ps1 - Checks to see if the SQL Server service account has instant file initialization security privileges  
5. Get-LPIM.ps1 - Checks to see if Lock Pages in Memory privilege is granted to the SQL Server service account  
6. Get-OSFilesDB.ps1 - Checks to see if database files are hosted on the OS drive  
7. Get-StorageAccountBP.ps1 - Checks to see if the storage account has replication enabled  
8. Get-VMSize.ps1 - Checks if the right virtual machine tier is being used  
9. Temporary Drive.ps1 - Finds out the temporary drive on the virtual machine     
10. Get-Backups.ps1 - Finds out if any backups are being taken to local disk
11. Get-TempdbFiles.ps1 - Checks if -T1118 is enabled (not required for SQL Server 2016) and if tempdb data files are configured as per best practices mentioned in KB328551
12. Get-MaxDop.ps1 - Checks if Max Degree of Parallelism is configured as per best practices mentioned in KB2806535
13. Get-MaxServerMemory.ps1 - Checks if Max Server Memory is configured to a finite value lesser than total physical memory
14. Get-PowerPlan.ps1 - Checks to see if the Power Plan is configured to High Performance
