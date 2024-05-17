Invoke-Command -ComputerName 192.168.0.1 -Credential $creds -ScriptBlock {
    $Paths = "C:Windows\System32\Hidden", "C:\Program Files\Downloads"
    Get-ChildItem -Path $Paths -Recurse -File -Force
} 
