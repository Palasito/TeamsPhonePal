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
            $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)LandlinesOnly" }
            Write-Host "PSTN Usage $($CountryCode)LandlinesOnly has been created successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)LandlinesOnly! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            exit
        }
    }
    elseif ($Seggregation -eq $true -and $ExistingPSTNUsage -notcontains "$($CountryCode)LandlinesOnly") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode)LandlinesOnly already exists and will not be created!!"
    }

    if ($Seggregation -eq $true -and $ExistingPSTNUsage -notcontains "$($CountryCode)MobilesOnly") {
        try {
            $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)MobilesOnly" }
            Write-Host "PSTN Usage $($CountryCode)MobilesOnly has been created successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)MobilesOnly! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            exit
        }
    }
    elseif ($Seggregation -eq $true -and $ExistingPSTNUsage -contains "$($CountryCode)MobilesOnly") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode)MobilesOnly already exists and will not be created!!"
    }
    #EndRegion

    #Region Deployment Without Seggregation
    if($Seggregation -eq $false -and $ExistingPSTNUsage -notcontains "$($CountryCode)") {
        try {
            $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)" }
            Write-Host "PSTN Usage $($CountryCode) has been created successfully!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            exit
        }
    }
    elseif($Seggregation -eq $false -and $ExistingPSTNUsage -contains "$($CountryCode)") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode) already exists and will not be created!!"
    }
    #EndRegion

    #Region International Switch
    if ($International -eq $true -and $ExistingPSTNUsage -notcontains "$($CountryCode)toInternational") {
        try {
            $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)toInternational" }
            Write-Host "PSTN Usage $($CountryCode)toInternational has been created successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create PSTN usage: $($CountryCode)toInternational! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            exit
        }
    }
    elseif($International -eq $true -and $ExistingPSTNUsage -contains "$($CountryCode)toInternational") {
        Write-Warning "PSTN Usage with the Name: $($CountryCode)toInternational already exists and will not be created!!"
    }
    #EndRegion
}