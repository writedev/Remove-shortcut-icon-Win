$a = Read-Host "combien fait A ?"

while ($a -notmatch '^-?\d+$') {
    Write-Host "veulliez mettre un nombre"
    $a = Read-Host "combien fait A ?"
}

$b = Read-Host "combien fait B ?"

while ($b -notmatch '^-?\d+$') {
    Write-Host "veulliez mettre un nombre"
    $b = Read-Host "combien fait B ?"
}

if ($a -eq $b) {
    Write-Host "B est egal a A"
}
else {
    Write-Host "B n'est pas egal a A"
}