function GetCSV {
    param(
        $ptocsv
    )

    try {
        $csv = Import-Csv -Path $ptocsv
        return $csv
    }
    catch {
        Write-Error $_
        break
    }

}