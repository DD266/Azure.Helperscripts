# Azure.Helperscripts
Helper scripts for Azure cmdlets

V1.0: This version has 1 cmdlet: Get-AzureRMVMInfo. 
This cmdlet will show the following information for each VM you pass into the function.

Name, CPU, Memory (GB), Internal IP.

#Example 1: Using name to find info on a specific VM
Get-AzureRMVMInfo -VMName "VM1" -ResourceGroupName "RG1"

#Example 2: Getting a list of all VMs in the current subscription, sorting on CPU count
Get-AzureRMVM | Get-AzureRMVMInfo | Sort CPU
