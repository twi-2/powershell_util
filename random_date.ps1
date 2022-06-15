function RandomNumber([int]$FirstNum = 0, [int]$LastNum = 9, [int]$Count = 1) {
    return ($FirstNum..$LastNum) | Get-Random -Count $Count
}

function RandomChar([int]$CharSetting = 0, [int]$Count = 1) {
    # 0 = Both Capitalized and LowerCase
    # 1 = LowerCase
    # 2 = Capitalized

    Switch ($CharSetting) {
        0 {return (65..90) + (97..122) | Get-Random -Count $Count | %{[char]$_}; Break}
        1 {return (97..122) | Get-Random -Count $Count | %{[char]$_}; Break}
        2 {return (65..90) | Get-Random -Count $Count| %{[char]$_}; Break}
        Default {Write-Host "Unknown RandomChar input"; Break}
    }
}

function RandomDate ([int]$DayMin = 1, [int]$DayMax = 28, [int]$MonthMin = 1, [int]$MonthMax = 12,`
            [int]$YearMin = 2017, [int]$YearMax = 2021, [int]$HourMin = 1, [int]$HourMax = 23,`
            [int]$MinuteMin = 1, [int]$MinuteMax = 59, [int]$SecondMin = 1, [int]$SecondMax = 59,`
            [string]$Date = "") {
    if ($Date -ne "") {
        return $Date
    }
    $Day = RandomNumber $DayMin $DayMax
    $Month = RandomNumber $MonthMin $MonthMax
    $Year = RandomNumber $YearMin $YearMax
    $Hour = RandomNumber $HourMin $HourMax
    $Minute = RandomNumber $MinuteMin $MinuteMax
    $Second = RandomNumber $SecondMin $SecondMax

    return "{0}/{1}/{2} {3}:{4}:{5}" -f $Month, $Day, $Year, $Hour, $Minute, $Second
}

function RandomName {
    return -join (-join (RandomNumber -Count 1), -join (RandomChar -Count 4),`
                -join (RandomNumber -Count 2), -join (RandomChar -Count 3))
}

function SingleFileDateChange ([string] $DirPath){
    $Date = RandomDate
    Set-ItemProperty -Path $DirPath -Name lastwritetime -Value $Date
}

function DirectoryDateChange ([string] $DirPath){
    $Files = dir $DirPath | ? Length -gt 0
    ForEach ($File in $Files) {
        $Date = RandomDate
        Set-ItemProperty -Path $File.FullName -Name lastwritetime -Value $Date
    }
    
}

function DirectoryAndChildDateChange ([string] $DirPath){
    $Files = dir $DirPath -r
    ForEach ($File in $Files) {
        $Date = RandomDate
        Set-ItemProperty -Path $File.FullName -Name lastwritetime -Value $Date
    }
}

function NewFiles ([string] $DirPath){
    while ((ls $DirPath -dir | Measure-Object).Count -lt 30) {
        $Name = RandomName
        $File = -Join ($Dirpath, $Name, ".tmp")
        Write-Host $File
        mkdir $File
    }

}

$Continue = "Y"
While ("Y","y" -contains $Continue) {
    $Choice = Read-Host "SingleFile (1), Directory (2), Directory and Childs (3), Create .tmp Files (4)"
    $DirPath = Read-Host "Enter Directory Path"
    Switch ($Choice) {
        "1" {SingleFileDateChange $DirPath; Break}
        "2" {DirectoryDateChange $DirPath; Break}
        "3" {DirectoryAndChildDateChange $DirPath; Break}
        "4" {NewFiles $DirPath; Break}
        Default {Write-Host "No Matches Found"}
    }
    $Continue = Read-Host "Do you wish to randomize more file dates? (Y\N)"
}
