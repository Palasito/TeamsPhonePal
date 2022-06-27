function Add-VRP {
    param (
        [string]$CountryCode,
        [switch]$Seggregation,
        [switch]$International
    )

    #Region Parameters
    $CheckVRP = (Get-CsOnlineVoiceRoutingPolicy).Identity
    #EndRegion

    #Region Deployment with Seggregation
    if ($Seggregation -eq $true -and $CheckVRP -notcontains "Tag:Restricted to $($CountryCode)Landlines Only") {
        try {
            $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Landlines Only" -OnlinePstnUsages "$($CountryCode)LandlinesOnly"
            Write-host "Voice Route Policy: (Restricted to $($CountryCode)Landlines Only) has been successfully created!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice routing policy: Restricted to $($CountryCode)Landlines Only! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_ 
            exit
        }
    }
    elseif ($Seggregation -eq $true -and $CheckVRP -contains "Tag:Restricted to $($CountryCode)Landlines Only") {
        Write-Warning "Voice Routing Policy: (Restricted to $($CountryCode)Landlines Only) already exists and will not be created!"
    }

    if ($Seggregation -eq $true -and $CheckVRP -notcontains "Tag:Restricted to $($CountryCode)Local Only") {
        try {
            $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Local Only" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly"
            Write-host "Voice Route Policy: (Restricted to $($CountryCode)Local Only) has been successfully created!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice routing policy: Restricted to $($CountryCode)Local Only! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_
            exit
        }
    }
    elseif ($Seggregation -eq $true -and $CheckVRP -contains "Tag:Restricted to $($CountryCode)Local Only") {
        Write-Warning "Voice Routing Policy: (Restricted to $($CountryCode)Local Only) already exists and will not be created!"
    }
    #EndRegion
    
    #Region Deployment without Seggregation
    if ($Seggregation -eq $false -and $CheckVRP -notcontains "Tag:Restricted to $($CountryCode) Only") {
        try {
            $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode) Only" -OnlinePstnUsages "$($CountryCode)"
            Write-host "Voice Route Policy: (Restricted to $($CountryCode) Only) has been successfully created!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice routing policy: Restricted to $($CountryCode) Only! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_ 
            exit
        }
    }
    elseif ($Seggregation -eq $false -and $CheckVRP -contains "Tag:Restricted to $($CountryCode) Only") {
        Write-Warning "Voice Routing Policy: (Restricted to $($CountryCode) Only) already exists and will not be created!"
    }
    #EndRegion
    
    #Region Deployment with International
    if ($International -eq $true -and $CheckVRP -notcontains "Tag:Unrestricted $($CountryCode)Local to International") {
        try {
            $null = New-CsOnlineVoiceRoutingPolicy -Identity "Unrestricted $($CountryCode)Local to International" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly", "$($CountryCode)toInternational"
            Write-host "Voice Route Policy: (Unrestricted $($CountryCode)Local to International) has been successfully created!" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to create voice routing policy: Unrestricted $($CountryCode)Local to International! Stopping deployment..."
            Write-Warning "Please resolve error shown below!"
            $_ 
            exit
        }
    }
    elseif ($International -eq $true -and $CheckVRP -contains "Tag:Unrestricted $($CountryCode)Local to International") {
        Write-Warning "Voice Routing Policy: (Unrestricted $($CountryCode)Local to International) already exists and will not be created!"
    }
    #EndRegion
}