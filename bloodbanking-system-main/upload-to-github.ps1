# Upload Blood Banking System to GitHub
# GitHub Account: https://github.com/klu2300031981
# Repository: https://github.com/klu2300031981/CICD_Lab

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Upload to GitHub - Blood Banking System" -ForegroundColor Cyan
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

# Check if we're in a git repository
$isGitRepo = Test-Path ".git"
if (-not $isGitRepo) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git repository already initialized" -ForegroundColor Green
}

Write-Host ""

# Check git config
Write-Host "Checking git configuration..." -ForegroundColor Yellow
$userName = git config user.name
$userEmail = git config user.email

if ([string]::IsNullOrEmpty($userName)) {
    Write-Host "⚠️  Git user name not set" -ForegroundColor Yellow
    $setName = Read-Host "Enter your name for git commits"
    git config --global user.name $setName
}

if ([string]::IsNullOrEmpty($userEmail)) {
    Write-Host "⚠️  Git user email not set" -ForegroundColor Yellow
    $setEmail = Read-Host "Enter your email for git commits"
    git config --global user.email $setEmail
}

Write-Host "✅ Git configured" -ForegroundColor Green
Write-Host ""

# Check current status
Write-Host "Checking repository status..." -ForegroundColor Yellow
git status

Write-Host "`n=== PREPARATION STEPS ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Before uploading, make sure you have:" -ForegroundColor Yellow
Write-Host "1. Created a repository on GitHub:" -ForegroundColor White
Write-Host "   https://github.com/new" -ForegroundColor Gray
Write-Host "   Repository name: bloodbanking-system" -ForegroundColor Gray
Write-Host "   Description: Blood Banking System - Kubernetes Deployment" -ForegroundColor Gray
Write-Host "   Visibility: Public (or Private)" -ForegroundColor Gray
Write-Host "   DO NOT initialize with README" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Have your GitHub credentials ready:" -ForegroundColor White
Write-Host "   - Username: klu2300031981" -ForegroundColor Gray
Write-Host "   - Personal Access Token (not password)" -ForegroundColor Gray
Write-Host "   Create token at: https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host ""

Write-Host "Repository URL: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Green
$continue = Read-Host "`nReady to push to CICD_Lab repository? (y/n)"
if ($continue -ne "y" -and $continue -ne "Y") {
    Write-Host "`nExiting. Run this script again when ready." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# Add all files
Write-Host "Adding all files to git..." -ForegroundColor Yellow
git add .
Write-Host "✅ Files added" -ForegroundColor Green

Write-Host ""

# Show what will be committed
Write-Host "Files to be committed:" -ForegroundColor Yellow
git status --short | Select-Object -First 20
$totalFiles = (git status --short | Measure-Object).Count
Write-Host "... and $totalFiles more files`n" -ForegroundColor Gray

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
Write-Host "✅ Commit created" -ForegroundColor Green

Write-Host ""

# Check if remote exists
Write-Host "Checking remote repository..." -ForegroundColor Yellow
$remoteExists = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Adding remote repository..." -ForegroundColor Yellow
    git remote add origin https://github.com/klu2300031981/CICD_Lab.git
    Write-Host "✅ Remote added: https://github.com/klu2300031981/CICD_Lab.git" -ForegroundColor Green
} else {
    Write-Host "✅ Remote already exists: $remoteExists" -ForegroundColor Green
    $updateRemote = Read-Host "Update remote URL to CICD_Lab? (y/n)"
    if ($updateRemote -eq "y" -or $updateRemote -eq "Y") {
        git remote set-url origin https://github.com/klu2300031981/CICD_Lab.git
        Write-Host "✅ Remote updated to CICD_Lab" -ForegroundColor Green
    }
}

Write-Host ""

# Set branch to main
Write-Host "Setting branch to main..." -ForegroundColor Yellow
git branch -M main
Write-Host "✅ Branch set to main" -ForegroundColor Green

Write-Host ""

# Push to GitHub
Write-Host "=== READY TO PUSH ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Repository URL: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Green
Write-Host ""
Write-Host "You will be prompted for:" -ForegroundColor Yellow
Write-Host "  Username: klu2300031981" -ForegroundColor White
Write-Host "  Password: [Your Personal Access Token]" -ForegroundColor White
Write-Host ""
Write-Host "If you don't have a Personal Access Token:" -ForegroundColor Yellow
Write-Host "  1. Go to: https://github.com/settings/tokens" -ForegroundColor White
Write-Host "  2. Generate new token (classic)" -ForegroundColor White
Write-Host "  3. Select 'repo' scope" -ForegroundColor White
Write-Host "  4. Copy the token and use it as password" -ForegroundColor White
Write-Host ""

$push = Read-Host "Push to GitHub now? (y/n)"
if ($push -eq "y" -or $push -eq "Y") {
    Write-Host "`nPushing to GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Successfully uploaded to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Repository URL: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. Visit your repository: https://github.com/klu2300031981/CICD_Lab" -ForegroundColor White
        Write-Host "2. Add repository description and topics" -ForegroundColor White
        Write-Host "3. Configure repository settings" -ForegroundColor White
    } else {
        Write-Host "`n❌ Push failed. Check the error above." -ForegroundColor Red
        Write-Host ""
        Write-Host "Common issues:" -ForegroundColor Yellow
        Write-Host "- Authentication failed: Use Personal Access Token" -ForegroundColor White
        Write-Host "- Repository not found: Make sure repository exists" -ForegroundColor White
        Write-Host "- Permission denied: Check repository access" -ForegroundColor White
    }
} else {
    Write-Host "`nTo push manually, run:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor White
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host ""

