function Add-VR {
    param(
        [string]$SBC,
        [string]$CountryCode,
        [string]$MinML,
        [string]$MinLL,
        [string]$MaxLL,
        [string]$MaxML,
        [string]$Prefix,
        [string]$FDL,
        [string]$FDM,
        [switch]$Seggregation,
        [switch]$International
    )

    if ($Seggregation -eq $true) {
        $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)Landlines" -NumberPattern "^\$($Prefix)$($FDL)(\d{$($MinLL),$($MaxLL)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)LandlinesOnly"
        $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)Mobiles" -NumberPattern "^\$($Prefix)$($FDM)(\d{$($MinML),$($MaxML)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)MobilesOnly"
    }
    else {
        $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)" -NumberPattern "^\$($Prefix)(\d{$($MinLL),$($MaxML)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)"
    }

    if ($International -eq $true) {
        $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)toInternational" -NumberPattern "^\+(\d{7})+" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)toInternational"
    }
    else {
        Write-Host "No international calling has been selected" -ForegroundColor Yellow
    }
    # $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)LocalPaid" -NumberPattern "^\$($Prefix)(\d{$($MinLL),$($MaxLL)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)LocalPaid"
    
}