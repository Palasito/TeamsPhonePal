function Add-PSTNUsage {
    param (
        [string]$CountryCode,
        [switch]$Seggregation,
        [switch]$International
    )

    if ($Seggregation -eq $true) {
        $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)LandlinesOnly" }
        $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)MobilesOnly" }
    }
    else {
        $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)" }
    }

    if ($International -eq $true) {
        $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add = "$($CountryCode)toInternational" }
    }
    else {
        Write-Host "No International Calling from country $($CountryCode) has been setup !" -ForegroundColor Yellow
    }


    # $null = Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$($CountryCode)LocalPaid"}

}