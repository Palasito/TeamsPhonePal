function Add-PSTNUsageMain {
    param (
        [Mandatory]
        $MainCountry
    )

    Set-CsOnlinePstnUsage -Identity Global -Usage @{add="$MainCountry"}
    
}