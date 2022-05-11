function Add-PSTNUsageMain {
    param (
        [Mandatory]
        $MainCountry
    )

    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountry)" + "LandlinesOnly"}
    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountry)" + "LocalOnly"}
    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($MainCountry)" + "LocalOnly_Paid"}
    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="GeneralInternational"}
    
}