# Import Active Directory Module
Import-Module ActiveDirectory

# Import User Data
$csv = Import-Csv -Path C:\Users\daltamirano\Documents\adusers.csv

# Path to the Security Groups OU
$groupOU = "OU=Groups,OU=Corp,DC=amce,DC=local"

# Import unique department names
$groups = $csv.Department | Select-Object -Unique

foreach ($group in $groups) {

    # Info for Global group creation
    $GlobalGroupInfo = @{
        Name             = "$group Users"
        SamAccountName   = $group.ToLower() + "_users"
        Path             = $groupOU
        GroupScope       = "Global" 
        GroupCategory    = "Security" 
        Description      = "Members of this group work in the $group Department"
    }

    # Info for Domain Local group creation
    $DomainLocalGroupInfo = @{
        Name             = "$group Resources"
        SamAccountName   = $group.ToLower() + "_resources"
        Path             = $groupOU
        GroupScope       = "DomainLocal" 
        GroupCategory    = "Security" 
        Description      = "Security Group used to manage access to the $group Department's resources"
        }

        New-ADGroup @GlobalGroupInfo 
        New-ADGroup @DomainLocalGroupInfo         
    }
