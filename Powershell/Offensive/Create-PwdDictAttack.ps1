[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Path of the input file.")]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [string]$InputFile,
    [Parameter(Position=1, HelpMessage="Delay in milliseconds.")]
    [int]$Delay = 500,
    [Parameter(Position=2, HelpMessage="Wait time in milliseconds.")]
    [int]$Wait = $null
)

# Determine output folder and file path
if (-not $InputFile.Contains("\") -and -not $InputFile.Contains("/")) {
    $InputFile = Join-Path -Path (Get-Location) -ChildPath $InputFile
}

$OutputFolder = Split-Path -Parent $InputFile
if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
    Throw "Output folder cannot be determined from input file path."
}

$OutputFile = Join-Path -Path $OutputFolder -ChildPath "Dict_Attack.txt"
Write-Verbose "Output file path: $OutputFile"

# Create new output file or overwrite existing file
New-Item -ItemType File -Path $OutputFile -Force -ErrorAction Stop | Out-Null
Write-Verbose "Output file created successfully: $OutputFile"

# Read input file and convert to ducky script
$EnterKey = [char]13
$Lines = Get-Content $InputFile
foreach ($Line in $Lines) {
    if ($Wait) {
        $WaitStr = "DELAY $Wait"
    }
    else {
        $WaitStr = "WAIT_FOR_BUTTON_PRESS"
    }
    $command = "STRING $line`nDELAY $Delay`nENTER`n$WaitStr`n"
    Add-Content -Path $OutputFile -Value $Command
}
Write-Verbose "Conversion complete."
