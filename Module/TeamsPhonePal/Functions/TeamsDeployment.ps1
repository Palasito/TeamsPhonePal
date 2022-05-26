function TeamsDeployment {

    param(
        # [string]$MC,
        # [string]$SBCFQDN,
        # [string]$Port,
        # [string]$Land,
        # [string]$Mob,
        $PathtoCSV
    )

    $csv = GetCSV -ptocsv "$($PathtoCSV)"

    # Check Prerequisite Modules
    PrerequisiteCheck
    # End

    # Authentication
    GetGraphToken
    Connect-MicrosoftTeams
    # End

    # Variables that need user definition
    # [string]$MC = Read-Host "Specify Main country of Usage using ISO Code or Country Name"
    # [string]$SBCFQDN = Read-Host "Specify the SBC FQDN"
    # [string]$Port = Read-Host "Specify signalling port of SBC"
    # [string]$Land = Read-host "Provide a test Landline phone for validation (excluding the country code eg. 2111122345)"
    # [string]$Mob = Read-Host "Provide a test Mobile phone for validation (excluding the country code eg. 6911223456)"
    # End

    foreach ($c in $csv) {

        # Variable Declaration
        [string]$MC = $c.Country
        [string]$SBCFQDN = $c.SBCFQDN
        [string]$Port = $c.Port
        [string]$Land = $c.LandlineExample
        [string]$Mob = $c.MobileExample
        [bool]$Seg = $c.Seggregation
        [bool]$Int = $c.International
        [string]$IBC = $c.InternationalByCountry
        $SBCList = Get-CsOnlinePSTNGateway
        # End

        # Country Validation
        $val = CountryValidation -Country "$($MC)"

        switch ($val) {
            $null {
                Write-Host "Could not find country $($MC) by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
            }
            { [string]::IsNullOrEmpty($_) } {
                Write-Host "Could not find country $($MC) by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
            }
            { [string]::IsNullOrWhiteSpace($_) } {
                Write-Host "Could not find country $($MC) by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
            }
            Default {
                Write-Host "Country Validation for $($MC) was successful" -ForegroundColor Green
            }
        }
        # End

        # Domain Validation
        $Dom = ValidateDomain -Domain $SBCFQDN
        $uri = "https://graph.microsoft.com/beta/domains/$($Dom)"
        $uriu = "https://graph.microsoft.com/beta/users?$select=userPrincipalName"

        $dcheck = Invoke-RestMethod -Uri $uri -Method Get -Headers $authToken
        if ($null -eq $dcheck.id) {
            Write-host "Domain for SBC does not exist in Tenant, configure the domain name first (Verification too)!" -ForegroundColor Yellow
            Write-Host "Do not forget to Add a user with a phone license and the new domain suffix before continuing!" -ForegroundColor Magenta
            break
        }
        elseif ($dcheck.isVerified -ne "true") {
            Write-host "Domain for SBC exists but is NOT verified in Tenant, verify the domain name first!" -ForegroundColor Yellow
            Write-Host "Do not forget to Add a user with a phone license and the new domain suffix before continuing!" -ForegroundColor Magenta
        }
        else {
            Write-Host "The Domain name $($Dom) is correctly configured and ready to be used with Teams Phone System"
        }
        


        $ucheck = Invoke-RestMethod -Uri $uriu -Method Get -Headers $authToken
        $u = $ucheck | Where-Object {$_.userPrincipalName -match "$($Dom)"}
        # End

        # SBC Conf
        $checkSBC = $SBCList | Where-Object { $_.Identity -eq $SBCFQDN }
        switch ($checkSBC.Identity) {
            $null {
                try {
                    $null = SBCConf -FQDN $SBCFQDN -Port $Port
                    Write-Host "SBC creation with FQDN $($SBCFQDN) was successful" -ForegroundColor Green
                }
                catch {
                    Write-Host "SBC creation failed. Please check whether the FQDN provided is valid" -ForegroundColor Red
                    break
                }
            }
            Default {
                # Do nothing, it already exists !
            }
        }
        # End

    }

    # Telephony Conf
    $null = TelDep -Country $MC -SBCFQDN $SBCFQDN -Land $Land -Mob $Mob
    Write-host "Telephony Rules were created successfully" -ForegroundColor Green
    # End
    





    $confirmation = Read-Host "Do you want to create a set of rules for another Country? [y/n]"
    if ($confirmation -eq 'y') {
        do {
            [string]$NC = Read-Host "Specify new country of Usage using ISO Code or Country Name"
            [string]$NS = Read-Host "Specify the SBC FQDN"
            [string]$NP = Read-Host "Specify signalling port of SBC"
            [string]$L = Read-host "Provide a test Landline phone for validation (excluding the country code eg. 2111122345)"
            [string]$M = Read-Host "Provide a test Mobile phone for validation (excluding the country code eg. 6911223456)"

            $checkSBC = Get-CsOnlinePSTNGateway -Identity $SBCFQDN -ErrorAction SilentlyContinue
            if ($null -eq $checkSBC) {
                try {
                    $null = SBCConf -FQDN $NS -Port $NP
                    Write-host "Creation of SBC with FQDN: $($NS) was successful" -ForegroundColor Green
                }
                catch {
                    Write-Host "SBC creation failed. Please check whether the FQDN provided is valid" -ForegroundColor Red
                    break
                }
            }

            try {
                $null = TelDep =Country $NC -SBCFQDN $NS -Land $L -Mob $M
                Write-host "Telephony Rules were created successfully" -ForegroundColor Green
            }
            catch {

                Write-host "SBC creation failed. Please check whether the FQDN provided is valid" -ForegroundColor Red
            }

        }
        until ($confirmation -eq "n")
    }
    # End

    # $confirmation = Read-Host "Text Here! [y/n]"
    # if ($confirmation -eq 'n') {
    #     # Do Nothing !
    # }
    # if ($confirmation -eq 'y') {

    # }
}