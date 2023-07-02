<#
.SYNOPSIS
Converts an existing PowerShell script to a Ducky Script.

.DESCRIPTION
This script reads the contents of an existing PowerShell script, converts each line to Ducky Script format,
and saves the result to the specified output file. If the output file is not provided, it replaces the extension
of the existing PowerShell script with .txt.

.PARAMETER ExistingPs1File
The path to the existing PowerShell script to convert.

.PARAMETER OutputDuckyScript
The path for the output Ducky Script file. If not provided, it replaces the extension of the existing PowerShell
script with .txt.

.EXAMPLE
ConvertToDucky.ps1 -ExistingPs1File "C:\Path\To\Existing.ps1" -OutputDuckyScript "C:\Path\To\Output.txt"
#>

param (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
    [string]$ExistingPs1File,

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$OutputDuckyScript
)

# Check if the output Ducky Script file is provided
if (-not $OutputDuckyScript) {
    # Replace the extension of the existing PowerShell script with .txt
    $OutputDuckyScript = $ExistingPs1File -replace '\.ps1$', '.txt'
}

# Initial Ducky Script commands
$initialDuckyScript = @"
DELAY 1000
GUI r
DELAY 1000
STRING powershell
ENTER
DELAY 2000

"@

# Read the contents of the existing .ps1 file
$ps1Contents = Get-Content -Path $ExistingPs1File

# Initialize the Ducky Script variable
$duckyScript = ""

# Convert each line of the PowerShell script to Ducky Script
foreach ($line in $ps1Contents) {
    # Remove leading and trailing whitespace from the line
    $line = $line.Trim()

    # Ignore empty lines or lines starting with '#'
    if (-not [string]::IsNullOrWhiteSpace($line) -and -not $line.StartsWith("#")) {
        # Check if the line contains special characters
        $containsSpecialChars = $line -match '[~`^''"]'

        if ($containsSpecialChars) {
            # Use ALTCODE command for lines with special characters
            $duckyScript += "ALTCODE $line`r`n"
        }
        else {
            # Use STRING command for lines without special characters
            $duckyScript += "STRING $line`r`n"
        }
    }
    $duckyScript += "ENTER`r`n"
}

# Combine the initial Ducky Script commands with the converted PowerShell script
$finalDuckyScript = $initialDuckyScript + $duckyScript

# Write the combined Ducky Script to the output file
$finalDuckyScript | Out-File -FilePath $OutputDuckyScript -Encoding ASCII

Write-Verbose "Conversion completed. The Ducky Script file has been saved at: $OutputDuckyScript"
