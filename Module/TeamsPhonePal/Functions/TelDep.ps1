function TelDep {
    param(
        [string]$Country,
        [string]$SBCFQDN,
        [string]$Land,
        [string]$Mob
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

    Add-PSTNUsage -CountryCode $Country
    Add-VRP -CountryCode $Country
    Add-VR -CountryCode $Country -SBC $SBCFQDN -FDM $FDM -FDL $FDL -MinLL $MinLL -MaxLL $MaxLL -MaxML $MaxML -MinML $MinML -Prefix $Prefix
}