# Find out the SQL Server services installed on the machine
$SqlService = Get-WmiObject -Query "SELECT * FROM Win32_Service WHERE PathName LIKE '%sqlservr%'" 

# Export the secpol privileges on the machine to a file 
$filename  = "secpol.inf"
$secpol = secedit /export /cfg $filename | Out-Null
$secpol = Get-Content $filename
# Search for the volumne maintenance task privilege in the output
$IFI = Select-String -Path $filename -Pattern "SeManageVolumePrivilege"
# Remove the file
#Remove-Item $filename

# Loop through each SQL Server service found on the machine
foreach ($servcice in $SqlService)
{
    # Find out the SID value of the service account
    $objUser = New-Object System.Security.Principal.NTAccount($servcice.StartName)
    $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])

    # Find out if the SQL Service account SID exists in the output
    if ($IFI.ToString().Contains($strSID.Value))
    {
        Write-Host "[INFO] SQL Server service account ["$servcice.StartName"] has 'Perform Volume Maintenance Task' security privilege" -ForegroundColor Green
    }
    else
    {
        Write-Host "[ERR] SQL Server service account ["$servcice.StartName"] has 'Perform Volume Maintenance Task' security privilege" -ForegroundColor Red
    }
}
