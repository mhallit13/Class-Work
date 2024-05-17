Invoke-Command -ComputerName 192.168.0.1 -Credential $creds -ScriptBlock {
    $logfilter = @{
        LogName   = "Security"
        ID        = 4720
        StartTime = [datetime]"08/05/2022 00:00:00z"
        EndTime   = [datetime]"08/05/2022 00:00:00z"
        #Data      = "<SID>" #This is if you want to look for events related to a specific user
    }

    Get-WinEvent -FilterHashtable $logfilter 

} | Select-Object -Property RecordID, Message |
    Format-Table -Wrap
