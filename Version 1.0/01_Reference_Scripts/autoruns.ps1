param ([string][] $AutoRunKey)

foreach ($key in Get-Item -Path $AutoRunKey -ErrorAction SilentlyContinue){
    $data = $key.GetValueNames() |
        Select-Object -Property @{n="Key_Location"; e={$key}},
                                @{n="Key_ValueName"; e={$_}},
                                @{n="Key_Value"; e={$key.GetValue($_)}}

    if($null -ne $data){
    [pscustomobject]$data
    }

}
