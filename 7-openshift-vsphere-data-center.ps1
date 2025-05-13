$vcServer = "vcsa.example.com"
$vcUsername = "administrator@vsphere.local"

# Prompt for credentials securely (only password will be asked, username is pre-filled)
$cred = Get-Credential -UserName $vcUsername -Message "Accessing vSphere vCenter server at: $vcServer"

# Connect to vCenter using the provided credentials
$vcConnection = Connect-VIServer -Server $vcServer -Credential $cred

# Define the OpenShift role name
$roleName = "OpenShift vSphere vCenter Data Center"

# Define all required privileges
$privileges = @(
    "InventoryService.Tagging.ObjectAttachable",
    "Resource.AssignVMToPool",
    "VApp.Import",
    "VirtualMachine.Config.AddExistingDisk",
    "VirtualMachine.Config.AddNewDisk",
    "VirtualMachine.Config.AddRemoveDevice",
    "VirtualMachine.Config.AdvancedConfig",
    "VirtualMachine.Config.Annotation",
    "VirtualMachine.Config.CPUCount",
    "VirtualMachine.Config.DiskExtend",
    "VirtualMachine.Config.DiskLease",
    "VirtualMachine.Config.EditDevice",
    "VirtualMachine.Config.Memory",
    "VirtualMachine.Config.RemoveDisk",
    "VirtualMachine.Config.Rename",
    "VirtualMachine.Config.ResetGuestInfo",
    "VirtualMachine.Config.Resource",
    "VirtualMachine.Config.Settings",
    "VirtualMachine.Config.UpgradeVirtualHardware",
    "VirtualMachine.Interact.GuestControl",
    "VirtualMachine.Interact.PowerOff",
    "VirtualMachine.Interact.PowerOn",
    "VirtualMachine.Interact.Reset",
    "VirtualMachine.Inventory.Create",
    "VirtualMachine.Inventory.CreateFromExisting",
    "VirtualMachine.Inventory.Delete",
    "VirtualMachine.Provisioning.Clone",
    "VirtualMachine.Provisioning.DeployTemplate",
    "VirtualMachine.Provisioning.MarkAsTemplate",
    "Folder.Create",
    "Folder.Delete"
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
