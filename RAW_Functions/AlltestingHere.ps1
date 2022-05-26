function GetMSALToken {
    $authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default' -RedirectUri 'urn:ietf:wg:oauth:2.0:oob'
    $authHeader = @{
        'Content-Type'  = 'application/json'
        'Authorization' = "Bearer " + $authResult.AccessToken
        'ExpiresOn'     = $authResult.ExpiresOn
    }
    return $authHeader
}

function GetGraphToken {
    $global:authToken = GetMSALToken
}

function test {
    param(
        $Path
    )

    $testcsv = Import-Csv -Path $Path 

    return $testcsv
}

function CountryByISO {

    param(
        $CC
    )

    $CountryLookupHASH = [ordered]@{
        "AX"  = "+358"
        "AF"  = "+93"
        "AL"  = "+355"
        "DZ"  = "+213"
        "AD"  = "+376"
        "AO"  = "+244"
        "AI"  = "+1"
        "AG"  = "+1"
        "AR"  = "+54"
        "AM"  = "+374"
        "AW"  = "+297"
        "AU"  = "+61"
        "AT"  = "+43"
        "AZ"  = "+994"
        "BS"  = "+1"
        "BH"  = "+973"
        "BD"  = "+880"
        "BB"  = "+1"
        "BY"  = "+375"
        "BE"  = "+32"
        "BZ"  = "+501"
        "BJ"  = "+229"
        "BM"  = "+1"
        "BT"  = "+975"
        "BO"  = "+591"
        "BA"  = "+387"
        "BW"  = "+267"
        "BR"  = "+55"
        "IO"  = "+246"
        "BN"  = "+673"
        "BG"  = "+359"
        "BF"  = "+226"
        "BI"  = "+257"
        "KH"  = "+855"
        "CM"  = "+237"
        "CA"  = "+1"
        "CV"  = "+238"
        "KY"  = "+1"
        "CF"  = "+236"
        "TD"  = "+235"
        "CL"  = "+56"
        "CN"  = "+86"
        "CX"  = "+61"
        "CC"  = "+61"
        "CO"  = "+57"
        "KM"  = "+269"
        "CD"  = "+243"
        "CG"  = "+242"
        "CK"  = "+682"
        "CR"  = "+506"
        "HR"  = "+385"
        "CU"  = "+53"
        "AN"  = "+599"
        "CY"  = "+357"
        "CZ"  = "+420"
        "DK"  = "+45"
        "DJ"  = "+253"
        "DM"  = "+1"
        "DO"  = "+1"
        "EC"  = "+593"
        "EG"  = "+20"
        "SV"  = "+503"
        "GQ"  = "+240"
        "ER"  = "+291"
        "EE"  = "+372"
        "ET"  = "+251"
        "FK"  = "+500"
        "FO"  = "+298"
        "FJ"  = "+679"
        "FI"  = "+358"
        "FR"  = "+33"
        "GF"  = "+594"
        "TF"  = "+262"
        "PF"  = "+689"
        "GA"  = "+241"
        "GM"  = "+220"
        "GE"  = "+995"
        "DE"  = "+49"
        "GH"  = "+233"
        "GI"  = "+350"
        "GR"  = "+30"
        "GL"  = "+299"
        "GD"  = "+1"
        "GP"  = "+590"
        "GU"  = "+1"
        "GT"  = "+502"
        "GN"  = "+224"
        "GW"  = "+245"
        "GY"  = "+592"
        "HT"  = "+509"
        "HN"  = "+504"
        "HK"  = "+852"
        "HU"  = "+36"
        "IS"  = "+354"
        "IN"  = "+91"
        "ID"  = "+62"
        "IR"  = "+98"
        "IQ"  = "+964"
        "IE"  = "+353"
        "ISR" = "+972"
        "IT"  = "+39"
        "CI"  = "+225"
        "JM"  = "+1"
        "JP"  = "+81"
        "JO"  = "+962"
        "KZ"  = "+7"
        "KE"  = "+254"
        "KI"  = "+686"
        "KW"  = "+965"
        "KG"  = "+996"
        "LA"  = "+856"
        "LV"  = "+371"
        "LB"  = "+961"
        "LS"  = "+266"
        "LR"  = "+231"
        "LY"  = "+218"
        "LI"  = "+423"
        "LT"  = "+370"
        "LU"  = "+352"
        "MO"  = "+853"
        "MG"  = "+261"
        "MW"  = "+265"
        "MY"  = "+60"
        "MV"  = "+960"
        "ML"  = "+223"
        "MT"  = "+356"
        "MH"  = "+692"
        "MQ"  = "+596"
        "MR"  = "+222"
        "MU"  = "+230"
        "YT"  = "+262"
        "MX"  = "+52"
        "MD"  = "+373"
        "MC"  = "+377"
        "MN"  = "+976"
        "MS"  = "+1"
        "MA"  = "+212"
        "MZ"  = "+258"
        "MM"  = "+95"
        "NA"  = "+264"
        "NR"  = "+674"
        "NP"  = "+977"
        "NL"  = "+31"
        "NC"  = "+687"
        "NZ"  = "+64"
        "NI"  = "+505"
        "NE"  = "+227"
        "NG"  = "+234"
        "NU"  = "+683"
        "NF"  = "+672"
        "KP"  = "+850"
        "MK"  = "+389"
        "MP"  = "+1"
        "NO"  = "+47"
        "OM"  = "+968"
        "PK"  = "+92"
        "PW"  = "+680"
        "PA"  = "+507"
        "PG"  = "+675"
        "PY"  = "+595"
        "PER" = "+51"
        "PH"  = "+63"
        "PN"  = "+64"
        "PL"  = "+48"
        "PT"  = "+351"
        "PR"  = "+1"
        "QA"  = "+974"
        "RE"  = "+262"
        "RO"  = "+40"
        "RU"  = "+7"
        "RW"  = "+250"
        "SH"  = "+290"
        "KN"  = "+1"
        "LC"  = "+1"
        "PM"  = "+508"
        "VC"  = "+1"
        "SM"  = "+378"
        "ST"  = "+239"
        "SA"  = "+966"
        "SN"  = "+221"
        "CS"  = "+381"
        "SC"  = "+248"
        "SL"  = "+232"
        "SG"  = "+65"
        "SK"  = "+421"
        "SI"  = "+386"
        "SB"  = "+677"
        "SO"  = "+252"
        "ZA"  = "+27"
        "GS"  = "+500"
        "KR"  = "+82"
        "ES"  = "+34"
        "LK"  = "+94"
        "SD"  = "+249"
        "SR"  = "+597"
        "SJ"  = "+47"
        "SE"  = "+46"
        "CH"  = "+41"
        "SY"  = "+963"
        "TW"  = "+886"
        "TJ"  = "+992"
        "TZ"  = "+255"
        "TH"  = "+66"
        "TG"  = "+228"
        "TK"  = "+690"
        "TO"  = "+676"
        "TT"  = "+1"
        "TN"  = "+216"
        "TR"  = "+90"
        "TM"  = "+993"
        "TC"  = "+1"
        "TV"  = "+688"
        "AE"  = "+971"
        "UG"  = "+256"
        "UA"  = "+380"
        "GB"  = "+44"
        "US"  = "+1"
        "UY"  = "+598"
        "UZ"  = "+998"
        "VU"  = "+678"
        "VA"  = "+39"
        "VE"  = "+58"
        "VN"  = "+84"
        "WF"  = "+681"
        "EH"  = "+212"
        "YE"  = "+967"
        "ZM"  = "+260"
        "ZW"  = "+263"
    }

    return "$($CountryLookupHASH["$($CC)"];)"

}

