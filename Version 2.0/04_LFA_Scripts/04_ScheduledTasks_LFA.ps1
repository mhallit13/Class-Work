########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Least Frequency Analysis on Scheduled Tasks #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

$ht = @{
    ReferenceObject = Import-Csv -Path ..\02_Create_Baseline_Scripts\Win10SchTasks.csv
    Property        = "taskname"
    PassThru        = $true
}

$task = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\00_Reference_Scripts\SchTasks.ps1

$task | Sort-Object -Property pscomputername, taskname -Unique |
    Group-Object taskname |
        Where-Object {$_.count -le 1} |
            Select-Object -ExpandProperty Group