# PowerShell script to reset Windows shortcut icons
# Requires administrator rights to modify the registry

# Check if the script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Create a new StartInfo object for the PowerShell process
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell.exe"
    $startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
    $startInfo.Verb = "runas" # Indicates that the script should be run as administrator

    # Start the process
    try {
        [System.Diagnostics.Process]::Start($startInfo)
    } catch {
        Write-Warning "Elevation of privileges failed. The script must be run as an administrator."
    }

    # Exit the current script
    exit
}

# Ask the user to confirm the reset of the shortcut icons
Read-Host "Press Enter if you want to reset the Windows shortcut icons"

# Path to the registry key containing the shortcut icons
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"

try {
    # Check if the registry key exists and delete it if it does
    if (Test-Path $registryPath) {
        Remove-Item -Path $registryPath -Recurse -Force
        Write-Host "Key deleted: $registryPath"
    } else {
        Write-Host "The key does not exist: $registryPath"
    }
}
catch {
    Write-Error "Error during deletion: $_"
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
