function Add-PSTNUsage {
    param (
        [Mandatory]
        $MainCountryCode
    )

    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountryCode)" + "LandlinesOnly"}
    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountryCode)" + "LocalOnly"}
    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountryCode)" + "LocalOnly&Paid"}
    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="GeneralInternational"}
    
}