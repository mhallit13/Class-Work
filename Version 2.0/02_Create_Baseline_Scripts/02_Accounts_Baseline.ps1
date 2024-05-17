########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Create Baseline for User Accounts #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -ne "Win7"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName Win32_UserAccount
} | Export-Csv -Path .\LocalUserAccounts.csv