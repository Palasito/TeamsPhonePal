function TeamsDeployment {

    param(
        $PathtoCSV
    )

    if ($null -eq $PathtoCSV) {
        Write-Warning "CSV file path is null. Exiting..."
        break
    }
    elseif (-not (Test-Path $PathtoCSV)) {
        Write-Warning "CSV file could not be found. Exiting..."
        break
    }
    else {
        $csv = GetCSV -ptocsv "$PathtoCSV"
    }

    #region Check Prerequisite Modules
    PrerequisiteCheck
    #endregion

    Write-Host "Please wait for the Pop-Up to connect to the specified online services..." -ForegroundColor Cyan
    #region Authentication
    GetGraphToken | Out-Null
    Connect-MicrosoftTeams | Out-Null
    #endregion

    foreach ($c in $csv) {

        #region Variable Declaration
        [string]$MC = $c.Country
        [string]$SBCFQDN = $c.SBCFQDN
        [string]$Port = $c.Port
        [string]$Land = $c.LandlineExample
        [string]$Mob = $c.MobileExample
        $Seg = [Boolean]$c.Seggregation
        $Int = [Boolean]$c.International
        # IBC = $c.InternationalByCountry
        $SBCList = (Get-CsOnlinePSTNGateway).Identity
        #endregion

        #region Country Validation
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
        #endregion

        #region Domain and User Validation
        $Dom = ValidateDomain -Domain $SBCFQDN
        $uri = "https://graph.microsoft.com/beta/domains/$($Dom)"
        $uriu = "https://graph.microsoft.com/beta/users?$select=userPrincipalName"

        $dcheck = Invoke-RestMethod -Uri $uri -Method Get -Headers $authToken
        if ($null -eq $dcheck.id) {
            Write-host "Domain for SBC does not exist in Tenant, configure the domain name first (Verification too)!" -ForegroundColor Yellow
            Write-Host "Do not forget to Add a user with a phone license and the new domain suffix before continuing!" -ForegroundColor Magenta
            Pause 
            break
        }
        elseif ($dcheck.isVerified -ne "true") {
            Write-host "Domain for SBC exists but is NOT verified in Tenant, verify the domain name first!" -ForegroundColor Yellow
            Write-Host "Do not forget to Add a user with a phone license and the new domain suffix before continuing!" -ForegroundColor Magenta
            Pause
            break
        }
        else {
            Write-Host "The Domain name $($Dom) is correctly configured and ready to be used with Teams Phone System" -ForegroundColor Green
        }

        $ucheck = (Invoke-RestMethod -Uri $uriu -Method Get -Headers $authToken).value | Select-Object userPrincipalName
        $u = $ucheck | Where-Object { $_.userPrincipalName -match "$($Dom)" }
        $uresult = ""
        foreach ($user in $u) {
            if ((Get-CsOnlineUser $user.userPrincipalName).assignedplan -match 'MCOEV') {
                $uresult = "Success"
            }
        }
        if ($null -eq $u) {
            Write-host "Required user does not exist in Tenant, configure the user first (Licenses too)!" -ForegroundColor Yellow
            Pause 
            break
        }
        elseif ([string]::IsNullOrEmpty($uresult)) {
            Write-host "Required user exists but does NOT have a teams Phone System License, add the license to the user and try again!" -ForegroundColor Yellow
            Pause 
            break
        }
        else {
            Write-Host "Required user with suffix $($Dom) is correctly configured! Setup can proceed!" -ForegroundColor Green
        }
        #endregion

        Start-Sleep 10
        #region SBC Confex
        if ($SBCList -contains $SBCFQDN) {
            Write-Warning "SBC with identity $($SBCFQDN) already exists and will not be altered!"
        }
        else {
            SBCConf -FQDN $SBCFQDN -Port $Port
        }
        # switch ($checkSBC.Identity) {
        #     $null {
        #         $null = SBCConf -FQDN $SBCFQDN -Port $Port
        #     }
        #     Default {
        #         # Do nothing, it already exists !
        #     }
        # }
        #endregion
    

        Start-Sleep 10
        #Region Telephony Conf
        switch ($true) {
            { $Int -and $Seg } {
                try {
                    TelDep -Country $MC -SBCFQDN $SBCFQDN -Land $Land -Mob $Mob -International -Seggregation 
                    Write-host "All Telephony Rules were created successfully" -ForegroundColor Green
                }
                catch {
                    throw
                }
                break
            }
            $Int {
                try {
                    TelDep -Country $MC -SBCFQDN $SBCFQDN -Land $Land -Mob $Mob -International 
                    Write-host "All Telephony Rules were created successfully" -ForegroundColor Green
                }
                catch {
                    throw
                }
                break
            }
            $Seg {
                try {
                    TelDep -Country $MC -SBCFQDN $SBCFQDN -Land $Land -Mob $Mob -Seggregation 
                    Write-host "All Telephony Rules were created successfully" -ForegroundColor Green
                }
                catch {
                    throw
                }
                break
            }
            Default {
                try {
                    TelDep -Country $MC -SBCFQDN $SBCFQDN -Land $Land -Mob $Mob 
                    Write-host "All Telephony Rules were created successfully" -ForegroundColor Green
                }
                catch {
                    throw
                }
            }
        }
        #EndRegion

        # $confirmation = Read-Host "Text Here! [y/n]"
        # if ($confirmation -eq 'n') {
        #     # Do Nothing !
        # }
        # if ($confirmation -eq 'y') {

        # }
    }
}