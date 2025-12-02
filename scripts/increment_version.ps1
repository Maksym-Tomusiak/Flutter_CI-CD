# Version Increment Script (PowerShell)
# Automatically increments the build number in pubspec.yaml

$ErrorActionPreference = "Stop"

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "  Version Increment Script" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

$pubspecFile = "pubspec.yaml"

# Check if pubspec.yaml exists
if (-not (Test-Path $pubspecFile)) {
    Write-Host "Error: $pubspecFile not found!" -ForegroundColor Red
    exit 1
}

# Read current version from pubspec.yaml
$content = Get-Content $pubspecFile
$versionLine = $content | Select-String "^version:"

if (-not $versionLine) {
    Write-Host "Error: Could not find version in $pubspecFile" -ForegroundColor Red
    exit 1
}

$currentVersion = ($versionLine -split ":\s*")[1].Trim()

Write-Host "Current version: " -NoNewline -ForegroundColor Yellow
Write-Host $currentVersion -ForegroundColor White

# Split version into name and build number
if ($currentVersion -match "^(.+)\+(\d+)$") {
    $versionName = $matches[1]
    $buildNumber = [int]$matches[2]
} else {
    # No build number, start with 0
    $versionName = $currentVersion
    $buildNumber = 0
}

# Increment build number
$newBuildNumber = $buildNumber + 1
$newVersion = "${versionName}+${newBuildNumber}"

Write-Host "New version: " -NoNewline -ForegroundColor Yellow
Write-Host $newVersion -ForegroundColor White
Write-Host ""

# Update pubspec.yaml
$newContent = $content -replace "^version:\s*$([regex]::Escape($currentVersion))", "version: $newVersion"
$newContent | Set-Content $pubspecFile -Encoding UTF8

Write-Host "✅ Version updated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Don't forget to commit this change:" -ForegroundColor Yellow
Write-Host "  git add $pubspecFile" -ForegroundColor Gray
Write-Host "  git commit -m `"chore: bump version to $newVersion`"" -ForegroundColor Gray
