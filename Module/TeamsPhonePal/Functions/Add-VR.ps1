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
        [string]$FDM
    )

    $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)Landlines" -NumberPattern "^\$($Prefix)$($FDL)(\d{$($MinLL),$($MaxLL)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)LandlinesOnly"
    $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)Mobiles" -NumberPattern "^\$($Prefix)$($FDM)(\d{$($MinML),$($MaxML)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)MobilesOnly"
    # $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)LocalPaid" -NumberPattern "^\$($Prefix)(\d{$($MinLL),$($MaxLL)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)LocalPaid"
    $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)toInternational" -NumberPattern "^\+(\d{7})+" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)GeneralInternational"
}