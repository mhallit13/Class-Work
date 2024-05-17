########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Create Baseline for Services #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -like "*2012*"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-Service
} | Export-Csv -Path .\WinSvr2012Services.csv