function TeamsDeployment {

    # Authentication
    Connect-MicrosoftTeams

    # End Region

    $MainCountry = Read-Host "PLease specify Main country of Usage"

    $confirmation = Read-Host "Text Here! [y/n]"
    if ($confirmation -eq 'n') {
        # Do Nothing !
    }
    if ($confirmation -eq 'y') {

    }
}