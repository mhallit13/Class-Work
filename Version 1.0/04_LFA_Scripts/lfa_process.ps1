$targets = Import-Csv ..\AllHosts.csv |
    Where-Object {$_.os -eq "Win10"} |
        Select-Object -ExpandProperty ip

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\01_Reference_Scripts\processes.ps1

$current | Sort-Object -Property pscomputername, hash -Unique |
    Group-Object hash |
        Where-Object {$_.count -le 2} |
            Select-Object -ExpandProperty Group
