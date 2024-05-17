########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Compare Current AutoRuns to Baseline #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

$ht = @{
    ReferenceObject = Import-Csv -Path ..\02_Create_Baseline_Scripts\Win10AutoReg.csv
    Property        = "Key_ValueName"
    PassThru        = $true
}

$autorunkeys = Get-Content ..\AutoRunKeys.txt

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\00_Reference_Scripts\AutoReg.ps1 -ArgumentList (,$autorunkeys)

ForEach ($ip in $targets){
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip} |
            Sort-Object -Property Key_ValueName -Unique

    Compare-Object @ht |
        Where-Object {$_.sideindicator -eq "=>"}
}