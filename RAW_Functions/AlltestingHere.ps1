function test {
    param(
        $Path
    )

    $testcsv = Import-Csv -Path $Path 

    return $testcsv
}

$t = test -Path "C:\Users\cpalavouzis\OneDrive - Officeline SA\Desktop\testcsv.csv"

if ($t -is [array]){
    Write-Host "It's an Array !"
}
else {
    Write-Host "It's NOT an Array !"
}