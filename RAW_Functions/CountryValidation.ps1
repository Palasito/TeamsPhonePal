function CountryValidation {
    param(
        $Country
    )

    if ($Country.Length -gt 3) {
        $Country = (CountryLookup -Country $Country).TwoLetterISORegionName
    }
    else {
        $Country = CountryByISO -CC $Country
    }
    return $Country
}

$test = CountryValidation -Country UK
Write-Host $test
if ($null -eq $test) {
        Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
        break
    }
    elseif([string]::IsNullOrEmpty($test)) {
        Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
        break
    }
    elseif (([string]::IsNullOrWhiteSpace($test))) {
        Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
        break
    }
    else {
        Write-Host "Country Validation was successful" -ForegroundColor Green
    }

