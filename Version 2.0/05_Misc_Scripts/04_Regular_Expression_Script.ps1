########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################



# Locating Specific Strings in File Locations #

Invoke-Command -ComputerName 192.168.0.1 -Credential $creds -ScriptBlock {
    $paths   = "C:Windows\System32\Hidden", "C:\Program Files\Downloads"
    $ssn     = "\d{3}-\d{2}-\d{4}"
    $email   = "[\w\.-]+@[\w\.-]+\.[\w]{2,3}"
    $address = "\d{1,5}\s\w.\s(\b\w*\b\s){1,2}\w*\."
    $keyword = "(?=.*Str1)(?=.*Str2|.*Str3)"
    
    Get-ChildItem $paths -Recurse -File -Force |
        Select-String -Pattern $ssn,$email,$address,$keyword -AllMatches |
            Select-Object -Property Path, Line
}
