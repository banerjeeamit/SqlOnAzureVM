Param(
  [Parameter(Mandatory=$True)]
   [string]$VMName,
	
   [Parameter(Mandatory=$True)]
   [string]$RGName
) 
$Accounts = @()


# Get the details about the virtual machine
$VM = Get-AzureRMVM -ResourceGroupName $RGName -Name $VMName 

# Retrieve the URI from the virtual hard disks attached to the VM
$VHDs = $VM.StorageProfile.DataDisks.VirtualHardDisk.Uri

# Retrieve the storage account from each URI
foreach ($vhd in $VHDs)
{
   $Accounts = $Accounts + ((($vhd -split "//")[1]) -split ".blob")[0]
}
# Get the unique storage accounts
$Accounts = $Accounts | select -Unique

# Get the best practices for the account
foreach ($Account in $Accounts)
{
    $StorageAccount = Get-AzureRmStorageAccount -ResourceGroupName $RGName -Name $Account
    Write-Host "***** Storage account check for " $StorageAccount.StorageAccountName
    if ($StorageAccount.AccountType.ToString().Contains("LRS"))
    {
        Write-Host "[INFO] Replication is not enabled for the storage account" -ForegroundColor Green
    }
    else 
    {
        Write-Host "[ERR] Account Type: " $StorageAccount.AccountType -ForegroundColor Red
        Write-Host "[ERR] It is recommended to disable any form of replication for your storage account" -ForegroundColor Red
    }

    if ($VM.Location -eq $StorageAccount.Location.Replace(" ",""))
    {
        Write-Host "[INFO] Storage and Compute are co-located" -ForegroundColor Green
    }
    else
    {
        Write-Host "[ERR] Storage and Compute are co-located" -ForegroundColor Red
    }
}