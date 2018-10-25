<#
    .SYNOPSIS 
    Gets basic information on one or more Azure VMs.
    
    .DESCRIPTION
    Get CPU, memory and IP configuration with a simple cmdlet.
    Pipeline input accepts multiple vm objects.
    .EXAMPLE
    Get-AzureRMVMInfo -VMName "VM1" -ResourceGroupName "RG1"
    This command gets the CPU, memory and internal IP for VM "VM1".
    .EXAMPLE
    Get-AzureRMVM | Get-AzureRMVMInfo
    This command gets all VMs in the current subscription, then uses the output to surface all basic configuration on these VMs.
    .EXAMPLE
    Get-AzureRMVM | Get-AzureRMVMInfo | Sort "Internal IP"
    This command gets all VMs in the current subscription, then uses the output to surface all basic configuration on these VMs, sorted by Internal IP.
    .LINK
    https://github.com/martensnico/Azure.Helperscripts
#>
function Get-AzureRMVMInfo {
    [cmdletbinding(DefaultParameterSetName = 'Name')]
    Param(        
        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        $VMName,
        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        $ResourceGroupName,
        [Parameter(ValueFromPipeline, Mandatory = $true, ParameterSetName = 'Object')]
        $VM
    )
    process {
        if ($pscmdlet.ParameterSetName -eq "Name") {
            $vm = Get-AzureRMVM -Name $VMName -ResourceGroupName $ResourceGroupName
        }
        
        $sizeinfo = get-azurermvmsize -VMName $vm.name -ResourceGroupName $vm.ResourceGroupName | Where-Object {$_.Name -eq $vm.hardwareprofile.vmsize}
        $privateip = (Get-AzureRmNetworkInterface | where-Object {$_.Id -eq $vm.NetworkProfile.NetworkInterfaces[0].Id}).IpConfigurations[0].PrivateIPAddress
        $vminfo = [pscustomobject][ordered] @{
            Name          = $vm.Name
            CPU           = $sizeinfo.numberofcores
            "Memory (GB)" = $sizeinfo.MemoryInMB * 1mb / 1gb
            "Internal IP" = $privateip      
        }
        $vminfo
    }
}