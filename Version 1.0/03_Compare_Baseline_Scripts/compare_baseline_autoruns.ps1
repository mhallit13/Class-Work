$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -like "*2012*"} |
    Select-Object -ExpandProperty ip
    
$ht = @{
  ReferenceObject = Import-Csv ..\02_Create_Baseline_Scripts\Win10AutoRunsBaseline.csv
  Property        = "Key_ValueName"
  PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\01_Reference_Scripts\autoruns.ps1 -ArgumentList (,(Get-Content ..\Autorunkeys.txt))

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
    Where-Object {$_.pscomputername -eq $ip} |
      Sort-Object -Property Key_Valuename -Unique
  Compare-Object @ht |
    Where-Object {$_.sideindicator -eq "=>"}
}
