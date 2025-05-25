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
    $dependance = Read-Host "Do you want to choose the location of the dependencies? y/n"

    if ($dependance -eq "y") {
        Add-Type -AssemblyName System.Windows.Forms
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.Description = "Choose a folder"
        if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $dependancefilePath = Join-Path $dialog.SelectedPath "monFichier.txt"
        } else {
            Write-Output "No folder selected."
            exit
        }
    } elseif ($dependance -eq "n") {
        $dependancefilePath = "$env:USERPROFILE\AppData\Roaming\monFichier.txt"
    } else {
        Write-Output "Response not recognised. Default path used."
        $dependancefilePath = "$env:USERPROFILE\AppData\Roaming\NotArrow\monFichier.txt"
    }

    Write-Host "Dependencies path selected: $dependancefilePath"
}
catch {
    Write-Error "An error occurred: $_"
}



try {
    $imageUrl = "https://raw.githubusercontent.com/writedev/Remove-shortcut-icon-Win/refs/heads/main/icon/NotArrow.ico"

    $ImgPath = $dependancefilePath + "\noArrow.ico"

    Invoke-WebRequest -Uri $imageUrl -OutFile $ImgPath

}catch{
    Write-Error "An error has occurred : $_"
    Read-Host "Press Enter to exit..."
    exit
}

try {
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"

    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    New-ItemProperty -Path $registryPath -Name "29" -Value $ImgPath -PropertyType String -Force
}catch{
    Write-Error "An error has occurred : $_"s
    Read-Host "Press Enter to exit..."
    exit
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