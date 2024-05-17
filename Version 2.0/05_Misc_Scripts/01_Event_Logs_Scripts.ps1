########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################


# Viewing Event Logs to Find New Users #

Invoke-Command -ComputerName ws5.vaoc.net -Credential $creds -ScriptBlock {
    $logfilter = @{
        LogName   = "Security"
        ID        = 4720
        StartTime = [datetime]"01/01/2024 00:00:00z"
        EndTime   = [datetime]"01/02/2024 00:00:00z"
    }
    Get-WinEvent -FilterHashtable $logfilter
} | Select-Object -Property RecordID, Message |
        Format-Table -Wrap



# Viewing Event Logs to Find Security Groups #

Invoke-Command -ComputerName ws5.vaoc.net -Credential $creds -ScriptBlock {
    $logfilter = @{
        LogName   = "Security"
        ID        = 4728,4732,4756
        StartTime = [datetime]"01/01/2024 00:00:00z"
        EndTime   = [datetime]"01/02/2024 00:00:00z"
        Data      = "<SID of New User>"
    }
    Get-WinEvent -FilterHashtable $logfilter
} | Select-Object -Property RecordID, Message |
        Format-Table -Wrap



# Viewing Event Logs to Find New Firewall Rule #

Invoke-Command -ComputerName ws5.vaoc.net -Credential $creds -ScriptBlock {
    $logfilter = @{
        LogName   = "*fire*"
        ID        = 2004
        StartTime = [datetime]"01/01/2024 00:00:00z"
        EndTime   = [datetime]"01/02/2024 00:00:00z"
    }
    Get-WinEvent -FilterHashtable $logfilter
} | Select-Object -Property TimeCreated, RecordID, Message 



# Counting the Total Number of Specific Events #

Invoke-Command -ComputerName ws5.vaoc.net -Credential $creds -ScriptBlock {
    $logfilter = @{
        LogName   = "Security"
        ID        = 4624
        StartTime = [datetime]"01/01/2024 00:00:00z"
        EndTime   = [datetime]"01/02/2024 00:00:00z"
    }
    Get-WinEvent -FilterHashtable $logfilter
} | Measure-Object 
