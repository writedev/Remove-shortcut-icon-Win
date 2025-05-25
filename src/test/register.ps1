#Ordinateur\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons


# Définir le chemin de la clé de registre
$registryPath = "Ordinateur\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"

# Créer la clé de registre si elle n'existe pas
if (-not (Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Définir le nom de la valeur et sa donnée
$valueName = "29"
$valueData = "MaDonnee"

# Ajouter la valeur à la clé de registre
New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType String -Force