function CountryLookup {

    param(
        $Country
    )

    # $Country = "United Kingdom"
    
    $AllCultures = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::SpecificCultures) # !AllCultures

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

    return $objs | Where-Object EnglishName -eq $Country | Select-Object -Unique TwoLetterISORegionName

}

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

# $t = test -Path "C:\Users\cpalavouzis\OneDrive - Officeline SA\Desktop\testcsv.csv"

# if ($t -is [array]){
#     Write-Host "It's an Array !"
# }
# else {
#     Write-Host "It's NOT an Array !"
# }

# $MC = "UK"

# $val = CountryValidation -Country "$($MC)"

# switch ($val) {
#     $null {
#         Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
#     }
#     {[string]::IsNullOrEmpty($_)} {
#         Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
#         break
#     }
#     {[string]::IsNullOrWhiteSpace($_)} {
#         Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
#     }
#     Default {
#         Write-Host $val
#         Write-Host "Country Validation for $($MC) was successful" -ForegroundColor Green
#     }
# }




GetGraphToken

$Dom = "MSDx110089.onmicrosoft.com"
$uri = "https://graph.microsoft.com/beta/domains/$($Dom)"

$dcheck = Invoke-RestMethod -Uri $uri -Method Get -Headers $authToken

Write-Host $dcheck

if ($dcheck.isVerified -eq "true") {
    Write-host "YES !"
}

# $uriu = "https://graph.microsoft.com/beta/users?$select=userPrincipalName"
# $ucheck = (Invoke-RestMethod -Uri $uriu -Method Get -Headers $authToken).value

# $u = $ucheck | Where-Object {$_.userPrincipalName -match 'bluebullet.racing'}

# Write-host $u