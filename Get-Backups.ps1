Param(
  [Parameter(Mandatory=$True)]
   [string]$sqlserver
)

$sqlquery = "if exists (select TOP 1 physical_device_name from msdb.dbo.backupmediafamily where physical_device_name not like 'http%')
	select 'Disk' as Result
else
	select 'Blob' as Result"

# Execute a query against the SQL Server instance
$backups = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery
# Check if backups are being done to BLOBs directly 
if ($backups.Result -eq "Disk")
{
        Write-Host "[WARN] Database backups found on local disks" -ForegroundColor Red
        $RulePass = 0
}
if ($RulePass -eq 1)
{
    Write-Host "[INFO] All database backups are being backed up to Azure Blobs" -ForegroundColor Green
}


$sqlquery = "if exists (select top 1 backup_size from msdb.dbo.backupset where compressed_backup_size = backup_size)
	select 'Uncompressed' as Result
else
	select 'Compressed' as Result"

# Execute a query against the SQL Server instance
$backups = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery
# Check if backups are being compressed or not
if ($backups.Result -eq "Uncompressed")
{
        Write-Host "[WARN] Uncompressed backups are being performed on this instance" -ForegroundColor Red
        $RulePass = 0
}
if ($RulePass -eq 1)
{
    Write-Host "[INFO] All database backups are using backup compression" -ForegroundColor Green
}