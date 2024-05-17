schtasks /query /V /FO CSV | ConvertFrom-Csv |
    Where-Object {$_."Scheduled Task State" -eq "Enabled"} |
        Select-Object -Property TaskName,
                                Status,
                                "Run As User",
                                "Schedule Time",
                                "Next Run Time",
                                "Last Run Time",
                                "Start Time",
                                "End Time",
                                "End Date",
                                "Task to Run",
                                @{n="Hash";e={(Get-FileHash -Path (($_."Task to Run") -replace '\"','' -replace "\.exe.*","exe") -ErrorAction SilentlyContinue).hash}}

