$targets = Import-Csv ..\AllHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip
    
$ht = @{
  ReferenceObject = Import-Csv ..\02_Create_Baseline_Scripts\Win10AccountsBaseline.csv
  Property        = "name"
  PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\01_Reference_Scripts\accounts.ps1

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
    Where-Object {$_.pscomputername -eq $ip} |
      Sort-Object -Property name -Unique
  Compare-Object @ht |
    Where-Object {$_.sideindicator -eq "=>"}
}
