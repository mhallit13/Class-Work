########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Scheduled Tasks from Multiple Hosts #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\00_Reference_Scripts\SchTasks.ps1 |
    Export-Csv -Path .\Win10SchTask.csv