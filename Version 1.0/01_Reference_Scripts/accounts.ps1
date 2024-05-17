Get-CimInstance -ClassName Win32_UserAccount |
    Select-Object -Property Name, Disabled, PasswordRequired, SID
