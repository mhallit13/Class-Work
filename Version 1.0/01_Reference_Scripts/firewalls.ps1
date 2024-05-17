$rules         = Get-NetFirewallRule | Where-Object {$_.enabled}
$portfilter    = Get-NetFirewallPortFilter
$addressfilter = Get-NetFirewallAddressFilter

ForEach($rule in $rules){
    $ruleport    = $portfilter | Where-Object {$_.InstanceID -eq $rule.InstanceID}
    $ruleaddress = $addressfilter | Where-Object {$_.InstanceID -eq $rule.InstanceID}
    $data        = @{
                    InstanceID = $rule.InstanceID.ToString()
                    Direction  = $rule.Direction.ToString()
                    Action     = $rule.Action.ToString()
                    LocalAddress = $ruleaddress.LocalAddress -join ","
                    RemoteAddress = $ruleaddress.RemoteAddress -join ","
                    Protocol = $ruleport.Protocol.ToString()
                    LocalPort = $ruleport.LocalPort -join ","
                    RemotePort = $ruleport.RemotePort -join ","
                   }

    New-Object -TypeName psobject -Property $data
}
