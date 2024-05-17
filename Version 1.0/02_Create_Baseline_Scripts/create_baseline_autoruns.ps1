$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

ICM -CN $targets -CR $creds -FilePath ..\01_Reference_Scripts\autoruns.ps1 -ArgumentList (,(Get-Content .\Autoruns.txt)) | Export-Csv .\Win10AutoRunsBaseline.csv
