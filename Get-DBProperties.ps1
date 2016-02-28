Param(
  [Parameter(Mandatory=$True)]
   [string]$sqlserver
)


$RulePass = 1
$sqlquery = "select name, is_auto_shrink_on, is_auto_close_on from sys.databases"

# Execute a query against the SQL Server instance
$dbs = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

# Loop through the database properties
foreach ($db in $dbs)
{
    if ($db.is_auto_shrink_on -eq $true)
    {
        Write-Host "[ERR] Database" $db.name "has Auto Shrink turned on" -ForegroundColor Red
        $RulePass = 0
    }
    if ($db.is_auto_close_on -eq $true)
    {
        Write-Host "[ERR] Database" $db.name "has Auto Close turned on" -ForegroundColor Red
        $RulePass = 0
    }
}

if ($RulePass -eq 1)
{
    Write-Host "[INFO] No databases found with Auto Close and Auto Shrink turned on" -ForegroundColor Green
}