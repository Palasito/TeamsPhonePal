function Add-VR {
    param(
        [string]$SBC,
        [string]$CountryCode,
        [string]$MinML,
        [string]$MinLL,
        [string]$MaxLL,
        [string]$MaxML,
        [string]$Prefix,
        [string]$FDL,
        [string]$FDM,
        [switch]$Seggregation,
        [switch]$International
    )

    #Region Parameters
    $CheckVR = (Get-CsOnlineVoiceRoute).Identity
    #EndRegion

    #Region Deployment with Seggregation
    if ($Seggregation -eq $true -and $CheckVR -notcontains "$($CountryCode)Landlines") {
        try {
            New-CsOnlineVoiceRoute -Identity "$($CountryCode)Landlines" -NumberPattern "^\$($Prefix)$($FDL)(\d{$($MinLL),$($MaxLL)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)LandlinesOnly" | Out-Null
            Write-Host "Voice Route: $($CountryCode)Landlines has been created successfully!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice route: $($CountryCode)Landlines! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($Seggregation -eq $true -and $CheckVR -contains "$($CountryCode)Landlines") {
        Write-Warning "Voice Route $($CountryCode)Landlines already exists ! Will not be created !"
    }

    if ($Seggregation -eq $true -and $CheckVR -notcontains "$($CountryCode)Mobiles") {
        try {
            New-CsOnlineVoiceRoute -Identity "$($CountryCode)Mobiles" -NumberPattern "^\$($Prefix)$($FDM)(\d{$($MinML),$($MaxML)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)MobilesOnly" | Out-Null
            Write-Host "Voice Route: $($CountryCode)Mobiles has been created successfully!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice route $($CountryCode)toInternational! Will not continue..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($Seggregation -eq $true -and $CheckVR -contains "$($CountryCode)Mobiles") {
        Write-Warning "Voice Route $($CountryCode)Mobiles already exists ! Will not be created !"
    }
    #EndRegion

    #Region Deployment Without Seggregation
    if ($Seggregation -eq $false -and $CheckVR -notcontains "$($CountryCode)") {
        try {
            New-CsOnlineVoiceRoute -Identity "$($CountryCode)" -NumberPattern "^\$($Prefix)(\d{$($MinLL),$($MaxML)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)" | Out-Null
            Write-Host "Voice Route: $($CountryCode) has been created successfully!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice route $($CountryCode)toInternational! Will not continue..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($Seggregation -eq $false -and $CheckVR -contains "$($CountryCode)") {
        Write-Warning "Voice Route $($CountryCode) already exists ! Will not be created !"
    }
    #EndRegion
    
    #Region Deployment with International
    if ($International -eq $true -and $CheckVR -notcontains "$($CountryCode)toInternational") {
        try {
            New-CsOnlineVoiceRoute -Identity "$($CountryCode)toInternational" -NumberPattern "^\+(\d{7})+" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)toInternational" | Out-Null
            Write-Host "Voice Route: $($CountryCode)toInternational has been created successfully!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice route $($CountryCode)toInternational! Will not continue..."
            Write-Warning "Please resolve error shown below!"
            $_
            throw
        }
    }
    elseif ($International -eq $true -and $CheckVR -contains "$($CountryCode)toInternational") {
        Write-Warning "Voice Route $($CountryCode)toInternational already exists ! Will not be created !"
    }
    #EndRegion
}