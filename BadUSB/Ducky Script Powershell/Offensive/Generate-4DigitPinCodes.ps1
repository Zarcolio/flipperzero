#                                                                    _..._       .-'''-.                 .-'''-.
#                                                                 .-'_..._''.   '   _    \  .---.       '   _    \
# /|                                                            .' .'      '.\/   /` '.   \ |   |.--. /   /` '.   \
# ||    .-.          .-                                        / .'          .   |     \  ' |   ||__|.   |     \  '
# ||     \ \        / /                               .-,.--. . '            |   '      |  '|   |.--.|   '      |  '
# ||  __  \ \      / /                          __    |  .-. || |            \    \     / / |   ||  |\    \     / /
# ||/'__ '.\ \    / /            .--------.  .:--.'.  | |  | || |             `.   ` ..' /  |   ||  | `.   ` ..' /
# |:/`  '. '\ \  / /             |____    | / |   \ | | | |  '-  \ '.          .              |   ||  |
# ||     | | \ `  /                  /   /  `" __ | | | |       '. `._____.-'/              |   ||__|
# ||\    / '  \  /                 .'   /    .'.''| | | |                  `
# |/\'..' /   / /                 /    /___ / /   | |_| |                  `
# '  `'-'`|`-' /                 |         |\ \._,\ '/|_|                  `
#          '..'                  |_________| `--'  `"

[CmdletBinding()]
param (
    [switch]$UseMMDD,
    [string]$PinOrder = "same,sequential,square,sequentialsamepairs,samepairs,years,1000,palindromes,pairs,DDMM,MMDD,3plus1",
    [string]$PostPinText = "",
    [string]$OutputFile = "4n_pin_codes.txt"
)

function PostPin {
    param (
        [string]$pin,
        [string]$text
    )
    return "$pin$text"
}

$SameDigitsNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    $_.ToString() * 4
}

$conseqNumbers = @()
for ($i = 0; $i -le 6; $i++) {
    $sequence = $i..($i + 3) -join ''
    $conseqNumbers += $sequence
}

$AdjacentPairsNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    "{0}{0}{1}{1}" -f $_, (($_ + 1) % 10)
}

$YearsNumbers = @()
for ($year = 1900; $year -le (Get-Date).Year; $year++) {
    $YearsNumbers += $year.ToString("0000")
}

$ThousandsNumbers = @(1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    ($_ * 1000).ToString("0000")
}

$DuoCombinationsNumbers = @(0..9) | ForEach-Object {
    $firstDuo = "{0}{0}" -f $_
    @(0..9) | ForEach-Object {
        $secondDuo = "{0}{0}" -f $_
        $number = "{0}{1}{2}{3}" -f $firstDuo[0], $firstDuo[1], $secondDuo[0], $secondDuo[1]
        if ($SameDigitsNumbers + $AdjacentPairsNumbers -notcontains $number) {
            $number
        }
    }
}

$palindromicPins = @()
for ($a = 0; $a -le 9; $a++) {
    for ($b = 0; $b -le 9; $b++) {
        $pin = "$a$b$b$a"
        $palindromicPins += $pin
    }
}

$datesddmm = @()
for ($month = 1; $month -le 12; $month++) {
    for ($day = 1; $day -le 31; $day++) {
        $formattedDay = "{0:D2}" -f $day
        $formattedMonth = "{0:D2}" -f $month
        $date = $formattedDay + $formattedMonth
        if ($date.Length -eq 4) {
            $datesddmm += $date
        }
    }
}

$datesmmdd = @()
for ($month = 1; $month -le 12; $month++) {
    for ($day = 1; $day -le 31; $day++) {
        $formattedMonth = "{0:D2}" -f $month
        $formattedDay = "{0:D2}" -f $day
        $date = $formattedMonth + $formattedDay
        if ($date.Length -eq 4) {
            $datesmmdd += $date
        }
    }
}

$doubleUnder100 = @(0..99) | ForEach-Object {
    "{0:D2}{0:D2}" -f $_
}

$numericKeypad = @(
    @(1, 2, 3),
    @(4, 5, 6),
    @(7, 8, 9)
)

$square = @()
for ($row = 0; $row -lt 2; $row++) {
    for ($col = 0; $col -lt 2; $col++) {
        $pin = "$($numericKeypad[$row][$col])$($numericKeypad[$row][$col + 1])$($numericKeypad[$row + 1][$col + 1])$($numericKeypad[$row + 1][$col])"
        $reversedPin = $pin -replace "(.)(.)(.)(.)", '$4$3$2$1'
        $square += $pin, $reversedPin
    }
}

$uniqueNumbers = 0..9
$3plus1 = @()

foreach ($uniqueNumber in $uniqueNumbers) {
    for ($i = 0; $i -le 9; $i++) {
        if ($i -eq $uniqueNumber) {
            continue
        }

        $pin = "$uniqueNumber$i$i$i"
        $3plus1 += $pin
    }
}

foreach ($pin in $3plus1) {
    $reversedPin = $pin[3]+$pin[2]+$pin[1]+$pin[0]
    $3plus1 += $reversedPin
}

$pinCategories = @{
    "same" = $SameDigitsNumbers
    "sequential" = $conseqNumbers
    "square" = $square
    "seqentialsamepairs" = $AdjacentPairsNumbers
    "samepairs" = $DuoCombinationsNumbers
    "years" = $YearsNumbers
    "1000" = $ThousandsNumbers
    "palindromes" = $palindromicPins
    "pairs" = $doubleUnder100
    "DDMM" = $datesddmm
    "MMDD" = $datesmmdd
    "3plus1" = $3plus1
}

$allNumbers = @()
$PinOrder.Split(",") | ForEach-Object {
    if ($pinCategories.ContainsKey($_)) {
        $pinCategories[$_].ForEach({ if (-not $allNumbers.Contains($_)) { $allNumbers += $_ } })
    }
}

$combinations = 0..9999 | ForEach-Object { "{0:D4}" -f $_ }

# Shuffle the remaining numbers before adding them to allNumbers
$remainingNumbers = $combinations | Where-Object { -not $allNumbers.Contains($_) } | Get-Random -Count ($combinations.Count - $allNumbers.Count)

$allNumbers += $remainingNumbers

if ($allNumbers.Count -ne 10000) {
    Write-Host "Error: The combined list of numbers does not contain 10,000 unique entries."
    exit
}

if (-not [System.IO.Path]::IsPathRooted($OutputFile)) {
    $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
    $filePath = Join-Path -Path $scriptDir -ChildPath $OutputFile
} else {
    $filePath = $OutputFile
}

if (Test-Path $filePath) {
    $confirmation = Read-Host "The file '$filePath' already exists. Do you want to overwrite it? (Y/N)"
    if ($confirmation -ieq "Y") {
        $allNumbers | ForEach-Object { PostPin $_ $PostPinText } | Out-File -FilePath $filePath -Force
        Write-Host "File '$filePath' overwritten successfully."
    } else {
        Write-Host "File '$filePath' was not overwritten."
    }
} else {
    $allNumbers | ForEach-Object { PostPin $_ $PostPinText } | Out-File -FilePath $filePath
    Write-Host "File '$filePath' created successfully."
}
