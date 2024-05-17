########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Compare Current User Accounts to Baseline #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -ne "Win7"} |
    Select-Object -ExpandProperty ip

$ht = @{
    ReferenceObject = Import-Csv -Path ..\02_Create_Baseline_Scripts\LocalUserAccounts.csv
    Property        = "name"
    PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName Win32_UserAccount
}

ForEach ($ip in $targets){
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip} |
            Sort-Object -Property name -Unique

    Compare-Object @ht |
        Where-Object {$_.sideindicator -eq "=>"}
}