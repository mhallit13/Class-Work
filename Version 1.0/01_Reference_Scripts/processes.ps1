Get-CimInstance -ClassName Win32_Process |
    Select-Object -Property ProcessName,
                            ProcessID,
                            Path,
                            CommandLine,
                            @{n="Hash"; e={(Get-FileHash -Path $_.path).hash}}
