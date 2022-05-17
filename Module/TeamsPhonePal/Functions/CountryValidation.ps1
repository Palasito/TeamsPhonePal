function CountryValidation {
    param(
        $Country
    )

    if ($Country.Length -gt 2) {
        $Country = (CountryLookup -Country $Country).TwoLetterISORegionName
    }
    else {
        $Country = CountryByISO -CC $Country
    }
    return $Country
}
