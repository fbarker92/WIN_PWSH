# Set local profiles to be protected from deletion
$ExcludedProfiles = "Default", "Public", "fbark", "ldadmin"

# Load local profiles from Users folder
$LocalProfiles = Get-ChildItem -path C:\Users\ -Exclude $ExcludedProfiles | Where-Object lastwritetime -lt (Get-Date).AddDays(4) | Select-Object name

if ($LocalProfiles.count -ne 0) {
    foreach ($LocalProfile in $LocalProfiles) {
        Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.LocalPath -match $LocalProfile.Name} | Remove-CimInstance
    }
    else {
        exit
        }
    }