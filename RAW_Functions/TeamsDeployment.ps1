function TeamsDeployment {

    # Authentication
    Connect-MicrosoftTeams

    # End Region

    $MainCountry = Read-Host "Please specify Main country of Usage"
    $SBCFQDN = Read-Host "Please specify the SBC FQDN"


    Add-PSTNUsage -MainCountryCode $MainCountry
    Add-VRP -MainCountryCode $MainCountry

    $confirmation = Read-Host "Text Here! [y/n]"
    if ($confirmation -eq 'n') {
        # Do Nothing !
    }
    if ($confirmation -eq 'y') {

    }
}