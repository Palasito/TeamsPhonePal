function Add-VRP {
    param (
        [string]$CountryCode,
        [switch]$Seggregation,
        [switch]$International
    )

    if ($Seggregation -eq $true) {
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Landlines Only" -OnlinePstnUsages "$($CountryCode)LandlinesOnly"
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Local Only" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly"
    }
    else {
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode) Only" -OnlinePstnUsages "$($CountryCode)"
    }
    
    if ($International -eq $true) {
        $null = New-CsOnlineVoiceRoutingPolicy -Identity "Unrestricted $($CountryCode)Local to International" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly", "$($CountryCode)toInternational"
    }
    else {
        
    }

    
    # $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Local Only & Paid" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly", "$($CountryCode)LocalPaid"
    
}