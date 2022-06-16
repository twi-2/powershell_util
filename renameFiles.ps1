Function ToIndex ([string]$Dir, [string]$FileType = ".jpg", [int]$i = 0) {
    ForEach ($File in gci $Dir | ? Length -gt 0) {
        rni $File.Fullname (-join ($i, $FileType)); $i++
    }
}

$DirPath = Read-Host "Enter Directory Path"
ToIndex $DirPath
