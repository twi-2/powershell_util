function CopyWithIndex ([string]$FilePath, [int]$Count = 1, [string]$FileType = ".jpg", [int]$i = 0) {
    $OriginalFile = gi $FilePath
    While ($i -lt $Count) {
        cp $OriginalFile.Fullname -Des (-join ($OriginalFile.DirectoryName, "\", $i, $FileType)); $i++
    }
}

$FilePath = Read-Host "Enter File"
[int]$Count = Read-Host "Enter Count"
CopyWithIndex $FilePath $Count
