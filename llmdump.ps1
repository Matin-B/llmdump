<#
.SYNOPSIS
LLM Project Context Generator
.DESCRIPTION
GitHub: https://github.com/Matin-B/llmdump
#>

$Host.UI.RawUI.WindowTitle = "LLMDump: Codebase Context Generator"

Write-Host "=== LLMDump: Codebase Context Generator ===" -ForegroundColor Cyan
$ProjectDir = Read-Host "Enter the absolute path to your project directory"

# Remove trailing slashes
$ProjectDir = $ProjectDir.TrimEnd('\').TrimEnd('/')

if (-not (Test-Path -Path $ProjectDir -PathType Container)) {
    Write-Host "`n[!] Error: Directory '$ProjectDir' does not exist. Try again." -ForegroundColor Red
    Exit
}

$OutputMD = Join-Path -Path (Get-Location) -ChildPath "codebase_dump.md"
$OutputXML = Join-Path -Path (Get-Location) -ChildPath "codebase_dump.xml"

# Clear or create files
New-Item -Path $OutputMD -ItemType File -Force | Out-Null
New-Item -Path $OutputXML -ItemType File -Force | Out-Null

# Write Headers using .NET for performance
[System.IO.File]::AppendAllText($OutputMD, "# Project Codebase Dump`n# Source: $ProjectDir`n================================================================================`n`n")
[System.IO.File]::AppendAllText($OutputXML, "<project_dump>`n  <source_directory>$ProjectDir</source_directory>`n  <files>`n")

# Define Exclusions (Regex) and Allowed Extensions
$ExcludeRegex = "\\\.git|\\\.idea|\\__pycache__|\\node_modules|\\venv|\\env"
$AllowedExts = @('.py', '.json', '.txt', '.md', '.bat', '.ini', '.env', '.sh', '.js', '.html', '.css', '.ps1')

# Fetch files
$Files = Get-ChildItem -Path $ProjectDir -Recurse -File | Where-Object {
    ($_.FullName -notmatch $ExcludeRegex) -and ($AllowedExts -contains $_.Extension)
}

$ProcessedCount = 0
$Spinner = @('-', '\', '|', '/')

Write-Host "" # Empty line for cleaner output

foreach ($File in $Files) {
    # Generate relative path and format it with forward slashes
    $RelativePath = $File.FullName.Substring($ProjectDir.Length + 1).Replace('\', '/')
    $Extension = $File.Extension.TrimStart('.')

    # Read file content safely
    try {
        $Content = [System.IO.File]::ReadAllText($File.FullName)
    } catch {
        $Content = "Error reading file."
    }

    # Write to Markdown File
    $MdBlock = "### File: `$RelativePath``n```$Extension`n$Content`n````n`n--------------------------------------------------------------------------------`n`n"
    [System.IO.File]::AppendAllText($OutputMD, $MdBlock)

    # Write to XML File
    $XmlBlock = "    <document>`n      <path>$RelativePath</path>`n      <content><![CDATA[`n$Content`n      ]]></content>`n    </document>`n"
    [System.IO.File]::AppendAllText($OutputXML, $XmlBlock)

    $ProcessedCount++

    # Loading Animation (Spinner) using Carriage Return (`r)
    $SpinIdx = $ProcessedCount % 4
    $SpinChar = $Spinner[$SpinIdx]
    Write-Host -NoNewline "`r[$SpinChar] Extracting magic... $ProcessedCount files dumped" -ForegroundColor Blue
}

# Close XML root tag
[System.IO.File]::AppendAllText($OutputXML, "  </files>`n</project_dump>`n")

# Clear the loading line
Write-Host -NoNewline "`r$([char]27)[K"

# Boom! Done.
Write-Host ">>> Boom! $ProcessedCount files dumped successfully." -ForegroundColor Green
Write-Host "[MD]  Markdown: $OutputMD (Best for ChatGPT / Gemini)" -ForegroundColor Cyan
Write-Host "[XML] XML:      $OutputXML (Best for Claude)" -ForegroundColor Cyan
Write-Host ""