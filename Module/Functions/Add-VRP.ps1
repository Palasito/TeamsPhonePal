function Add-VRP {
    param (
        $CountryCode
    )

    $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Landlines Only" -OnlinePstnUsages "$($CountryCode)LandlinesOnly"
    $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Local Only" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly"
    $null = New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to $($CountryCode)Local Only & Paid" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly", "$($CountryCode)LocalPaid"
    $null = New-CsOnlineVoiceRoutingPolicy -Identity "Unrestricted Local and International" -OnlinePstnUsages "$($CountryCode)MobilesOnly", "$($CountryCode)LandlinesOnly", "$($CountryCode)LocalPaid", "GeneralInternational"
}