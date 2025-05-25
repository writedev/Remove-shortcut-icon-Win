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

try {
    $dependance = Read-Host "Voulez-vous choisir l'emplacement des dépendances ? y/n"

    if ($dependance -eq "y") {
        Add-Type -AssemblyName System.Windows.Forms
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.Description = "Choisissez un dossier"
        if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $dependancefilePath = $dialog.SelectedPath
        } else {
            Write-Output "Aucun dossier sélectionné."
            exit
        }
    } elseif ($dependance -eq "n") {
        $dependancefilePath = "$env:USERPROFILE\AppData\Roaming\monFichier.txt"
    } else {
        Write-Output "Réponse non reconnue. Utilisation du chemin par défaut."
        $dependancefilePath = "$env:USERPROFILE\AppData\Roaming\NotArrow"
    }

    Write-Host "Les dépendances sont sur le chemin : $dependancefilePath"
    Read-Host "Appuyez sur Entrée pour quitter..."
    exit

} catch {
    Write-Error "Une erreur est survenue : $_"s
    Read-Host "Appuyez sur Entrée pour quitter..."
    exit
}
