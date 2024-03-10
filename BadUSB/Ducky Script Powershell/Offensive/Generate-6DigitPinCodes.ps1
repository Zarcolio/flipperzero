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

<#
.SYNOPSIS
Generates dates and various types of PINs based on the provided input date.

.DESCRIPTION
This script generates dates and various types of PINs based on the provided input date. The output can be saved to a specified file. 
The script allows for flexible configuration of the output order of generated items.

.PARAMETER inputDate
Specifies the input date in one of the following formats: "dd-MM-yyyy", "MM-yyyy", or "yyyy".

.PARAMETER OutputFile
Specifies the path to the output file where the generated data will be saved.

.PARAMETER outputOrder
Specifies the order in which the generated items will be outputted. The default order is: 
"GenerateDates_ddMMyy_MMyyyy_yyyyMM", "GenerateRepetitiveNumberPINs", "GenerateSequentialNumberPINs", 
"GenerateNumericPalindromes", "GenerateTwoUniqueNumberPINs", "GenerateRepeatedPairsAndTriosPINs", 
"GenerateDates_other".

.EXAMPLE
.\GenerateData.ps1 -inputDate "01-01-2023" -OutputFile "C:\output.txt" -outputOrder "GenerateDates_ddMMyy_MMyyyy_yyyyMM"

Generates dates in the format ddMMyy, MMyyyy, and yyyyMM starting from 01-01-2023 and saves them to C:\output.txt.

.EXAMPLE
.\GenerateData.ps1 -inputDate "2023" -OutputFile "C:\output.txt" -outputOrder "GenerateRepetitiveNumberPINs", "GenerateSequentialNumberPINs"

Generates repetitive number PINs and sequential number PINs starting from the year 2023 and saves them to C:\output.txt.

.INPUTS
None

.OUTPUTS
None

.NOTES
#>

param (
    [Parameter(Mandatory=$true, HelpMessage="Input date in the format 'dd-MM-yyyy', 'MM-yyyy', or 'yyyy'.")]
    [string]$inputDate,

    [Parameter(Mandatory=$true, HelpMessage="Output file path.")]
    [string]$OutputFile,

    [Parameter(HelpMessage="Specifies the order in which the generated items will be outputted.")]
    [string[]]$outputOrder = @("GenerateDates_ddMMyy_MMyyyy_yyyyMM", "GenerateRepetitiveNumberPINs", 
                               "GenerateSequentialNumberPINs", "GenerateNumericPalindromes", 
                               "GenerateTwoUniqueNumberPINs", "GenerateRepeatedPairsAndTriosPINs", 
                               "GenerateDates_other")
)

$uniquePINs = @{}
$orderedPINs = New-Object System.Collections.ArrayList

function AddToUniquePINs($pin) {
    if (-not $uniquePINs.ContainsKey($pin)) {
        $uniquePINs[$pin] = $true
        $orderedPINs.Add($pin) | Out-Null
    }
}

function GenerateDates_ddMMyy_MMyyyy_yyyyMM($startDate) {
    $endDate = (Get-Date)
    $formats = @("ddMMyy", "MMyyyy", "yyyyMM")

    foreach ($format in $formats) {
        $currentDate = $startDate
        while ($currentDate -le $endDate) {
            $dateStr = $currentDate.ToString($format)
            AddToUniquePINs $dateStr
            $currentDate = $currentDate.AddDays(1)
        }
    }
}

function GenerateDates_other($startDate) {
    $endDate = (Get-Date)
    $formats = @("MMddyy", "yyMMdd")

    foreach ($format in $formats) {
        $currentDate = $startDate
        while ($currentDate -le $endDate) {
            $dateStr = $currentDate.ToString($format)
            AddToUniquePINs $dateStr
            $currentDate = $currentDate.AddDays(1)
        }
    }
}

function GenerateNumericPalindromes {
    for ($i = 0; $i -le 999; $i++) {
        $formattedNum = "{0:D3}" -f $i
        $palindrome = $formattedNum + [string]($formattedNum[2]) + [string]($formattedNum[1]) + [string]($formattedNum[0])
        AddToUniquePINs $palindrome
    }
}

function GenerateRepetitiveNumberPINs {
    for ($i = 0; $i -lt 10; $i++) {
        $pin = ($i.ToString() * 6)
        AddToUniquePINs $pin
    }
}

function GenerateSequentialNumberPINs {
    for ($i = 0; $i -le 4; $i++) {
        $pin = $i..($i+5) -join ''
        AddToUniquePINs $pin
    }

    for ($i = 9; $i -ge 5; $i--) {
        $pin = $i..($i-5) -join ''
        AddToUniquePINs $pin
    }
}

function GenerateRepeatedPairsAndTriosPINs {
    for ($i = 0; $i -lt 100; $i++) {
        $formattedPair = "{0:D2}" -f $i
        $pairPin = ($formattedPair * 3)
        AddToUniquePINs $pairPin
    }

    for ($i = 0; $i -lt 1000; $i++) {
        $formattedTrio = "{0:D3}" -f $i
        $trioPin = ($formattedTrio * 2)
        AddToUniquePINs $trioPin
    }
}

function GenerateTwoUniqueNumberPINs {
    for ($i = 0; $i -le 9; $i++) {
        for ($j = 0; $j -le 9; $j++) {
            if ($i -ne $j) {
                for ($k = 1; $k -le 5; $k++) {
                    $pin = ($i.ToString() * $k) + ($j.ToString() * (6 - $k))
                    AddToUniquePINs $pin
                }
            }
        }
    }
}

$datePattern = '^\d{2}-\d{2}-\d{4}$'
$monthYearPattern = '^\d{2}-\d{4}$'
$yearPattern = '^\d{4}$'

$isValidInput = $false
$startDate = $null

if ($inputDate -match $datePattern) {
    $startDate = [datetime]::ParseExact($inputDate, 'dd-MM-yyyy', $null)
    $isValidInput = $true
} elseif ($inputDate -match $monthYearPattern) {
    $startDate = [datetime]::ParseExact($inputDate, 'MM-yyyy', $null)
    $isValidInput = $true
} elseif ($inputDate -match $yearPattern) {
    $startDate = [datetime]::ParseExact($inputDate, 'yyyy', $null)
    $isValidInput = $true
}

if ($isValidInput) {
    foreach ($functionName in $outputOrder) {
        if ($functionName.StartsWith("GenerateDates")) {
            Invoke-Expression "$functionName `$startDate"
        } else {
            Invoke-Expression $functionName
        }
    }

    # Output all unique entries to the specified file
    $orderedPINs | ForEach-Object { Add-Content -Path $OutputFile -Value $_ }
}
