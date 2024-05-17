########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Local User Accounts from Single Host #

Invoke-Command -ComputerName ws8.vaoc.net -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName Win32_UserAccount
} | Export-Csv -Path .\WS8UserAccounts.csv


# Local User Accounts from Multiple Hosts #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -ne "Win7"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName Win32_UserAccount
} | Export-Csv -Path .\LocalUserAccounts.csv


# Domain User Account Data from Domain Controller #

Get-ADUser -Server dc1.vaoc.net -Credential $creds -Filter * |
    Where-Object enabled | Export-Csv -Path .\VAOC-DomainUsers.csv


# Domain Computer Data from Domain Controller #

Get-ADComputer -Server dc1.vaoc.net -Credential $creds -Filter * |
    Where-Object enabled | Export-Csv -Path .\VAOC-DomainComputers.csv


# Counting How Many Entries in CSVs #

Import-Csv -Path .\VAOC-DomainComputers.csv | Measure-Object