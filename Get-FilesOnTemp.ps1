Param(
	
   [Parameter(Mandatory=$True)]
   [string]$sqlserver,
   [Parameter(Mandatory=$True)]
   [string]$TempDrive
) 
$RulePass = 1
$sqlquery = "select distinct substring(physical_name,1,2) as drive,db_name(database_id) as dbname, name, physical_name from sys.master_files where substring(physical_name,2,1) = ':'"
$sqlDrives = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery
$Files = $sqlDrives | Where-Object {$_.drive -eq $TempDrive -and $_.dbname -ne "tempdb"} 

foreach ($file in $Files)
{
    Write-Host "[ERR] Database file" $file.name "(physical file:" $file.physical_name ") for database" $file.dbname "is hosted on the temporary drive" -ForegroundColor Red
    $RulePass = 0
}

if ($RulePass -eq 1)
{
    Write-Host "[INFO] No files found on the temporary drive" $TempDrive -ForegroundColor Green
}
else
{
    Write-Host "[ERR] Any data stored on" $TempDrive "drive is SUBJECT TO LOSS and THERE IS NO WAY TO RECOVER IT." -ForegroundColor Red
    Write-Host "[ERR] Please do not use this disk for storing any personal or application data." -ForegroundColor Red
}

