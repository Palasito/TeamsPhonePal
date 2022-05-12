function TeamsDeployment {

    # Authentication
    Connect-MicrosoftTeams
    # End

    # Variables that need user definition
    $MC = Read-Host "Specify Main country of Usage using ISO Code or Country Name"
    $SBCFQDN = Read-Host "Specify the SBC FQDN"
    $Port = Read-Host "Specify signalling port of SBC"
    $Land = Read-host "Provide a test Landline phone for validation (excluding the country code eg. 2111122345)"
    $Mob = Read-Host "Provide a test Mobile phone for validation (excluding the country code eg. 6911223456)"
    # End

    # SBC Conf
    $null = SBCConf -FQDN $SBCFQDN -Port $Port
    # End

    # Telephony Conf
    $null = TelDep =Country $MC -SBCFQDN $SBCFQDN -Land $Land -Mob $Mob
    $confirmation = Read-Host "Do you want to create a set of rules for another Country? [y/n]"
    if ($confirmation -eq 'y*') {
        do {
            $NC = Read-Host "Specify new country of Usage using ISO Code or Country Name"
            $NS = Read-Host "Specify the SBC FQDN"
            $NP = Read-Host "Specify signalling port of SBC"
            $L = Read-host "Provide a test Landline phone for validation (excluding the country code eg. 2111122345)"
            $M = Read-Host "Provide a test Mobile phone for validation (excluding the country code eg. 6911223456)"

            try {

                $null = SBCConf -FQDN $NS -Port $NP
                $null = TelDep =Country $NC -SBCFQDN $NS -Land $L -Mob $M

            }
            catch {
                Write-host "SBC creation failed. Please check whether the FQDN provided is valid"
                break
            }
        }
        until ($confirmation -eq "n*")
    }
    # End

    $confirmation = Read-Host "Text Here! [y/n]"
    if ($confirmation -eq 'n') {
        # Do Nothing !
    }
    if ($confirmation -eq 'y') {

    }
}