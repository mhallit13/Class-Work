########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Least Frequency Analysis on Processes #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

$targets.count # Only needed to determine threshold

$procs = Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName win32_Process |
        Select-Object -Property ProcessName,
                                ProcessID,
                                Path,
                                CommandLine,
                                @{n="Hash";e={(Get-FileHash -Path $_.fullname).hash}}
}

$procs | Sort-Object -Property pscomputername, hash -Unique |
    Group-Object hash |
        Where-Object {$_.count -le 1} |
            Select-Object -ExpandProperty Group