$vcServer = "vcsa.example.com"
$vcUsername = "administrator@vsphere.local"

# Prompt for credentials securely (only password will be asked, username is pre-filled)
$cred = Get-Credential -UserName $vcUsername -Message "Accessing vSphere vCenter server at: $vcServer"

# Connect to vCenter using the provided credentials
$vcConnection = Connect-VIServer -Server $vcServer -Credential $cred

# Define the OpenShift role name
$roleName = "OpenShift vSphere vCenter Resource Pool"

# Define all required privileges
$privileges = @(
    "Resource.AssignVMToPool",
    "VApp.AssignResourcePool",
    "VApp.Import",
    "VirtualMachine.Config.AddNewDisk"
)

# Check if the role exists
$existingRole = Get-VIRole -Name $roleName -ErrorAction SilentlyContinue
if ($existingRole) {
    Write-Host "Role '$roleName' already exists. Skipping creation."
} else {
    Write-Host "Role '$roleName' not found. Creating it..."

    # Create the new role with required privileges
    $availablePrivileges = Get-VIPrivilege
    $privsToAssign = $availablePrivileges | Where-Object { $privileges -contains $_.Id }

    if ($privsToAssign.Count -ne $privileges.Count) {
        $missing = $privileges | Where-Object { $_ -notin $availablePrivileges.Id }
        Write-Warning "Some privileges were not found in vCenter: $($missing -join ', ')"
    }

    New-VIRole -Name $roleName -Privilege $privsToAssign
    Write-Host "Role '$roleName' created successfully with all specified privileges."
}

# Disconnect from vCenter
Disconnect-VIServer -Server $vcConnection -Confirm:$false
