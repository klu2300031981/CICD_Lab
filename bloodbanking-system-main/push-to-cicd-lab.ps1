# Push Blood Banking System to CICD_Lab Repository
# Repository: https://github.com/klu2300031981/CICD_Lab

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Push to CICD_Lab Repository" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check if git is installed
Write-Host "Checking Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "✅ Git is installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    Write-Host "   Download from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Navigate to project directory
$projectPath = Get-Location
Write-Host "Current directory: $projectPath" -ForegroundColor Gray
Write-Host ""

# Initialize git if not already done
if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git repository already initialized" -ForegroundColor Green
}

Write-Host ""

# Configure git user (if not set)
$userName = git config user.name
$userEmail = git config user.email

if ([string]::IsNullOrEmpty($userName)) {
    Write-Host "⚠️  Git user name not set" -ForegroundColor Yellow
    $setName = Read-Host "Enter your name for git commits (or press Enter to skip)"
    if (-not [string]::IsNullOrEmpty($setName)) {
        git config --global user.name $setName
    }
}

if ([string]::IsNullOrEmpty($userEmail)) {
    Write-Host "⚠️  Git user email not set" -ForegroundColor Yellow
    $setEmail = Read-Host "Enter your email for git commits (or press Enter to skip)"
    if (-not [string]::IsNullOrEmpty($setEmail)) {
        git config --global user.email $setEmail
    }
}

Write-Host ""

# Add all files
Write-Host "Adding all files to git..." -ForegroundColor Yellow
git add .
Write-Host "✅ Files added" -ForegroundColor Green

Write-Host ""

# Show what will be committed
Write-Host "Files to be committed:" -ForegroundColor Yellow
$files = git status --short
if ($files) {
    $files | Select-Object -First 20 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    $totalFiles = ($files | Measure-Object).Count
    if ($totalFiles -gt 20) {
        Write-Host "  ... and $($totalFiles - 20) more files" -ForegroundColor Gray
    }
    Write-Host "  Total: $totalFiles files" -ForegroundColor Green
} else {
    Write-Host "  No changes to commit" -ForegroundColor Yellow
}

Write-Host ""

# Check if there are changes to commit
$status = git status --porcelain
if ([string]::IsNullOrEmpty($status)) {
    Write-Host "⚠️  No changes to commit. Checking if remote is set up..." -ForegroundColor Yellow
} else {
    # Create commit
    Write-Host "Creating commit..." -ForegroundColor Yellow
    $commitMessage = @"
Initial commit: Blood Banking System

- Full-stack application (React frontend + Spring Boot backend)
- Kubernetes deployment with Helm charts
- Docker containerization
- Ingress configuration
- HPA for auto-scaling
- CI/CD pipeline with GitHub Actions
- Complete documentation
"@

    git commit -m $commitMessage
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Commit created" -ForegroundColor Green
    } else {
        Write-Host "❌ Commit failed" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# Set branch to main
Write-Host "Setting branch to main..." -ForegroundColor Yellow
git branch -M main
Write-Host "✅ Branch set to main" -ForegroundColor Green

Write-Host ""

# Check/Set remote
Write-Host "Configuring remote repository..." -ForegroundColor Yellow
$remoteUrl = "https://github.com/klu2300031981/CICD_Lab.git"
$remoteExists = git remote get-url origin 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Adding remote repository..." -ForegroundColor Yellow
    git remote add origin $remoteUrl
    Write-Host "✅ Remote added: $remoteUrl" -ForegroundColor Green
} else {
    if ($remoteExists -ne $remoteUrl) {
        Write-Host "Current remote: $remoteExists" -ForegroundColor Gray
        Write-Host "Updating remote to: $remoteUrl" -ForegroundColor Yellow
        git remote set-url origin $remoteUrl
        Write-Host "✅ Remote updated" -ForegroundColor Green
    } else {
        Write-Host "✅ Remote already configured: $remoteUrl" -ForegroundColor Green
    }
}

Write-Host ""

# Verify remote
Write-Host "Verifying remote configuration..." -ForegroundColor Yellow
git remote -v
Write-Host ""

# Push to GitHub
Write-Host "=== READY TO PUSH ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Repository: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  IMPORTANT: Authentication Required" -ForegroundColor Yellow
Write-Host ""
Write-Host "You will be prompted for:" -ForegroundColor White
Write-Host "  Username: klu2300031981" -ForegroundColor Gray
Write-Host "  Password: [Your Personal Access Token - NOT your GitHub password]" -ForegroundColor Gray
Write-Host ""
Write-Host "Don't have a token? Create one at:" -ForegroundColor Yellow
Write-Host "  https://github.com/settings/tokens" -ForegroundColor White
Write-Host ""
Write-Host "Steps to create token:" -ForegroundColor Yellow
Write-Host "  1. Go to: https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host "  2. Click 'Generate new token' > 'Generate new token (classic)'" -ForegroundColor Gray
Write-Host "  3. Name: 'CICD_Lab Access'" -ForegroundColor Gray
Write-Host "  4. Select scope: 'repo' (Full control)" -ForegroundColor Gray
Write-Host "  5. Click 'Generate token'" -ForegroundColor Gray
Write-Host "  6. Copy the token and use it as password" -ForegroundColor Gray
Write-Host ""

$push = Read-Host "Push to GitHub now? (y/n)"
if ($push -eq "y" -or $push -eq "Y") {
    Write-Host "`nPushing to GitHub..." -ForegroundColor Yellow
    Write-Host "This may take a few moments..." -ForegroundColor Gray
    Write-Host ""
    
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅✅✅ SUCCESS! ✅✅✅" -ForegroundColor Green
        Write-Host ""
        Write-Host "Repository successfully pushed to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Repository URL: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. Visit: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor White
        Write-Host "2. Verify all files are uploaded" -ForegroundColor White
        Write-Host "3. Add repository description" -ForegroundColor White
        Write-Host "4. Add topics: kubernetes, helm, docker, react, spring-boot" -ForegroundColor White
        Write-Host "5. Configure repository settings" -ForegroundColor White
    } else {
        Write-Host "`n❌ Push failed. Check the error above." -ForegroundColor Red
        Write-Host ""
        Write-Host "Common issues:" -ForegroundColor Yellow
        Write-Host "- Authentication failed: Use Personal Access Token (not password)" -ForegroundColor White
        Write-Host "- Repository not found: Verify repository exists at the URL" -ForegroundColor White
        Write-Host "- Permission denied: Check repository access and token permissions" -ForegroundColor White
        Write-Host "- Connection timeout: Check internet connection" -ForegroundColor White
        Write-Host ""
        Write-Host "Try again or push manually:" -ForegroundColor Yellow
        Write-Host "  git push -u origin main" -ForegroundColor White
    }
} else {
    Write-Host "`nTo push manually, run:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "Repository URL: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Cyan
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host ""

