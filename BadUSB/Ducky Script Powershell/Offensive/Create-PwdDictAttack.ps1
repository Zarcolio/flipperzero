#                                                                    _..._       .-'''-.                 .-'''-.
#                                                                 .-'_..._''.   '   _    \  .---.       '   _    \
# /|                                                            .' .'      '.\/   /` '.   \ |   |.--. /   /` '.   \
# ||    .-.          .-                                        / .'          .   |     \  ' |   ||__|.   |     \  '
# ||     \ \        / /                               .-,.--. . '            |   '      |  '|   |.--.|   '      |  '
# ||  __  \ \      / /                          __    |  .-. || |            \    \     / / |   ||  |\    \     / /
# ||/'__ '.\ \    / /            .--------.  .:--.'.  | |  | || |             `.   ` ..' /  |   ||  | `.   ` ..' /
# |:/`  '. '\ \  / /             |____    | / |   \ | | |  | |. '                '-...-'`   |   ||  |    '-...-'`
# ||     | | \ `  /                  /   /  `" __ | | | |  '-  \ '.          .              |   ||  |
# ||\    / '  \  /                 .'   /    .'.''| | | |       '. `._____.-'/              |   ||__|
# |/\'..' /   / /                 /    /___ / /   | |_| |         `-.______ /               '---'
# '  `'-'`|`-' /                 |         |\ \._,\ '/|_|                  `
#          '..'                  |_________| `--'  `"

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
    [string]$PrintMode = "string",

    [Parameter(Position=4, HelpMessage="Character delay in milliseconds. Applicable only in 'char' mode.")]
    [int]$CharDelay = 500,

    [Parameter(Position=5, HelpMessage="Select the command to use: 'STRING' or 'ALTSTRING'. Default is 'STRING'.")]
    [string]$StringMode = "STRING",

    [Parameter(Position=6, HelpMessage="Add BACKSPACE at the end of each character loop to prevent overflow.")]
    [switch]$PreventOverflow,

    [Parameter(Position=7, HelpMessage="Include ENTER key press at the end of the command.")]
    [switch]$Enter,

	[Parameter(Position=8, HelpMessage="Optional custom DuckyScript commands to add after ENTER.")]
	[string[]]$PostCommands

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

Add-Content -Path $OutputFile -Value "REM Command line: $($MyInvocation.Line)`r`n"

# Read input file and convert to Ducky Script
$Lines = Get-Content $InputFile
foreach ($Line in $Lines) {
    if ($Wait) {
        $WaitStr = "DELAY $Wait"
    }
    else {
        $WaitStr = "WAIT_FOR_BUTTON_PRESS"
    }

    if ($PrintMode -eq "string") {
        $command = "$StringMode $Line"
        if ($Enter) {
            $command += "`r`nENTER"
        }
        
        Add-Content -Path $OutputFile -Value $command
    }
    elseif ($PrintMode -eq "char") {
        $charArray = $Line.ToCharArray()
        $charCount = $charArray.Length
        for ($i = 0; $i -lt $charCount; $i++) {
            $char = $charArray[$i]
            $command = "$StringMode $char"
            Add-Content -Path $OutputFile -Value $command
            if ($i -ne ($charCount - 1)) {
                Add-Content -Path $OutputFile -Value "DELAY $CharDelay"
            }
        }
        
        if ($Enter) {
            Add-Content -Path $OutputFile -Value "ENTER`r`n"
        }

        Add-Content -Path $OutputFile -Value "DELAY $Wait"
        
        if ($PreventOverflow) {
            Add-Content -Path $OutputFile -Value "BACKSPACE`r`n"
        }
    }
    else {
        Write-Error "Invalid value for PrintMode parameter. Supported values: 'string', 'char'."
    }
	
	if ($PostCommands) {
	foreach ($cmd in $PostCommands) {
		Add-Content -Path $OutputFile -Value "$cmd"
		}
	}
	$command += "`r`n$WaitStr`r`n"
}
Write-Verbose "Conversion complete."
