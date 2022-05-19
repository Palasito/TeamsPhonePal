function TeamsDeployment {

    # param(
    #     [string]$MC,
    #     [string]$SBCFQDN,
    #     [string]$Port,
    #     [string]$Land,
    #     [string]$Mob
    # )

    # Authentication
    Connect-MicrosoftTeams
    # End

    # Variables that need user definition
    [string]$MC = Read-Host "Specify Main country of Usage using ISO Code or Country Name"
    [string]$SBCFQDN = Read-Host "Specify the SBC FQDN"
    [string]$Port = Read-Host "Specify signalling port of SBC"
    [string]$Land = Read-host "Provide a test Landline phone for validation (excluding the country code eg. 2111122345)"
    [string]$Mob = Read-Host "Provide a test Mobile phone for validation (excluding the country code eg. 6911223456)"
    # End

    # Country Validation

    $val = CountryValidation -Country $MC

    if ($null -eq $val) {
        Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
        exit
    }
    elseif ($val.IsNullOrWhiteSpace) {
        Write-Host "Could not find country by Lookup. Consider looking up the ISO code and using it in the module" -ForegroundColor Red
        exit
    }
    else {
        Write-Host "Country Validation was successful" -ForegroundColor Green
    }
    # End

    # SBC Conf
    $checkSBC = Get-CsOnlinePSTNGateway -Identity $SBCFQDN -ErrorAction SilentlyContinue
    if ($null -eq $checkSBC) {
        try {
            $null = SBCConf -FQDN $SBCFQDN -Port $Port -ErrorAction SilentlyContinue
            Write-Host "SBC creation with FQDN $($SBCFQDN) was successful" -ForegroundColor Green
        }
        catch {
            Write-Host "SBC creation failed. Please check whether the FQDN provided is valid" -ForegroundColor Red
            exit
        }
    }
    # End

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
                    exit
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