# Works on Windows Vista/Windows Server 2008 or above
# Get the currently active power scheme
$CurrentScheme = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes | Select ActivePowerScheme
# Get all the Power Schemes available on the machine
$PowerSchemes = Get-ChildItem -Path HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes | ForEach-Object {Get-ItemProperty $_.pspath}

# Loop through each of the Power Schemes to identify the friendly name of the currently active Power Scheme 
foreach ($Scheme in $PowerSchemes)
{
    if($Scheme.FriendlyName -like "*High Performance*")
    {
        $HighPerfScheme = $Scheme.PSChildName
    }
    if ($CurrentScheme.ActivePowerScheme -eq $Scheme.PSChildName)
    {
        Write-Host "[INFO] Current power scheme: " $Scheme.FriendlyName.Split(",")[2] 
    }

}

if ($CurrentScheme.ActivePowerScheme -ne $HighPerfScheme)
{
    Write-Host "[WARN] Current Power Plan is not recommended for running SQL Server. `n[WARN] Please configure the server to use High Performance power plan. See KB935799 for more details." -ForegroundColor Red
}

