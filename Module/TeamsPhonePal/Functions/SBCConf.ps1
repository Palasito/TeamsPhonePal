function SBCConf {
    param(
        $FQDN,
        $Port,
        $LogFile
    )

    try {
        $null = New-CsOnlinePSTNGateway -FQDN $FQDN -SipSignalingPort $Port -Enabled $true -SendSipOptions $true
        Write-Host "SBC creation with FQDN $($SBCFQDN) was successful" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to create SBC: $($SBCFQDN)! Stopping deployment..."
        Write-Warning "Please resolve error shown below!"
        $_
        exit
    }
}