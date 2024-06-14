param ([string[]]$AutoRunKeys)

ForEach ($Key in Get-Item -Path $AutoRunKeys -ErrorAction SilentlyContinue){
    $Key.GetValueNames() |
        Select-Object -Property @{n="Key_Location";e={$Key}},
                                @{n="Key_ValueName";e={$_}},
                                @{n="Key_Value";e={$Key.GetValue($_)}}
}
