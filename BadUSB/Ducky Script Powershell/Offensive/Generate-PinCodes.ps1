[CmdletBinding()]
param (
    [switch]$UseMMDD,
    [string]$PinOrder = "SameDigits,Sequences,AdjacentPairs,Years,Thousands,DuoCombinations,DateDDMM,DateMMDD,DoubleDigits", # Default order
    [string]$PostPinText = "", # Custom text to append after each pin
    [string]$OutputFile = "pin_codes.txt" # Default output file name
)

function PostPin {
    param (
        [string]$pin,
        [string]$text
    )
    return "$pin$text"
}

# Define the list of "SameDigits" numbers
$SameDigitsNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    $_.ToString() * 4  # Four identical digits
}

# Define the list of "Sequences" numbers
$conseqNumbers = @()
for ($i = 0; $i -le 6; $i++) {
    $sequence = $i..($i + 3) -join ''
    $conseqNumbers += $sequence
}

# Define the list of "AdjacentPairs" numbers
$AdjacentPairsNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    "{0}{0}{1}{1}" -f $_, (($_ + 1) % 10)  # Two pairs of digits
}

# Define the list of "Years" numbers
$YearsNumbers = @()
for ($year = 1900; $year -le (Get-Date).Year; $year++) {
    $YearsNumbers += $year
}

# Define the list of "Thousands" numbers
$ThousandsNumbers = @(1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    ($_ * 1000).ToString()
}

# Define the list of "DuoCombinations" numbers
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

# Define the list of "DateDDMM" numbers
$datesddmm = @()
for ($month = 1; $month -le 12; $month++) {
    for ($day = 1; $day -le 31; $day++) {
        $formattedDay = "{0:D2}" -f $day
        $formattedMonth = "{0:D2}" -f $month
        $date = $formattedDay + $formattedMonth
        $datesddmm += $date
    }
}

# Define the list of "DateMMDD" numbers
$datesmmdd = @()
for ($month = 1; $month -le 12; $month++) {
    for ($day = 1; $day -le 31; $day++) {
        $formattedMonth = "{0:D2}" -f $month
        $formattedDay = "{0:D2}" -f $day
        $date = $formattedMonth + $formattedDay
        $datesmmdd += $date
    }
}

# Define the list of "DoubleDigits" numbers
$doubleUnder100 = @(0..99) | ForEach-Object {
    "{0:D2}{0:D2}" -f $_
}

# Create a hashtable for easy lookup
$pinCategories = @{
    "SameDigits" = $SameDigitsNumbers
    "Sequences" = $conseqNumbers
    "AdjacentPairs" = $AdjacentPairsNumbers
    "Years" = $YearsNumbers
    "Thousands" = $ThousandsNumbers
    "DuoCombinations" = $DuoCombinationsNumbers
    "DateDDMM" = $datesddmm
    "DateMMDD" = $datesmmdd
    "DoubleDigits" = $doubleUnder100
}

# Combine numbers based on the order specified in $PinOrder
$allNumbers = @()
$PinOrder.Split(",") | ForEach-Object {
    if ($pinCategories.ContainsKey($_)) {
        $allNumbers += $pinCategories[$_]
    }
}

# Generate all combinations from 0000 to 9999
$combinations = 0..9999 | ForEach-Object {
    "{0:D4}" -f $_
}

# Randomize the order of the non-easy numbers
$nonEasyNumbers = $combinations | Where-Object {
    $allNumbers -notcontains $_
}
$randomizedNonEasyNumbers = $nonEasyNumbers | Get-Random -Count $nonEasyNumbers.Count

# Determine the output file path
if (-not [System.IO.Path]::IsPathRooted($OutputFile)) {
    # If the path is not absolute, treat it as relative to the current directory
    $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
    $filePath = Join-Path -Path $scriptDir -ChildPath $OutputFile
} else {
    # If the path is absolute, use it directly
    $filePath = $OutputFile
}

# Write numbers to a file with the PostPinText appended
$randomizedNumbers = @()
foreach ($number in $allNumbers) {
    if ($randomizedNumbers -notcontains $number) {
        $randomizedNumbers += PostPin -pin $number -text $PostPinText
    }
}
$randomizedNonEasyNumbers | ForEach-Object {
    if ($randomizedNumbers -notcontains $_) {
        $randomizedNumbers += PostPin -pin $_ -text $PostPinText
    }
}

$randomizedNumbers | Out-File -FilePath $filePath
