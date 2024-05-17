$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

ICM -CN $targets -CR $creds -FilePath ..\01_Reference_Scripts\scheduled_tasks.ps1 | Export-Csv .\Win10ScheduledTasksBaseline.csv
