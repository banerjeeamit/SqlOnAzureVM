Param(
	
   [Parameter(Mandatory=$True)]
   [string]$sqlserver
) 

$RulePass = 0

$sqlquery = "if ((select cast(serverproperty('ProductVersion') as varchar(255))) not like '13%')
begin 
	dbcc traceon (3604)
	dbcc tracestatus (-1)
end
else
begin 
    select 'SQL Server 2016' as TraceFlag
end
"
$TraceFlags = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

if ($TraceFlags.TraceFlag -ne "SQL Server 2016")
{
    foreach ($TraceFlag in $TraceFlags)
    {
        if ($TraceFlag.TraceFlag -eq "1118")
        {
            Write-Host "[INFO] -T1118 is enabled on the SQL Server instance" -ForegroundColor Green 
            $RulePass = 1
        }
    }
}
else 
{
    Write-Host "[INFO] -T1118 is not required on SQL Server 2016 instances since this trace flag is auto enabled." -ForegroundColor Green 
    $RulePass = 1
}

if ($RulePass -eq 0)
{
    Write-Host "[WARN] Trace flag 1118 is not enabled. Please see KB328551 for more details on how this trace flag can help tempdb performance." -ForegroundColor Red
}

$LogicalProcs = Get-WmiObject Win32_Processor | Measure -Property NumberOfLogicalProcessors -Sum | Select  Sum 
$sqlquery = "select count(*) as NumFiles from sys.master_files where database_id = 2 and type = 0"
$NumFiles = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

if ([convert]::ToInt32($LogicalProcs.Sum,10) -le 8 -and [convert]::ToInt32($NumFiles.NumFiles,10) -eq [convert]::ToInt32($LogicalProcs.Sum,10))
{
    Write-Host "[INFO] TEMPDB has" $NumFiles.NumFiles "data files as per best practices recommendation" -ForegroundColor Green
}
elseif ([convert]::ToInt32($LogicalProcs.Sum,10) -gt 8 -and ([convert]::ToInt32($NumFiles.NumFiles,10) -eq 8 -or ([convert]::ToInt32($NumFiles.NumFiles,10) % 4) -eq 0))
{
    Write-Host "[INFO] TEMPDB has" $NumFiles.NumFiles "data files as per best practices recommendation" -ForegroundColor Green
}
else 
{
    Write-Host "[WARN] TEMPDB has" $NumFiles.NumFiles "data files which is not as per best practices recommendation. Refer KB328551 for mode information" -ForegroundColor Red
}