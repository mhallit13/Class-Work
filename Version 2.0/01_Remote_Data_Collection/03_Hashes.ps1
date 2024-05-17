########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Hash Data from a Single Host #

Invoke-Command -ComputerName ws5.vaoc.net -Credential $creds -ScriptBlock {
    Get-ChildItem -Path "C:\Windows\System32" -Recurse |
        Where-Object {$_.Extension -in ".exe", ".dll"} |
            Select-Object -Property Name,
                                    FullName,
                                    @{n="Hash";e={(Get-FileHash -Path $_.fullname).hash}}
} | Export-Csv -Path .\WS5Hashes.csv


# Hash Data from a Mutliple Hosts #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -ne "Win7"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-ChildItem -Path "C:\Windows\System32" -Recurse |
        Where-Object {$_.Extension -in ".exe", ".dll"} |
            Select-Object -Property Name,
                                    FullName,
                                    @{n="Hash";e={(Get-FileHash -Path $_.fullname).hash}}
} | Export-Csv -Path .\Win32Hashes.csv