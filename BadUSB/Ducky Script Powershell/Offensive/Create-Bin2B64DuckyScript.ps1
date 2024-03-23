# PowerShell script to convert file content to Base64, generate Ducky Script to open Notepad, type content, save, and decode it

param (
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    
    [int]$ChunkSize = 500 # Default chunk size, adjustable via command line
)

function Write-DuckyScript {
    param (
        [string]$OutputPath,
        [string[]]$Content
    )
    
    try {
        [System.IO.File]::WriteAllLines($OutputPath, $Content)
        Write-Host "Ducky Script saved to: $OutputPath"
    } catch {
        Write-Error "Failed to save Ducky Script: $_"
    }
}

# Ensure the file exists
if (-Not (Test-Path $FilePath)) {
    Write-Error "File not found: $FilePath"
    exit
}

# Read the file bytes
$fileBytes = [System.IO.File]::ReadAllBytes($FilePath)

# Convert to Base64
$base64String = [Convert]::ToBase64String($fileBytes)

# Generate the output file name for the .b64 file and original decoded file
$InputFileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
$InputFileExtension = [System.IO.Path]::GetExtension($FilePath)
$B64FileName = "$InputFileName.b64"
$OriginalFileName = "$InputFileName$InputFileExtension"

# Determine the current working directory to save the Ducky Script
$CurrentDirectory = Get-Location
$OutputFileName = "Create-$InputFileName.txt"
$OutputFilePath = Join-Path -Path $CurrentDirectory -ChildPath $OutputFileName

# Initialize Ducky Script content with commands to open Notepad
$duckyScriptContent = @(
    "DELAY 1000",
    "GUI r",
    "DELAY 500",
    "STRING notepad",
    "ENTER",
    "DELAY 1000"
)

# Add the Base64 content to the Ducky Script
$chunks = [Regex]::Matches($base64String, ".{1,$ChunkSize}")
foreach ($chunk in $chunks) {
    $duckyScriptContent += "STRING $chunk"
    $duckyScriptContent += "DELAY 50"
    $duckyScriptContent += "BACKSPACE"
    $duckyScriptContent += "DELAY 100"
}

# Append commands to save the file in Notepad
$duckyScriptContent += "CTRL s"
$duckyScriptContent += "DELAY 500"
$duckyScriptContent += "STRING %USERPROFILE%\\$B64FileName"
$duckyScriptContent += "ENTER"
$duckyScriptContent += "DELAY 1000"
$duckyScriptContent += "ALT F4"

# Append commands to open Command Prompt and execute certutil
$duckyScriptContent += "DELAY 1000"
$duckyScriptContent += "GUI r"
$duckyScriptContent += "DELAY 500"
$duckyScriptContent += "STRING cmd"
$duckyScriptContent += "ENTER"
$duckyScriptContent += "DELAY 1000"
$duckyScriptContent += "STRING certutil -decode %USERPROFILE%\\$B64FileName %USERPROFILE%\\$OriginalFileName"
$duckyScriptContent += "ENTER"
$duckyScriptContent += "DELAY 1000"
$duckyScriptContent += "STRING exit"
$duckyScriptContent += "ENTER"

# Save the Ducky Script to the output file
Write-DuckyScript -OutputPath $OutputFilePath -Content $duckyScriptContent
