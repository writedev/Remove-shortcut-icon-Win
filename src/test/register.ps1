#Ordinateur\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons

# Vérifie si le script est exécuté avec des droits d'administrateur
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Crée un nouvel objet StartInfo pour le processus PowerShell
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell.exe"
    $startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    $startInfo.Verb = "runas" # Indique que le script doit être exécuté en tant qu'administrateur

    # Lance le processus
    try {
        [System.Diagnostics.Process]::Start($startInfo)
    } catch {
        Write-Warning "Elevation of privileges failed. The script must be run as an administrator."
    }

    # Quitte le script actuel
    exit
}

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

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

Read-Host "Press Enter to exit..."
exit