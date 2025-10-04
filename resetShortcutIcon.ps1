# PowerShell script to reset Windows shortcut icons
# Requires administrator rights to modify the registry

# Check if the script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""

    try {
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs
    } catch {
        Write-Warning "Elevation of privileges failed. The script must be run as an administrator."
    }

    exit
}

# Ask the user to confirm the reset of the shortcut icons
Read-Host "Press Enter if you want to reset the Windows shortcut icons"

# Path to the registry key containing the shortcut icons
$dataPath = "$env:USERPROFILE\.rmShortCutIcon\"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"

try {
    # Check if the registry key exists and delete it if it does
    if (Test-Path $registryPath) {
        Remove-ItemProperty -Path $registryPath -Name "29" -Force
        Write-Host "Key deleted: $registryPath\29"
    } else {
        Write-Host "The key does not exist: $registryPath"
    }
}
catch {
    Write-Error "Error during deletion: $_"
}

try{
    if(Test-Path $dataPath){
        $jsonContent = Get-Content -Path "$dataPath\data.json" -Raw

        $data = $jsonContent | ConvertFrom-Json

        $imgPath = $data.imagePath

        Remove-Item -Path $imgPath 
    }
}catch {
    Write-Error "An error has occurred: $_"
    Read-Host "Press Enter to exit..."
    exit    
}

try{
    Remove-Item -Path $dataPath
}catch {
    Write-Error "An error has occurred: $_"
    Read-Host "Press Enter to exit..."
    exit
}

try {
    # Ask the user if they want to restart the computer
    $restartBool = Read-Host "Would you like to restart your computer now? y/n"
    if ($restartBool -eq "y"){
        try {
            Restart-Computer
        } catch{
                Write-Error "An error has occurred: $_"
                Read-Host "Press Enter to exit..."
                exit
        }
    }
    elseif ($restartBool -eq "n") {
        exit
    }
    else{
        Write-Output "Response not recognized."
        exit
    }
}catch{
    Write-Error "An error has occurred: $_"
    Read-Host "Press Enter to exit..."
    exit
}
