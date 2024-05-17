########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Established Connections from Multiple Hosts to Specific Host #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-NetTCPConnection |
        Where-Object {$_.state -eq "Established" -and $_.RemoteAddress -eq "192.168.52.99"}
}


# Established Connections from Multiple Hosts to Specific Host and not Specific Ports #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-NetTCPConnection |
        Where-Object {$_.state -eq "Established" -and $_.RemoteAddress -eq "192.168.52.99" -and $_.LocalPort -ne 6666 -and $_.RemotePort -ne 9999}
}