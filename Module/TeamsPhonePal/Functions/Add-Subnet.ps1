function Add-Subnet {
    param(
        $Subnet,
        $Mask,
        $SiteID
    )

    $null = New-CsTenantNetworkSubnet -SubnetID $Subnet -MaskBits $Mask -NetworkSiteID $SiteID
}