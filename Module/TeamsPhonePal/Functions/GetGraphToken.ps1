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