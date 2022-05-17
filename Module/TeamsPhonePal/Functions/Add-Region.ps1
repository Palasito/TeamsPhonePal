function Add-Region {
    param(
        $Region
    )

    $null = New-CsTenantNetworkRegion -NetworkRegionID $Region
}