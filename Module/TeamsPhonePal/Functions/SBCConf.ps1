function SBCConf {
    param(
        $FQDN,
        $Port
    )
    $null = New-CsOnlinePSTNGateway -FQDN $FQDN -SipSignalingPort $Port -Enabled $true -SendSipOptions $true
}