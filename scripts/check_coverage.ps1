# Coverage Check Script (PowerShell)
# This script validates that code coverage meets the minimum threshold

param(
    [int]$MinCoverage = 70
)

$ErrorActionPreference = "Stop"

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "  Code Coverage Threshold Check" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

$coverageFile = "coverage\lcov.info"

# Check if coverage file exists
if (-not (Test-Path $coverageFile)) {
    Write-Host "❌ Coverage file not found: $coverageFile" -ForegroundColor Red
    Write-Host "Please run 'flutter test --coverage' first" -ForegroundColor Yellow
    exit 1
}

# Function to calculate coverage percentage
function Get-CoveragePercentage {
    $content = Get-Content $coverageFile
    
    $linesFound = 0
    $linesHit = 0
    
    foreach ($line in $content) {
        if ($line -match "^LF:(\d+)") {
            $linesFound += [int]$matches[1]
        }
        if ($line -match "^LH:(\d+)") {
            $linesHit += [int]$matches[1]
        }
    }
    
    if ($linesFound -eq 0) {
        return 0
    }
    
    return [math]::Round(($linesHit * 100) / $linesFound, 2)
}

# Get current coverage
$currentCoverage = Get-CoveragePercentage

Write-Host "Current Coverage: " -NoNewline -ForegroundColor Yellow
Write-Host "${currentCoverage}%" -ForegroundColor White
Write-Host "Minimum Required: " -NoNewline -ForegroundColor Yellow
Write-Host "${MinCoverage}%" -ForegroundColor White
Write-Host ""

# Compare with threshold
if ($currentCoverage -lt $MinCoverage) {
    Write-Host "❌ FAILED: Coverage ${currentCoverage}% is below minimum ${MinCoverage}%" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please add more tests to increase code coverage." -ForegroundColor Yellow
    exit 1
} else {
    $diff = [math]::Round($currentCoverage - $MinCoverage, 2)
    Write-Host "✅ PASSED: Coverage check successful!" -ForegroundColor Green
    Write-Host "Coverage is ${diff}% above the minimum threshold." -ForegroundColor Green
    exit 0
}
