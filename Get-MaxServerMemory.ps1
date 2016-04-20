Param(
	
   [Parameter(Mandatory=$True)]
   [string]$sqlserver
) 


$sqlquery = "SELECT CAST([value] as bigint) as [value],(select (physical_memory_kb/1024) from sys.dm_os_sys_info) as physical_mem FROM sys.configurations WHERE name = 'max server memory (MB)';"
$MSM = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

if ($MSM.Value -eq "2147483647")
{
    Write-Host "[ERR] Max Server Memory value of " $MSM.Value"MB needs to be configured to a finite value" -ForegroundColor Red
}
if ([convert]::ToInt32($MSM.value,10) -ge [convert]::ToInt32($MSM.physical_mem,10))
{
    Write-Host "[ERR] Max Server Memory value of " $MSM.Value"MB is configured higher than total physical memory" -ForegroundColor Red
}
else 
{
    Write-Host "[INFO] Max Server Memory is configured to a finite value of " $MSM.Value"MB" -ForegroundColor Green
}
