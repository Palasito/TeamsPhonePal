function TelDep {
    param(
        [string]$Country,
        [string]$SBCFQDN,
        [string]$Land,
        [string]$Mob,
        [switch]$International,
        [switch]$Seggregation
    )

    #Region Convert Country Full Name to ISO
    if ($Country.Length -gt 2) {
        $Country = (CountryLookup -Country $Country).TwoLetterISORegionName
    }
    #EndRegion

    #Region Calculated Variables
    $Prefix = (CountryByISO -CC $Country)
    $FDM = $Mob[0]
    $FDL = $Land[0]
    $MobLength = $Mob.Length
    $LandLength = $Land.Length
    $MinML = $MobLength - 2
    $MaxML = $MobLength + 2
    $MinLL = $LandLength - 2
    $MaxLL = $LandLength + 2
    #Endregion

    #Region Deployment
    switch ($true) {
        { $International -and $Seggregation } {
            $null = Add-PSTNUsage -CountryCode $Country -International -Seggregation 
            $null = Add-VRP -CountryCode $Country -International -Seggregation 
            $null = Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix -International -Seggregation 
            break
        }
        $International {
            $null = Add-PSTNUsage -CountryCode $Country -International 
            $null = Add-VRP -CountryCode $Country -International 
            $null = Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix -International 
            break
        }
        $Seggregation {
            $null = Add-PSTNUsage -CountryCode $Country -Seggregation 
            $null = Add-VRP -CountryCode $Country -Seggregation 
            $null = Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix -Seggregation 
            break
        }
        Default {
            $null = Add-PSTNUsage -CountryCode $Country 
            $null = Add-VRP -CountryCode $Country 
            $null = Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix 
        }
    }
    #EndRegion
}