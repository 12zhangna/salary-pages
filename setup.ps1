param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUser
)

$GIT = "C:\Program Files\Git\cmd\git.exe"
$REPO = "C:\Users\admin\salary-pages"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  GitHub Pages First Setup" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Set remote
Write-Host "[1/3] Configure remote..." -ForegroundColor Green
$remoteUrl = "https://github.com/$GitHubUser/salary-pages.git"
& $GIT -C $REPO remote remove origin 2>&1 | Out-Null
& $GIT -C $REPO remote add origin $remoteUrl
Write-Host "    OK" -ForegroundColor DarkGray
Write-Host "    Remote: $remoteUrl" -ForegroundColor Gray

# Create initial commit
Write-Host "[2/3] Create initial commit..." -ForegroundColor Green
$sysFile = Join-Path $REPO "system.html"
$sysCopyFile = Join-Path $REPO "system-copy.html"
if (-not (Test-Path $sysFile)) {
    Set-Content -Path $sysFile -Value "<html><body>System not yet published. Click publish button first.</body></html>"
}
if (-not (Test-Path $sysCopyFile)) {
    Set-Content -Path $sysCopyFile -Value "<html><body>System not yet published. Click publish button first.</body></html>"
}
& $GIT -C $REPO add -A
& $GIT -C $REPO commit -m "Initial setup" 2>&1 | Out-Null
Write-Host "    OK" -ForegroundColor DarkGray

# Push
Write-Host "[3/3] Push to GitHub..." -ForegroundColor Green
& $GIT -C $REPO branch -M main
$pushResult = & $GIT -C $REPO push -u origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "    OK" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "  Setup Complete!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor White
    Write-Host "  1. Open GitHub repo Settings -> Pages" -ForegroundColor White
    Write-Host "  2. Source: Deploy from a branch" -ForegroundColor White
    Write-Host "  3. Branch: main, Folder: /(root)" -ForegroundColor White
    Write-Host "  4. Click Save" -ForegroundColor White
    Write-Host ""
    Write-Host "  Your URLs:" -ForegroundColor White
    Write-Host "  Original: https://$GitHubUser.github.io/salary-pages/system.html" -ForegroundColor Cyan
    Write-Host "  Copy:     https://$GitHubUser.github.io/salary-pages/system-copy.html" -ForegroundColor Cyan
} else {
    Write-Host "    Push failed" -ForegroundColor Red
    Write-Host "    Error: $pushResult" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Please check:" -ForegroundColor Yellow
    Write-Host "  1. You created a repo named 'salary-pages' on GitHub" -ForegroundColor Yellow
    Write-Host "  2. GitHub username is correct ($GitHubUser)" -ForegroundColor Yellow
}

Write-Host ""
pause
