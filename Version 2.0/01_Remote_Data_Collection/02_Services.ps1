########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Service Data from Multiple Hosts #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -like "*2012*"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-Service
} | Export-Csv -Path .\WinSvr2012Services.csv



# Advanced Syntax #

$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -like "*2012*"} |
    Select-Object -ExpandProperty ip

Invoke-Command -ComputerName $targets -Credential $creds -ScriptBlock {
    Get-CimInstance -ClassName Win32_Service |
        Select-Object -Property @{n="ServiceName";e={$_.name}},
                                @{n="Status";e={$_.state}},
                                @{n="StartType";e={$_.startmode}},
                                @{n="Hash";e={(Get-FileHash -Path ($_.PathName -replace "\.exe.*",".exe" -replace '"', '')).hash}},
                                @{n="ProcessName";e={(Get-Process -Id $_.ProcessID).ProcessName}},
                                PathName,
                                ProcessId
} | Export-Csv -Path .\WinSvr2012Services.csv