function global:Split-Result()
{
param
(
[parameter(ValueFromPipeline=$true,
Mandatory=$true)]
[Array]$MATCHRESULT
)

process
{ 
$ReturnData=NEW-OBJECT PSOBJECT –property @{Title=’’;Value=’’}
$DATA=$Matchresult[0].tostring().split(":")
$ReturnData.Title=$Data[0].trim()
$ReturnData.Value=$Data[1].trim()
Return $ReturnData
}
}

$LogicalDisks = Get-WmiObject -Query "select * from Win32_LogicalDisk Where MediaType = 12" | Select Name, MediaType, FileSystem, Size

foreach ($disk in $LogicalDisks)
{
    $Drive = $disk.Name + "\"
    $RESULTS=(fsutil fsinfo ntfsinfo $Drive) 
    $AllocSize = $Results | Split-Result | Select-Object Title,Value | Where-Object {$_.Title -eq "Bytes Per Cluster"}
    if ($AllocSize.Value -eq 65536)
    {
        Write-Host "Allocation size for " $Drive " = " $AllocSize.Value " bytes" -ForegroundColor Green
    }
    else 
    {
        Write-Host "Allocation size for " $Drive " = " $AllocSize.Value " bytes (Recommendation is 64K)" -ForegroundColor Red
    }
}

