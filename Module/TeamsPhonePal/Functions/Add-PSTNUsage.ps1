function Add-PSTNUsage {
    param (
        [string]$CountryCode,
        [switch]$Seggregation,
        [switch]$International
    )

    #region Parameters
    $ExistingPSTNUsage = (get-CsOnlinePstnUsage).Usage
    #endregion
    if ($Seggregation -eq $true) {
        if ($ExistingPSTNUsage -contains "$($CountryCode)LandlinesOnly") {
            # Do nothing
            Write-Host "Will not create local PSTN Usage. Please check whether a similar PSTN Usage with that name already exists (Name:$($CountryCode)LandlinesOnly)" -ForegroundColor Yellow
        }
        else {
            try {
                $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)LandlinesOnly" }
                Write-Host "PSTN Usage $($CountryCode)LandlinesOnly has been created successfully" -ForegroundColor Green
            }
            catch {
                Write-Host "PSTN Usage $($CountryCode)MobilesOnly could not be created" -ForegroundColor Yellow
            }
        }

        if ($ExistingPSTNUsage -contains "$($CountryCode)MobilesOnly") {
            Write-Host "Will not create local PSTN Usage. Please check whether a similar PSTN Usage with that name already exists (Name:$($CountryCode)MobilesOnly" -ForegroundColor Yellow
        }
        else {
            try {
                $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)MobilesOnly" }
                Write-Host "PSTN Usage $($CountryCode)MobilesOnly has been created successfully" -ForegroundColor Green
            }
            catch {
                Write-Host "PSTN Usage $($CountryCode)MobilesOnly could not be created" -ForegroundColor Yellow
            }
        }
    }

    else {
        if ($ExistingPSTNUsage -contains "$($CountryCode)LandlinesOnly") {
            try {
                $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)" }
                Write-Host "PSTN Usage $($CountryCode) has been created successfully!" -ForegroundColor Green
            }
            catch {
                Write-Host "Could not create local PSTN Usage. Please check whether a similar PSTN Usage with that name already exists (Name:$($CountryCode)" -ForegroundColor Red
            }
        }
    }

    if ($International -eq $true) {
        try {
            $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)toInternational" }
        }
        catch {
            Write-Host "Could not create International PSTN Usage. Please check whether a similar PSTN Usage with that name already exists (Name:$($CountryCode)toInternational" -ForegroundColor Red
        }
        
    }
    else {
        Write-Host "No International Calling from country $($CountryCode) has been setup !" -ForegroundColor Yellow
    }
}