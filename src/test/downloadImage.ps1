# URL de l'image à télécharger
$imageUrl = "https://raw.githubusercontent.com/writedev/Remove-shortcut-icon-Win/refs/heads/main/icon/NotArrow.ico"

# Chemin où enregistrer l'image
$outputPath = "$env:USERPROFILE\OneDrive\CodeProject\PowershellProject\remove_arrow\src\test\image.ico"

# Envoyer la requête HTTP et télécharger l'image
Invoke-WebRequest -Uri $imageUrl -OutFile $outputPath

# Afficher un message de confirmation
Write-Output "L'image a été téléchargée et enregistrée à l'emplacement : $outputPath"
