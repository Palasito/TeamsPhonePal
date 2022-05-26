function GetCSV {
    param(
        $ptocsv
    )

    $csv = Import-Csv -Path $ptocsv

    return $csv
}