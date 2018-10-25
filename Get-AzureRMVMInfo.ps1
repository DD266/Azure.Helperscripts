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