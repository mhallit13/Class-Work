########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Compare Current Processes to Baseline #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

$ht = @{
    ReferenceObject = Import-Csv -Path ..\02_Create_Baseline_Scripts\Win10Processes.csv
    Property        = "hash", "path"
    PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName win32_Process |
        Select-Object -Property ProcessName,
                                ProcessID,
                                Path,
                                CommandLine,
                                @{n="Hash";e={(Get-FileHash -Path $_.fullname).hash}}
}

ForEach ($ip in $targets){
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip} |
            Sort-Object -Property hash, path -Unique

    Compare-Object @ht |
        Where-Object {$_.sideindicator -eq "=>" -and $_.path -ne $null}
}