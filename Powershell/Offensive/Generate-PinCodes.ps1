# Define the list of "very easy" numbers
$veryEasyNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    $_.ToString() * 4  # Four identical digits
}
$veryEasyNumbers += "1234"  # The sequence "1234"

# Define the list of "easy" numbers consisting of adjacent duos
$adjacentEasyNumbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9) | ForEach-Object {
    "{0}{0}{1}{1}" -f $_, (($_ + 1) % 10)  # Two pairs of digits
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

# Loop through all years from 1901 to the current year
for ($year = 1901; $year -le (Get-Date).Year; $year++) {
    # Add the year to the array
    $YearNumbers += $year
}

# Define the list of "easy" numbers consisting of all combinations under 100, twice
$doubleUnder100 = @(0..99) | ForEach-Object {
    "{0:D2}{0:D2}" -f $_
}

# Generate all combinations from 0000 to 9999
$combinations = 0..9999 | ForEach-Object {
    "{0:D4}" -f $_
}

# Randomize the order of the non-easy numbers
$nonEasyNumbers = $combinations | Where-Object {
    $veryEasyNumbers + $adjacentEasyNumbers + $easyNumbers -notcontains $_
}
$randomizedNonEasyNumbers = $nonEasyNumbers | Get-Random -Count $nonEasyNumbers.Count

# Combine the easy, double under 100, and non-easy numbers and write to a file
$allNumbers = $veryEasyNumbers + $adjacentEasyNumbers + $YearNumbers + $easyNumbers + $doubleUnder100
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
