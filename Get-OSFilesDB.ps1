Param(
	
   [Parameter(Mandatory=$True)]
   [string]$sqlserver
) 

$RulePass = 1
$sqlquery = "select distinct substring(physical_name,1,2) as drive from sys.master_files where substring(physical_name,2,1) = ':'"
$sqlDrives = Invoke-Sqlcmd -ServerInstance $sqlserver -Query $sqlquery

# Find out the OS Drive
$Name = Get-WmiObject -Class Win32_DiskDrive -Filter "InterfaceType = `"IDE`" and SCSITargetId = 0" | Select-Object PAth
$Dependent = Get-WmiObject -Class Win32_DiskDriveToDiskPartition | Where-Object {$_.Antecedent -contains $Name.Path} | Select-Object Dependent
$OSDrive = (Get-WmiObject -Class Win32_LogicalDiskToPartition | Where-Object {$_.Antecedent -eq $Dependent.Dependent} | Select-Object Dependent).Dependent.Split("`"")[1]

foreach ($drive in $sqlDrives)
{
    if ($drive.drive -eq $OSDrive)
    {
        Write-Host "[ERR] Database files found on OS drive" -ForegroundColor Red
        $RulePass = 0
    }
}

if ($RulePass -eq 1)
{
    Write-Host "[INFO] No database files found on OS drive" -ForegroundColor Green
}