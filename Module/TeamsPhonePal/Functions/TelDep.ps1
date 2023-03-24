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
            try {
                Add-PSTNUsage -CountryCode $Country -International -Seggregation
                Add-VRP -CountryCode $Country -International -Seggregation
                Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix -International -Seggregation
            }
            catch {
                throw
            }
            break
        }
        $International {
            try {
                Add-PSTNUsage -CountryCode $Country -International
                Add-VRP -CountryCode $Country -International
                Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix -International
            }
            catch {
                throw
            }
            break
        }
        $Seggregation {
            try {
                Add-PSTNUsage -CountryCode $Country -Seggregation 
                Add-VRP -CountryCode $Country -Seggregation 
                Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix -Seggregation 
            }
            catch {
                throw
            }
            break
        }
        Default {
            try {
                Add-PSTNUsage -CountryCode $Country 
                Add-VRP -CountryCode $Country 
                Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix 
            }
            catch {
                throw
            }
            break
        }
    }
    #EndRegion
}