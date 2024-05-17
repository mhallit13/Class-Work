########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Compare Current Scheduled Tasks to Baseline #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

$ht = @{
    ReferenceObject = Import-Csv -Path ..\02_Create_Baseline_Scripts\Win10SchTasks.csv
    Property        = "taskname"
    PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\00_Reference_Scripts\SchTasks.ps1

ForEach ($ip in $targets){
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip} |
            Sort-Object -Property taskname -Unique

    Compare-Object @ht |
        Where-Object {$_.sideindicator -eq "=>"}
}