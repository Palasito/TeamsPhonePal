function Add-Sites {
    param(
        $SiteID,
        $Region,
        $Address
    )

    $null = New-CsTenantNetworkSite -NetworkSiteID $SiteID -NetworkRegionID $Region -SiteAddress $Address 
}