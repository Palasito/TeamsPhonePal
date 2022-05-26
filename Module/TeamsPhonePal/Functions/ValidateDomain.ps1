function ValidateDomain {
    param (
        $Domain
    )

    $d = @()
    $dn = @()
    $sep = "."
    $dt = 1

    $d += $Domain.Split(".")
    for ($dt = 1; $dt -lt $d.Length; $dt++) {
        $dn += $d[$dt]
    }

    $dn = [string]::Join($sep, $dn)

    
}