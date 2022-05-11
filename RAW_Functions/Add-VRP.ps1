function Add-VRP {
    param (
        $MainCountryCode
    )

    New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to " + "$($MainCountryCode)" + "Landlines Only" -OnlinePstnUsages "$($MainCountryCode)" + "LandlinesOnly"
    New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to " + "$($MainCountryCode)" + "Local Only" -OnlinePstnUsages "$($MainCountryCode)" + "LocalOnly", "$($MainCountryCode)" + "LandlinesOnly"
    New-CsOnlineVoiceRoutingPolicy -Identity "Restricted to " + "$($MainCountryCode)" + "Local Only & Paid" -OnlinePstnUsages "$($MainCountryCode)" + "LocalOnly", "$($MainCountryCode)" + "LandlinesOnly", "$($MainCountryCode)" + "LocalOnly&Paid"
    New-CsOnlineVoiceRoutingPolicy -Identity "Unrestricted Local and International" -OnlinePstnUsages "$($MainCountryCode)" + "LocalOnly", "$($MainCountryCode)" + "LandlinesOnly", "$($MainCountryCode)" + "LocalOnly&Paid", "GeneralInternational"
}