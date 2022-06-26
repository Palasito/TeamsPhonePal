function Add-VRP {
    param (
        [string]$CountryCode,
        [switch]$Seggregation,
        [switch]$International
    )

    if ($Seggregation -eq $true) {
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Landlines Only" -OnlinePstnUsages "$($CountryCode)LandlinesOnly"
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Local Only" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly"
        Write-host "Voice Route Policis: (Restricted to $($CountryCode)Landlines Only) and (Restricted to $($CountryCode)Local Only) has been successfully created!" -ForegroundColor Green
    }
    else {
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode) Only" -OnlinePstnUsages "$($CountryCode)"
        Write-host "Voice Route Policy: (Restricted to $($CountryCode) Only) has been successfully created!" -ForegroundColor Green
    }
    
    if ($International -eq $true) {
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Unrestricted $($CountryCode)Local to International" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly", "$($CountryCode)toInternational"
        Write-host "Voice Route Policy: (Unrestricted $($CountryCode)Local to International) has been successfully created!" -ForegroundColor Green
    }
    else {
        # Do nothing
    }

    
    # $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Local Only & Paid" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly", "$($CountryCode)LocalPaid"
    
}