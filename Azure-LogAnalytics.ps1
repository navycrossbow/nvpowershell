
Connect-AzAccount


#get all the Log Analytics Workspace 
$all_workspace = Get-AzOperationalInsightsWorkspace
$vms = Get-AzVM

foreach ($vm in $vms) {

    try {
        $myvm_name = $vm.Name
        $myvm_resourceGroup = $vm.ResourceGroupName
        #for windows vm, the value is fixed as below
        $extension_name = "MicrosoftMonitoringAgent"
        $myvm = Get-AzVMExtension -ResourceGroupName $myvm_resourceGroup -VMName $myvm_name -Name $extension_name -ErrorAction SilentlyContinue

        if (!$myvm) { 
           write-output "the vm: $($myvm_name) is not windows based $($vm.OsType)"
        } else {
            $workspace_id = ($myvm.PublicSettings | ConvertFrom-Json).workspaceId
            foreach($w in $all_workspace)
            {
                if($w.CustomerId.Guid -eq $workspace_id)
                { 
                    #here, I just print out the vm name and the connected Log Analytics workspace name
                    Write-Output "the vm: $($myvm_name) writes log to Log Analytics workspace named: $($w.name)"
                }
            }    

        }


    
    }
    catch {
        
    }



}