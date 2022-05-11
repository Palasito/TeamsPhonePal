function Add-PSTNUsage {
    param (
        [Mandatory]
        $MainCountryCode
    )

    $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountryCode)" + "LandlinesOnly"}
    $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountryCode)" + "LocalOnly"}
    $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountryCode)" + "LocalOnly&Paid"}
    $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="GeneralInternational"}
    
}