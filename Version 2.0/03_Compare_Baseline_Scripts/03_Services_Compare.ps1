########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Compare Current Services to Baseline #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -like "*2012*"} |
    Select-Object -ExpandProperty ip

$ht = @{
    ReferenceObject = Import-Csv -Path ..\02_Create_Baseline_Scripts\WinScr2012Services.csv
    Property        = "ServiceName"
    PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-Service
}

ForEach ($ip in $targets){
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip} |
            Sort-Object -Property ServiceName -Unique

    Compare-Object @ht |
        Where-Object {$_.sideindicator -eq "=>"}
}