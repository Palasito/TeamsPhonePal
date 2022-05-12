function Add-VR {
    param(
        $SBC,
        $CountryCode,
        $MinML,
        $MinLL,
        $MaxLL,
        $MaxML,
        $Prefix,
        $FDL,
        $FDM
    )

    $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)Landlines" -NumberPattern "^\$($Prefix)$($FDL)(\d{$($MinLL),$($MaxLL)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)LandlinesOnly"
    $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)Mobiles" -NumberPattern "^\$($Prefix)$($FDM)(\d{$($MinML),$($MaxML)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)MobilesOnly"
    $null = New-CsOnlineVoiceRoute -Identity "$($CountryCode)LocalPaid" -NumberPattern "^\$($Prefix)(\d{$($MinLL),$($MaxLL)})$" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "$($CountryCode)LocalPaid"
    $null = New-CsOnlineVoiceRoute -Identity "International" -NumberPattern "^\+(\d{7})+" -OnlinePstnGatewayList $SBC -Priority 1 -OnlinePstnUsages "GeneralInternational"
}