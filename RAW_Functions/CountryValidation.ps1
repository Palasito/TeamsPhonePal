# function CountryValidation {
    param(
        $Country
    )

    $Country = "UK"
    if ($Country.Length -gt 2) {
        $Country = (CountryLookup -Country $Country).TwoLetterISORegionName
    }
    else {
        $Country = CountryByISO -CC $Country
    }
    return $Country
# }
