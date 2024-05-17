########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Least Frequency Analysis on Services #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -like "*2012*"} |
    Select-Object -ExpandProperty ip

$targets.count # Only needed to determine threshold

$svc = Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-Service
}

$svc | Sort-Object -Property pscomputername, servicename -Unique |
    Group-Object servicename |
        Where-Object {$_.count -le 1} |
            Select-Object -ExpandProperty Group