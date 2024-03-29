function Add-PSTNUsage {
    param (
        [string]$CountryCode
    )

    $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($CountryCode)LandlinesOnly"}
    $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($CountryCode)MobilesOnly"}
    # $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($CountryCode)LocalPaid"}
    $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($CountryCode)toInternational"}
    
}