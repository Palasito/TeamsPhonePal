function CountryLookup {

    param(
        $Country
    )

    # $Country = "United Kingdom"
    
    $AllCultures = [System.Globalization.CultureInfo]::
    GetCultures(
        [System.Globalization.CultureTypes]::
        SpecificCultures) # !AllCultures

    $objs = @()
    $AllCultures | ForEach-Object {
        $dn = $_.DisplayName.Split("(|)")
        $RegionInfo = New-Object System.Globalization.RegionInfo $PsItem.name;
        $objs += [pscustomobject]@{
            Name                   = $RegionInfo.Name;
            EnglishName            = $RegionInfo.EnglishName;
            TwoLetterISORegionName = $RegionInfo.TwoLetterISORegionName;
            GeoId                  = $RegionInfo.GeoId;
            ISOCurrencySymbol      = $RegionInfo.ISOCurrencySymbol;
            CurrencySymbol         = $RegionInfo.CurrencySymbol;
            IsMetric               = $RegionInfo.IsMetric;
            LCID                   = $PsItem.LCID;
            Lang                   = $dn[0].Trim();
            Country                = $dn[1].Trim();
        }
    }

    return $objs | Where-Object EnglishName -eq $Country | Select-Object -Unique EnglishName, TwoLetterISORegionName

}