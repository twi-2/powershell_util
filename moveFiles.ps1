#Add correct subfolder
$dirFiles = "Z:\Werk\"

#What file name contains/looks like. Ex: `'*glasses*'`
$Name = '**'
#Destination directory, takes $dirFiles to make a sub folder. Can just use `$dirDest = ""` aswell
$dirDest = -Join ($dirFiles, "")
if (-not (Test-Path -Path $dirDest -PathType Container)) {mkdir $dirDest}

$filteredFiles = Get-ChildItem $dirFiles -File | Where-Object {($_.Name -Like $Name)}
ForEach ($File in $filteredFiles) {
    Move-Item -Path $File.FullName -Destination $dirDest
}
