$targets = Import-Csv ..\AllHosts.csv |
    Where-Object {$_.os -eq "Win10"} |
        Select-Object -ExpandProperty ip

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\01_Reference_Scripts\autoruns.ps1 -ArgumentList (Get-Content ..\AutoRunKeys.txt)

$current | Sort-Object -Property pscomputername, Key_ValueName -Unique |
    Group-Object Key_ValueName |
        Where-Object {$_.count -le 2} |
            Select-Object -ExpandProperty Group
