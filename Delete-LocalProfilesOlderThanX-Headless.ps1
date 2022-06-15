$ExcludedProfiles = "Default", "Public", "fbark", "ldadmin"

$LocalProfiles = Get-ChildItem -path C:\Users\ -Exclude $ExcludedProfiles | Where-Object lastwritetime -lt (Get-Date).AddDays(0) | Select-Object name

    foreach($LocalProfile in $LocalProfiles){
        Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.LocalPath -match $LocalProfile.Name} | Remove-CimInstance
    }
