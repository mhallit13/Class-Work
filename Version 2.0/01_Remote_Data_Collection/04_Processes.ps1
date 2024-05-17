########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Process Data from Multiple Hosts #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName win32_Process |
        Select-Object -Property ProcessName,
                                ProcessID,
                                Path,
                                CommandLine,
                                @{n="Hash";e={(Get-FileHash -Path $_.fullname).hash}}
} | Export-Csv -Path .\Win10Processes.csv


# Advanced Syntax #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName win32_Process |
        Select-Object -Property ProcessName,
                                ProcessID,
                                Path,
                                CommandLine,
                                @{n="Hash";e={(Get-FileHash -Path $_.fullname).hash}},
                                @{n="ParentProcessName";e={(Get-Process -ErrorAction Ignore -Id $_.ParentProcessID).name}}
} | Export-Csv -Path .\Win10Processes.csv