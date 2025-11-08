# Push Blood Banking System to CICD_Lab Repository
# Repository: https://github.com/klu2300031981/CICD_Lab

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Push Project to CICD_Lab Repository" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Get current directory
$currentDir = Get-Location
Write-Host "Current directory: $currentDir" -ForegroundColor Gray
Write-Host ""

# Check if git is installed
Write-Host "Step 1: Checking Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "✅ Git installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git not installed. Install from: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Initialize git if needed
Write-Host "Step 2: Initializing Git repository..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    git init
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git repository already exists" -ForegroundColor Green
}

Write-Host ""

# Check git status
Write-Host "Step 3: Checking files..." -ForegroundColor Yellow
$status = git status --short 2>&1
if ($status -match "fatal") {
    Write-Host "⚠️  No files tracked yet" -ForegroundColor Yellow
} else {
    $fileCount = ($status | Measure-Object -Line).Lines
    Write-Host "✅ Found $fileCount files/changes" -ForegroundColor Green
}

Write-Host ""

# Add all files
Write-Host "Step 4: Adding all files..." -ForegroundColor Yellow
git add . 2>&1 | Out-Null
Write-Host "✅ All files added" -ForegroundColor Green

Write-Host ""

# Check what will be committed
Write-Host "Step 5: Files to commit:" -ForegroundColor Yellow
$filesToCommit = git status --short
if ($filesToCommit) {
    $filesToCommit | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    $total = ($filesToCommit | Measure-Object -Line).Lines
    if ($total -gt 10) {
        Write-Host "  ... and $($total - 10) more files" -ForegroundColor Gray
    }
    Write-Host "  Total: $total files" -ForegroundColor Green
} else {
    Write-Host "  No new files to commit" -ForegroundColor Yellow
}

Write-Host ""

# Check if there are changes
$hasChanges = git diff --cached --quiet 2>&1
if ($LASTEXITCODE -ne 0 -or $filesToCommit) {
    # Create commit
    Write-Host "Step 6: Creating commit..." -ForegroundColor Yellow
    $commitMsg = "Initial commit: Blood Banking System - Kubernetes Deployment with Helm and Ingress"
    git commit -m $commitMsg 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Commit created successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Commit may have issues, but continuing..." -ForegroundColor Yellow
    }
} else {
    Write-Host "Step 6: No changes to commit" -ForegroundColor Yellow
}

Write-Host ""

# Set branch to main
Write-Host "Step 7: Setting branch to main..." -ForegroundColor Yellow
git branch -M main 2>&1 | Out-Null
Write-Host "✅ Branch set to main" -ForegroundColor Green

Write-Host ""

# Configure remote
Write-Host "Step 8: Configuring remote repository..." -ForegroundColor Yellow
$remoteUrl = "https://github.com/klu2300031981/CICD_Lab.git"

# Check if remote exists
$remoteCheck = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    git remote add origin $remoteUrl 2>&1 | Out-Null
    Write-Host "✅ Remote added: $remoteUrl" -ForegroundColor Green
} else {
    if ($remoteCheck -ne $remoteUrl) {
        git remote set-url origin $remoteUrl 2>&1 | Out-Null
        Write-Host "✅ Remote updated: $remoteUrl" -ForegroundColor Green
    } else {
        Write-Host "✅ Remote already configured: $remoteUrl" -ForegroundColor Green
    }
}

Write-Host ""

# Show summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  READY TO PUSH" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Repository: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Cyan
Write-Host ""

# Check commit history
$commits = git log --oneline -1 2>&1
if ($commits -notmatch "fatal") {
    Write-Host "Latest commit:" -ForegroundColor Yellow
    Write-Host "  $commits" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "⚠️  IMPORTANT: You need a Personal Access Token!" -ForegroundColor Yellow
Write-Host ""
Write-Host "When prompted:" -ForegroundColor White
Write-Host "  Username: klu2300031981" -ForegroundColor Gray
Write-Host "  Password: [Your Personal Access Token]" -ForegroundColor Gray
Write-Host ""
Write-Host "Create token at: https://github.com/settings/tokens" -ForegroundColor Cyan
Write-Host "  - Click 'Generate new token (classic)'" -ForegroundColor Gray
Write-Host "  - Select 'repo' scope" -ForegroundColor Gray
Write-Host "  - Copy and use as password" -ForegroundColor Gray
Write-Host ""

$push = Read-Host "Push to GitHub now? (y/n)"
if ($push -eq "y" -or $push -eq "Y") {
    Write-Host "`nPushing to GitHub..." -ForegroundColor Yellow
    Write-Host "This may take a few moments...`n" -ForegroundColor Gray
    
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅✅✅ SUCCESS! ✅✅✅" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your project has been pushed to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Repository URL: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. Visit: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor White
        Write-Host "2. Verify all files are there" -ForegroundColor White
        Write-Host "3. Add repository description" -ForegroundColor White
        Write-Host "4. Add topics: kubernetes, helm, docker, react, spring-boot" -ForegroundColor White
    } else {
        Write-Host "`n❌ Push failed. Common issues:" -ForegroundColor Red
        Write-Host ""
        Write-Host "1. Authentication failed:" -ForegroundColor Yellow
        Write-Host "   - Use Personal Access Token (not password)" -ForegroundColor White
        Write-Host "   - Create at: https://github.com/settings/tokens" -ForegroundColor White
        Write-Host ""
        Write-Host "2. Repository not found:" -ForegroundColor Yellow
        Write-Host "   - Verify repository exists: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor White
        Write-Host ""
        Write-Host "3. Try again:" -ForegroundColor Yellow
        Write-Host "   git push -u origin main" -ForegroundColor White
    }
} else {
    Write-Host "`nTo push manually, run:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor White
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host ""

