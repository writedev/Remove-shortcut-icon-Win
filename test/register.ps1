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

# Définir le chemin de la clé de registre
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"

# Créer le dossier s'il n'existe pas
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Ajouter une nouvelle valeur (exemple)
# Remplace "3" et "C:\chemin\vers\ton\icone.ico" selon ton besoin
New-ItemProperty -Path $registryPath -Name "3" -Value "C:\chemin\vers\ton\icone.ico" -PropertyType String -Force

Read-Host "Press Enter to exit..."
exit