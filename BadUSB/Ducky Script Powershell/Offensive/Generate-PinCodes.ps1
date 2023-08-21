[CmdletBinding()]
param (
    [switch]$UseMMDD
)

# Define the list of "very easy" numbers
$veryEasyNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    $_.ToString() * 4  # Four identical digits
}

# Define the list of "easy" numbers consisting of adjacent duos
$adjacentEasyNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    "{0}{0}{1}{1}" -f $_, (($_ + 1) % 10)  # Two pairs of digits
}

# Initialize an empty array to store the sequences
$conseqnumbers = @()

# Loop through the range and generate sequences
for ($i = 0; $i -le 6; $i++) {
    $sequence = $i..($i + 3) -join ''
    $conseqnumbers += $sequence
}

# Define the list of "easy" numbers consisting of all combinations of 2 duos
$easyNumbers = @(0..9) | ForEach-Object {
    $firstDuo = "{0}{0}" -f $_
    @(0..9) | ForEach-Object {
        $secondDuo = "{0}{0}" -f $_
        $number = "{0}{1}{2}{3}" -f $firstDuo[0], $firstDuo[1], $secondDuo[0], $secondDuo[1]
        if ($veryEasyNumbers + $adjacentEasyNumbers -notcontains $number) {
            $number
        }
    }
}

# Define the list of year numbers
$YearNumbers = @()

# Loop through all years from 1900 to the current year
for ($year = 1900; $year -le (Get-Date).Year; $year++) {
    # Add the year to the array
    $YearNumbers += $year
}

# Define the list of "easy" numbers consisting of all combinations under 100, twice
$doubleUnder100 = @(0..99) | ForEach-Object {
    "{0:D2}{0:D2}" -f $_
}

# Initialize an empty array to store the dates
$datesddmm = @()

# Loop through all possible dates in DDMM format
    for ($month = 1; $month -le 12; $month++) {
for ($day = 1; $day -le 31; $day++) {
        $formattedDay = "{0:D2}" -f $day
        $formattedMonth = "{0:D2}" -f $month
        $date = $formattedDay + $formattedMonth
        $datesddmm += $date
    }
}

# Initialize an empty array to store the dates
$datesmmdd = @()

# Loop through all possible dates in MMDD format
for ($month = 1; $month -le 12; $month++) {
    for ($day = 1; $day -le 31; $day++) {
        $formattedMonth = "{0:D2}" -f $month
        $formattedDay = "{0:D2}" -f $day
        $date = $formattedMonth + $formattedDay
        $datesmmdd += $date
    }
}

# Generate all combinations from 0000 to 9999
$combinations = 0..9999 | ForEach-Object {
    "{0:D4}" -f $_
}

# Determine the order in which to combine numbers based on the parameter
$alldates = @()
if ($UseMMDD) {
    $alldates = $datesmmdd + $datesddmm
} else {
    $alldates = $datesddmm + $datesmmdd
}

# Combine numbers 
$allNumbers = $veryEasyNumbers + $conseqnumbers + $adjacentEasyNumbers + $YearNumbers + $easyNumbers + $alldates + $doubleUnder100

# Randomize the order of the non-easy numbers
$nonEasyNumbers = $combinations | Where-Object {
    $allNumbers -notcontains $_
}
$randomizedNonEasyNumbers = $nonEasyNumbers | Get-Random -Count $nonEasyNumbers.Count

# Write numbers to a file
$randomizedNumbers = @()
foreach ($number in $allNumbers) {
    if ($randomizedNumbers -notcontains $number) {
        $randomizedNumbers += $number
    }
}
$randomizedNonEasyNumbers | ForEach-Object {
    if ($randomizedNumbers -notcontains $_) {
        $randomizedNumbers += $_
    }
}

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$filePath = Join-Path -Path $scriptDir -ChildPath "pin_codes.txt"

$randomizedNumbers | Out-File -FilePath $filePath
