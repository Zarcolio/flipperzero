[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Path of the input file.")]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [string]$InputFile,

    [Parameter(Position=1, HelpMessage="Delay in milliseconds.")]
    [int]$Delay = 500,

    [Parameter(Position=2, HelpMessage="Wait time in milliseconds if given, defaults to WAIT_FOR_BUTTON_PRESS.")]
    [int]$Wait = $null,

    [Parameter(Position=3, HelpMessage="Select the processing mode: 'string' processes the entire input as a single string, 'char' processes each character separately. Default is 'string'.")]
    [string]$StringMode = "string",

    [Parameter(Position=4, HelpMessage="Character delay in milliseconds. Applicable only in 'char' mode.")]
    [int]$CharDelay = 500
)

# Determine output folder and file path
if (-not $InputFile.Contains("\") -and -not $InputFile.Contains("/")) {
    $InputFile = Join-Path -Path (Get-Location) -ChildPath $InputFile
}

$OutputFolder = Split-Path -Parent $InputFile
if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
    Throw "Output folder cannot be determined from the input file path."
}

$OutputFile = Join-Path -Path $OutputFolder -ChildPath "Dict_Attack.txt"
Write-Verbose "Output file path: $OutputFile"

# Create a new output file or overwrite an existing file
New-Item -ItemType File -Path $OutputFile -Force -ErrorAction Stop | Out-Null
Write-Verbose "Output file created successfully: $OutputFile"

# Read input file and convert to Ducky Script
$EnterKey = [char]13
$Lines = Get-Content $InputFile
foreach ($Line in $Lines) {
    if ($Wait) {
        $WaitStr = "DELAY $Wait"
    }
    else {
        $WaitStr = "WAIT_FOR_BUTTON_PRESS"
    }

    if ($StringMode -eq "string") {
        $command = "ALTSTRING $Line`nDELAY $Delay`nENTER`n$WaitStr`n"
        Add-Content -Path $OutputFile -Value $command
    }
    elseif ($StringMode -eq "char") {
        $charArray = $Line.ToCharArray()
        $charCount = $charArray.Length
        for ($i = 0; $i -lt $charCount; $i++) {
            $char = $charArray[$i]
            $command = "ALTSTRING $char`nDELAY $CharDelay"
            Add-Content -Path $OutputFile -Value $command
            if ($i -ne ($charCount - 1)) {
                Add-Content -Path $OutputFile -Value "DELAY $CharDelay"
            }
        }
        Add-Content -Path $OutputFile -Value "DELAY $Wait`n"
    }
    else {
        Write-Error "Invalid value for StringMode parameter. Supported values: 'string', 'char'."
    }
}
Write-Verbose "Conversion complete."
