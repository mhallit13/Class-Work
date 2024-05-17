### Moving a File from your Local Computer to Remote Computer ###

$session = New-PSSession -ComputerName 192.168.0.1 -Credential $creds 

Copy-Item -Path .\file.name.txt -ToSession $session -Destination C:\Users\student\Documents\file.name.txt

Remove-PSSession *




### Moving a File from a Remote Computer to your Local Computer ###

$session = New-PSSession -ComputerName 192.168.0.1 -Credential $creds 

Copy-Item -Path C:\Users\student\Documents\file.name.txt -FromSession $session -Destination .

Remove-PSSession *


### Taking a Hash ###

Get-FileHash .\file.name.txt -Algorithm SHA1
Get-FileHash .\file.name.txt -Algorithm SHA256
Get-FileHash .\file.name.txt -Algorithm MD5
