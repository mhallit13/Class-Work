########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Least Frequency Analysis on AutoRuns #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

$targets.count # Only needed to determine threshold

$autorunkeys = Get-Content ..\AutoRunKeys.txt

$auto = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\00_Reference_Scripts\AutoReg.ps1 -ArgumentList (,$autorunkeys)

$auto | Sort-Object -Property pscomputername, Key_ValueName -Unique |
    Group-Object Key_ValueName |
        Where-Object {$_.count -le 1} |
            Select-Object -ExpandProperty Group