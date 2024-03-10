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
    [string]$PinOrder = "same,seqential,square,seqentialsamepairs,samepairs,years,1000,palindromes,pairs,DDMM,MMDD,3plus1", # Default order
    [string]$PostPinText = "", # Custom text to append after each pin
    [string]$OutputFile = "4n_pin_codes.txt" # Default output file name
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

# Initialize an empty array to store palindromic PINs
$palindromicPins = @()

# Iterate through the possible digits (0-9) for each position in the PIN
for ($a = 0; $a -le 9; $a++) {
    for ($b = 0; $b -le 9; $b++) {
        # Construct the palindromic PIN
        $pin = "$a$b$b$a"
        
        # Add the palindromic PIN to the list
        $palindromicPins += $pin
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

# Define the numeric keypad layout
$numericKeypad = @(
    @(1, 2, 3),
    @(4, 5, 6),
    @(7, 8, 9)
)

$square = @()
for ($row = 0; $row -lt 2; $row++) {
    for ($col = 0; $col -lt 2; $col++) {
        $pin = "$($numericKeypad[$row][$col])$($numericKeypad[$row][$col + 1])$($numericKeypad[$row + 1][$col + 1])$($numericKeypad[$row + 1][$col])"
        $reversedPin = $pin -replace "(.)(.)(.)(.)", '$4$3$2$1'  # Reverse the PIN
        $square += $pin, $reversedPin
    }
}

# Define the range of unique numbers (0-9)
$uniqueNumbers = 0..9
$3plus1 = @()  # Initialize an empty array to store the PINs

# Loop through each unique number
foreach ($uniqueNumber in $uniqueNumbers) {
    # Loop through each possible PIN pattern (e.g., 1234, 2345, etc.)
    for ($i = 0; $i -le 9; $i++) {
        # Skip the iteration if $i is the same as $uniqueNumber
        if ($i -eq $uniqueNumber) {
            continue
        }

        # Generate the PIN by alternating between $uniqueNumber and $i
        $pin = "$uniqueNumber$i$i$i"

        # add it to the list
        $3plus1 += $pin
    }
}

# Loop through the PINs again to generate and add the reversed PINs at the end
foreach ($pin in $3plus1) {
    # Generate the reversed PIN and add it to the list
    $reversedPin = $pin[3]+$pin[2]+$pin[1]+$pin[0]
    $3plus1 += $reversedPin
}

# Create a hashtable for easy lookup
$pinCategories = @{
    "same" = $SameDigitsNumbers
    "seqential" = $conseqNumbers
    "seqentialsamepairs" = $AdjacentPairsNumbers
    "years" = $YearsNumbers
    "1000" = $ThousandsNumbers
    "samepairs" = $DuoCombinationsNumbers
    "palindromes" = $palindromicPins
    "DDMM" = $datesddmm
    "MMDD" = $datesmmdd
    "pairs" = $doubleUnder100
    "square" = $square
    "3plus1" = $3plus1
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

# Check if the output file already exists
if (Test-Path $filePath) {
    # File exists, ask for confirmation before overwriting
    $confirmation = Read-Host "The file '$filePath' already exists. Do you want to overwrite it? (Y/N)"
    
    # Check the user's response
    if ($confirmation -ieq "Y") {
        # User confirmed, proceed with overwriting
        $randomizedNumbers | Out-File -FilePath $filePath -Force
        Write-Host "File '$filePath' overwritten successfully."
    }
    else {
        # User declined, do not overwrite
        Write-Host "File '$filePath' was not overwritten."
    }
}
else {
    # File does not exist, proceed without confirmation
    $randomizedNumbers | Out-File -FilePath $filePath
    Write-Host "File '$filePath' created successfully."
}
