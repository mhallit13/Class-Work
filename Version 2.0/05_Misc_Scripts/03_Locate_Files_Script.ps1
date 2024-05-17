########################################################
# Be sure to have a $creds variable for these scripts. #
# This will need to be admin credentials for machines  #
# you want to get information from.                    #
#                                                      #
# $creds = Get-Credential                              #
########################################################



# Locating All Files in Directories #

Invoke-Command -ComputerName 192.168.0.1 -Credential $creds -ScriptBlock {
    $Paths = "C:Windows\System32\Hidden", "C:\Program Files\Downloads"
    Get-ChildItem -Path $Paths -Recurse -File -Force
} 
