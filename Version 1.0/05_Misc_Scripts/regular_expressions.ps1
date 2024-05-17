Invoke-Command -ComputerName 192.168.0.1 -Credential $creds -ScriptBlock {
    $ssn     = "\d{3}-\d{2}-\d{4}"
    $email   = "[\w\.-]+@[\w\.-]+\.[\w]{2,3}"
    $keyword = "(?=.*Str1)(?=.*Str2|.*Str3)"
    $paths   = "C:Windows\System32\Hidden", "C:\Program Files\Downloads"

    Get-ChildItem $paths -Recurse -File -Force |
        Select-String -Pattern $ssn,$email,$keyword -AllMatches |
            Select-Object -Property Path, Line
}
