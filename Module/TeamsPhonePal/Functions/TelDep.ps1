function TelDep {
    param(
        [string]$Country,
        [string]$SBCFQDN,
        [string]$Land,
        [string]$Mob
    )

    if ($Country.Length -gt 2) {
        $Country = (CountryLookup -Country $Country).TwoLetterISORegionName
    }

    # Calculated Variables
    $Prefix = (CountryByISO -CC $Country)
    $FDM = $Mob[0]
    $FDL = $Land[0]
    $MobLength = $Mob.Length
    $LandLength = $Land.Length
    $MinML = $MobLength - 1
    $MaxML = $MobLength + 1
    $MinLL = $LandLength - 1
    $MaxLL = $LandLength + 1
    # End

    Add-PSTNUsage -CountryCode $Country
    Add-VRP -CountryCode $Country
    Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix
}