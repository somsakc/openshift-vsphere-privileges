# Powershell Script for Generating Openshift vSphere Privileges
Powershell script to generate vSphere privileges required for OpenShift Container Platform

## A. vSphere Privileges Prerequisites
Refer to https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/installing_on_vsphere/installer-provisioned-infrastructure#installation-vsphere-installer-infra-requirements_ipi-vsphere-installation-reqs


## B. Instructions
### Step 1: Installing Powershell CLI Module

Install-Module -Name VMware.PowerCLI

```
Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running 
the Set-PSRepository cmdlet. Are you sure you want to install the modules from 'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): Y
```

### Step 2: Setting Participating in CEIP

Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false

```
Perform operation?
Performing operation 'Update VMware.PowerCLI configuration.'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

Scope    ProxyPolicy     DefaultVIServerMode InvalidCertificateAction  DisplayDeprecationWarnings WebOperationTimeout
                                                                                                  Seconds
-----    -----------     ------------------- ------------------------  -------------------------- -------------------
Session  UseSystemProxy  Multiple            Unset                     True                       300
User                                                                                              
AllUsers                                                                                          
```

### Step 3: Creating OpenShift Roles

./1-openshift-vsphere-vcenter.ps1

```

PowerShell credential request
Accessing vSphere vCenter server at: vcsa.example.com
Password for user administrator@vsphere.local: ********

Role 'OpenShift vSphere vCenter' not found. Creating it...

Name                      IsSystem
----                      --------
OpenShift vSphere vCenter False
Role 'OpenShift vSphere vCenter' created successfully with all specified privileges.
```


## C. Term of Use
The powershell script is used for quick OpenShift installation on vSphere platform. It has been tested with small number of poc environments. You may take your own risk if you apply to your environment.
