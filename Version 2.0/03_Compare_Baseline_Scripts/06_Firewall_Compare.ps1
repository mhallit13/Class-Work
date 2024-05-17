########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Compare Current Firewalls to Baseline #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

$ht = @{
    Property        = "instanceid", "enabled", "direction", "action", "localaddress", "remoteaddress",
                      "protocol", "localport", "remoteport"
    PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    $rules         = Get-NetFirewallRule
    $portfilter    = Get-NetFirewallPortFilter
    $addressfilter = Get-NetFirewallAddressFilter

    ForEach ($rule in $rules){
        $ruleport    = $portfilter |
                           Where-Object {$_.InstanceID -eq $rule.InstanceID}
        $ruleaddress = $addressfilter |
                           Where-Object {$_.InstanceID -eq $rule.InstanceID}
        $data        = @{
            InstanceID    = $rule.InstanceID.ToString()
            Enabled       = $rule.Enabled.ToString()
            Direction     = $rule.Direction.ToString()
            Action        = $rule.Action.ToString()
            LocalAddress  = $ruleaddress.LocalAddress -join ","
            RemoteAddress = $ruleaddress.RemoteAddress -join ","
            Protocol      = $ruleport.Protocol.ToString()
            LocalPort     = $ruleport.LocalPort -join ","
            RemotePort    = $ruleport.RemotePort -join ","
        }

        New-Object -TypeName psobject -Property $data

    }
}

ForEach ($ip in $targets){
    $ht.ReferenceObject = Import-Csv -Path ..\02_Create_Baseline_Scripts\FirewallBaseline.csv |
        Where-Object {$_.pscomputername -eq $ip} 
    
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip} 

    Compare-Object @ht |
        Sort-Object -Property PSCompuerName, InstanceID
}