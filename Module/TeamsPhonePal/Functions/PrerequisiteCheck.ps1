function PrerequisiteCheck {

    # Get Required Modules
    $M = Get-Module "MSAL.PS" -ListAvailable
    $T = Get-Module "MicrosoftTeams" -ListAvailable
    # End
    
    # Check MSAL Module
    if ($null -eq $M) {
        $conf = Read-host "You need to install the MSAL.PS Module in order to continue. Would you like to install the module now ? [y/n]"
        if ($conf -eq $y) {
            Install-Module MSAL.PS
        }
        else {
            Write-Host "Did not receive confirmation! Terminating..." -ForegroundColor Red
            break
        }
    }
    elseif ($M.Version -lt "4.37.0.0") {
        $conf = Read-host "You need to update the MSAL.PS Module in order to continue. Would you like to update the module now ? [y/n]"
        Update-Module "MSAL.PS" -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-host "MSAL Module has passed the prerequisite checks !" -ForegroundColor Green
    }
    # End

    # Check MicrosoftTeams Module
    if ($null -eq $T) {
        $conf = Read-host "You need to install the MicrosoftTeams Module in order to continue. Would you like to install the module now ? [y/n]"
        if ($conf -eq $y) {
            Install-Module MicrosoftTeams
        }
        else {
            Write-Host "Did not receive confirmation! Terminating..." -ForegroundColor Red
            break
        }
    }
    elseif ($T.Version -lt "4.3.0") {
        $conf = Read-host "You need to update the MicrosoftTeams Module in order to continue. Would you like to update the module now ? [y/n]"
        Update-Module "MicrosoftTeams" -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-host "MicrosoftTeams Module has passed the prerequisite checks !" -ForegroundColor Green
    }
    # End

}