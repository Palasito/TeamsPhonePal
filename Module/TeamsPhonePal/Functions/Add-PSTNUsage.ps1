function Add-PSTNUsage {
    param (
        [string]$CountryCode,
        [switch]$Seggregation,
        [switch]$International
    )

    #region Parameters
    $ExistingPSTNUsage = (Get-CsOnlinePstnUsage).Usage
    #endregion

    #Region Deployment With Seggregation
    if ($Seggregation -eq $true -and $ExistingPSTNUsage -notcontains "$($CountryCode)LandlinesOnly") {
        try {
            Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)LandlinesOnly" } | Out-Null
            Write-Host "PSTN Usage $($CountryCode)LandlinesOnly has been created successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)LandlinesOnly! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($Seggregation -eq $true -and $ExistingPSTNUsage -notcontains "$($CountryCode)LandlinesOnly") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode)LandlinesOnly already exists and will not be created!!"
    }

    if ($Seggregation -eq $true -and $ExistingPSTNUsage -notcontains "$($CountryCode)MobilesOnly") {
        try {
            Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)MobilesOnly" } | Out-Null
            Write-Host "PSTN Usage $($CountryCode)MobilesOnly has been created successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)MobilesOnly! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($Seggregation -eq $true -and $ExistingPSTNUsage -contains "$($CountryCode)MobilesOnly") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode)MobilesOnly already exists and will not be created!!"
    }
    #EndRegion

    #Region Deployment Without Seggregation
    if ($Seggregation -eq $false -and $ExistingPSTNUsage -notcontains "$($CountryCode)") {
        try {
            Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)" } | Out-Null
            Write-Host "PSTN Usage $($CountryCode) has been created successfully!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($Seggregation -eq $false -and $ExistingPSTNUsage -contains "$($CountryCode)") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode) already exists and will not be created!!"
    }
    #EndRegion

    #Region International Switch
    if ($International -eq $true -and $ExistingPSTNUsage -notcontains "$($CountryCode)toInternational") {
        try {
            Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)toInternational" } | Out-Null
            Write-Host "PSTN Usage $($CountryCode)toInternational has been created successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)toInternational! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($International -eq $true -and $ExistingPSTNUsage -contains "$($CountryCode)toInternational") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode)toInternational already exists and will not be created!!"
    }
    #EndRegion
}