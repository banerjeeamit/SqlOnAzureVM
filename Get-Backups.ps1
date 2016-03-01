Param(
  [Parameter(Mandatory=$True)]
   [string]$sqlserver
)

$sqlquery = "if exists (select 1 from msdb.dbo.backupmediafamily where physical_device_name not like 'http%')
	select 'Disk' as Result
else
	select 'Blob' as Result"

# Execute a query against the SQL Server instance
$backups = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

if ($backups.Result -eq "Disk")
{
        Write-Host "[WARN] Database backups found on local disks" -ForegroundColor Red
        $RulePass = 0
}
if ($RulePass -eq 1)
{
    Write-Host "[INFO] All database backups are being backed up to Azure Blobs" -ForegroundColor Green
}