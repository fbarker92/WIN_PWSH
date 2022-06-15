
# Check current profiles and their respective disk usage
Get-ChildItem -force 'C:\Users'-ErrorAction SilentlyContinue | Where-Object { $_ -is [io.directoryinfo] } | ForEach-Object {
    $len = 0
    Get-ChildItem -recurse -force $_.fullname -ErrorAction SilentlyContinue | ForEach-Object { $len += $_.length }
    $_.fullname, '{0:N2} GB' -f ($len / 1Gb)
    $sum = $sum + $len
}
“Total size of profiles”, '{0:N2} GB' -f ($sum / 1Gb)


# Load profiles to be protected from deletion (E.g Local Admin profiles, Director profiles etc.)
$ExcludedProfiles = "Default", "Public", "fbark", "ldadmin"

# Set age of profile before it will be removed (e.g. setting to 30 will delete profiles older than 30 days)
$ProfileAge = Read-Host "Set the maximum age of the profiles to remain on the disk (eg '30' days)"
$ProfileAge = - [int]$ProfileAge

#$useraccounts = ""
$LocalProfiles = Get-ChildItem -path C:\Users\ -Exclude $ExcludedProfiles | Where-Object lastwritetime -lt (Get-Date).AddDays($ProfileAge) | Select-Object name

# Read out profile(s) that will be delted
foreach ($LocalProfile in $LocalProfiles) {
    Write-host $LocalProfile.Name "'s", " profile will be deleted permanently!” -ForegroundColor Yellow
    #$useraccounts = $useraccounts + $LocalProfile.Name
}

# Confirmation of local profile deletion, confirmation must be 'YES'
$Challenge = Read-Host -prompt "Delete the above user profiles (yes/NO) "

if ($Challenge -like "YES") {
    #$RemoveAccounts = $useraccounts #| ForEach-Object { $_.Name }
    #$RemoveAccounts = $sort #-join "|"
    foreach($LocalProfile in $LocalProfiles){
        Get-CimInstance -Class Win32_userprofile | Where-Object { $_.LocalPath -match "$LocalProfile" } | Select-Object LocalPath
        Write-host $($LocalProfile.Name) "'s" " Profile Was Deleted" -ForegroundColor Red
    }
}elseif ($Challenge -ne "YES") {
    Write-Host "Exiting the script, the following profiles were NOT delted;" -ForegroundColor Green
    foreach ($LocalProfile in $LocalProfiles) {
        Write-host $LocalProfile.Name -ForegroundColor Green
    }
    Start-Sleep -Seconds 5
    #exit
}


##Get-CimInstance -Class Win32_userprofile | Where-Object { $_.LocalPath -match "$RemoveAccounts" } | Select-Object LocalPath
##Write-host $($RemoveAccounts) "'s" " Profile Was Deleted" -ForegroundColor Red
