Param(
  [Parameter(Mandatory=$True)]
   [string]$sqlserver
)


$RulePass = 1
$sqlquery = "SELECT locked_page_allocations_kb FROM sys.dm_os_process_memory"

# Execute a query against the SQL Server instance
$lpim = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

if ($lpim.locked_page_allocations_kb -eq "0")
{
        Write-Host "[WARN] Lock Pages in Memory security privilege is not granted to the SQL Server service account" -ForegroundColor Red
        $RulePass = 0
}
if ($RulePass -eq 1)
{
    Write-Host "[INFO] Lock Pages in Memory Security Privilege is granted to the SQL Server service account" -ForegroundColor Green
}