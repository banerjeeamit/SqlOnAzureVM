Param(
	
   [Parameter(Mandatory=$True)]
   [string]$sqlserver
) 


$sqlquery = "DECLARE @sched_c int, @node_c int, @maxdop int
SELECT @sched_c = COUNT(scheduler_id), @node_c = COUNT(DISTINCT parent_node_id) FROM sys.dm_os_schedulers WHERE is_online = 1 AND scheduler_id < 255 AND parent_node_id < 64;
SELECT @maxdop = CAST ([value] as INT) FROM sys.configurations WHERE name = 'max degree of parallelism';
IF (@sched_c  <= 8 AND @node_C = 1 AND @maxdop BETWEEN 1 AND @sched_c)
BEGIN 
	SELECT @maxdop as DOP, 'PASS' as Result
END
ELSE IF (@sched_c  > 8 AND @node_C = 1 AND @maxdop BETWEEN 1 AND 8)
BEGIN
	SELECT @maxdop as DOP, 'PASS' as Result
END
ELSE IF (@sched_c  <= 8 AND @node_C > 1 AND @maxdop BETWEEN 1 AND @node_C)
BEGIN
	SELECT @maxdop as DOP, 'PASS' as Result
END
ELSE IF (@sched_c  > 8 AND @node_C > 1 AND @maxdop BETWEEN 1 AND 8)
BEGIN
	SELECT @maxdop as DOP, 'PASS' as Result
END
ELSE
BEGIN
	SELECT @maxdop as DOP, 'FAIL' as Result 
END
"
$MAXDOP = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

if ($MAXDOP.Result -eq "PASS")
{
    Write-Host "[INFO] Max Degree of Parallelism value of" $MAXDOP.DOP "has been configured as per best practices described in KB2806535" -ForegroundColor Green
}
else 
{
    Write-Host "[WARN] Max Degree of Parallelism value of" $MAXDOP.DOP "has not been configured as per best practices described in KB2806535" -ForegroundColor Red
}
