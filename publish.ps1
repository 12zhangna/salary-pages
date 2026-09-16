param(
    [Parameter(Mandatory=$true)]
    [string]$System
)

$GIT = "C:\Program Files\Git\cmd\git.exe"
$REPO = "C:\Users\admin\salary-pages"
$DOWNLOADS = [Environment]::GetFolderPath("UserProfile") + "\Downloads"

switch ($System) {
    "original" {
        $sourceFile = Join-Path $DOWNLOADS "_publish_system.html"
        $targetFile = Join-Path $REPO "system.html"
        $label = "Original System"
    }
    "copy" {
        $sourceFile = Join-Path $DOWNLOADS "_publish_system_copy.html"
        $targetFile = Join-Path $REPO "system-copy.html"
        $label = "Copy System"
    }
    default {
        Write-Host "Error: use 'original' or 'copy'" -ForegroundColor Red
        pause
        exit 1
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Publish $label to GitHub Pages" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if source file exists
if (-not (Test-Path $sourceFile)) {
    Write-Host "[X] Publish file not found!" -ForegroundColor Red
    Write-Host "    Please open the salary system in browser, click 'Publish' button first." -ForegroundColor Yellow
    Write-Host "    Expected file: $sourceFile" -ForegroundColor Gray
    Write-Host ""
    pause
    exit 1
}

# Copy file to repo
Write-Host "[1/4] Copy publish file to repo..." -ForegroundColor Green
Copy-Item -Path $sourceFile -Destination $targetFile -Force
Write-Host "    OK" -ForegroundColor DarkGray

# Git add
Write-Host "[2/4] Add to git staging..." -ForegroundColor Green
& $GIT -C $REPO add $targetFile
Write-Host "    OK" -ForegroundColor DarkGray

# Git commit
Write-Host "[3/4] Commit changes..." -ForegroundColor Green
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
& $GIT -C $REPO commit -m "Update $label - $timestamp" 2>&1 | Out-Null
Write-Host "    OK" -ForegroundColor DarkGray

# Git push
Write-Host "[4/4] Push to GitHub..." -ForegroundColor Green
$pushResult = & $GIT -C $REPO push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "    OK" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "  Publish Success!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  The other person can refresh the page to see latest data." -ForegroundColor White
    Write-Host "  (GitHub Pages may have 30-60s cache delay)" -ForegroundColor Gray
} else {
    Write-Host "    Push failed" -ForegroundColor Red
    Write-Host "    Error: $pushResult" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  If first time, run setup.bat first." -ForegroundColor Yellow
}

Write-Host ""
pause
