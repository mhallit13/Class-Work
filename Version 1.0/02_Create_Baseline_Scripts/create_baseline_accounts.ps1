$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

ICM -CN $targets -CR $creds -FilePath ..\01_Reference_Scripts\accounts.ps1 | Export-Csv .\Win10AccountsBaseline.csv
