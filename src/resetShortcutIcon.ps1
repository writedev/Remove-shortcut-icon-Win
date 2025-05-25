
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

Read-Host "Press enter if you want reset the shortcut icon Windows"

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"

try {
    if (Test-Path $registryPath) {
        Remove-Item -Path $registryPath -Recurse -Force
        Write-Host "Clé supprimée : $registryPath"
    } else {
        Write-Host "La clé n'existe pas : $registryPath"
    }
}
catch {
    Write-Error "Erreur lors de la suppression : $_"
}

try {
    $restartBool = Read-Host "would you like to restart your computer now ? y/n"
    if ($restartBool -eq "y"){
        try {
            Restart-Computer
        } catch{
                Write-Error "An error has occurred : $_"
                Read-Host "Press Enter to exit..."
                exit
        }
    }

    elseif ($restartBool -eq "n") {
        exit
    }
    else{
        Write-Output "Response not recognised."
        exit
    }
}catch{
    Write-Error "An error has occurred : $_"
    Read-Host "Press Enter to exit..."
    exit
}