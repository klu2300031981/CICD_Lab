# Blood Banking System - Project Execution Script
# PowerShell script for Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Blood Banking System - Execution Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Prerequisites
Write-Host "Step 1: Checking Prerequisites..." -ForegroundColor Yellow
Write-Host ""

$prerequisitesMet = $true

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Gray
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker is installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "   Please install Docker Desktop from https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    $prerequisitesMet = $false
}

# Check kubectl
Write-Host "Checking kubectl..." -ForegroundColor Gray
try {
    $kubectlVersion = kubectl version --client --short 2>&1
    Write-Host "✅ kubectl is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl is not installed or not in PATH" -ForegroundColor Red
    Write-Host "   Install from: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/" -ForegroundColor Yellow
    $prerequisitesMet = $false
}

# Check Helm
Write-Host "Checking Helm..." -ForegroundColor Gray
try {
    $helmVersion = helm version --short
    Write-Host "✅ Helm is installed: $helmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Helm is not installed or not in PATH" -ForegroundColor Red
    Write-Host "   Install from: https://helm.sh/docs/intro/install/" -ForegroundColor Yellow
    $prerequisitesMet = $false
}

# Check Kubernetes cluster
Write-Host "Checking Kubernetes cluster connection..." -ForegroundColor Gray
try {
    $clusterInfo = kubectl cluster-info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Connected to Kubernetes cluster" -ForegroundColor Green
        kubectl cluster-info | Select-Object -First 1
    } else {
        throw "Not connected"
    }
} catch {
    Write-Host "❌ Cannot connect to Kubernetes cluster" -ForegroundColor Red
    Write-Host "   Options:" -ForegroundColor Yellow
    Write-Host "   1. Enable Kubernetes in Docker Desktop (Settings > Kubernetes)" -ForegroundColor Yellow
    Write-Host "   2. Install minikube: https://minikube.sigs.k8s.io/docs/start/" -ForegroundColor Yellow
    Write-Host "   3. Use a cloud Kubernetes cluster (GKE, EKS, AKS)" -ForegroundColor Yellow
    $prerequisitesMet = $false
}

Write-Host ""

if (-not $prerequisitesMet) {
    Write-Host "❌ Prerequisites not met. Please install missing tools and try again." -ForegroundColor Red
    exit 1
}

Write-Host "✅ All prerequisites are met!" -ForegroundColor Green
Write-Host ""

# Step 2: Build Docker Images
Write-Host "Step 2: Building Docker Images..." -ForegroundColor Yellow
Write-Host ""

$buildImages = Read-Host "Do you want to build Docker images? (y/n)"
if ($buildImages -eq "y" -or $buildImages -eq "Y") {
    Write-Host "Building backend image..." -ForegroundColor Gray
    Set-Location -Path "backend"
    docker build -t bloodbank-backend:1.0.0 .
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Backend build failed" -ForegroundColor Red
        Set-Location -Path ".."
        exit 1
    }
    Write-Host "✅ Backend image built successfully" -ForegroundColor Green
    Set-Location -Path ".."
    
    Write-Host "Building frontend image..." -ForegroundColor Gray
    Set-Location -Path "frontend"
    docker build -t bloodbank-frontend:1.0.0 --build-arg VITE_API_URL=/api .
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Frontend build failed" -ForegroundColor Red
        Set-Location -Path ".."
        exit 1
    }
    Write-Host "✅ Frontend image built successfully" -ForegroundColor Green
    Set-Location -Path ".."
} else {
    Write-Host "Skipping image build. Make sure images are available." -ForegroundColor Yellow
}

Write-Host ""

# Step 3: Load images to Kubernetes (for local clusters)
Write-Host "Step 3: Loading Images to Kubernetes..." -ForegroundColor Yellow
Write-Host ""

$loadImages = Read-Host "Are you using minikube or kind? (y/n)"
if ($loadImages -eq "y" -or $loadImages -eq "Y") {
    Write-Host "Loading backend image..." -ForegroundColor Gray
    minikube image load bloodbank-backend:1.0.0 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Backend image loaded to minikube" -ForegroundColor Green
    } else {
        kind load docker-image bloodbank-backend:1.0.0 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Backend image loaded to kind" -ForegroundColor Green
        }
    }
    
    Write-Host "Loading frontend image..." -ForegroundColor Gray
    minikube image load bloodbank-frontend:1.0.0 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Frontend image loaded to minikube" -ForegroundColor Green
    } else {
        kind load docker-image bloodbank-frontend:1.0.0 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Frontend image loaded to kind" -ForegroundColor Green
        }
    }
} else {
    Write-Host "Skipping image load. Make sure images are available in your registry." -ForegroundColor Yellow
}

Write-Host ""

# Step 4: Install Ingress Controller
Write-Host "Step 4: Installing Ingress Controller..." -ForegroundColor Yellow
Write-Host ""

$installIngress = Read-Host "Do you want to install NGINX Ingress Controller? (y/n)"
if ($installIngress -eq "y" -or $installIngress -eq "Y") {
    Write-Host "Installing NGINX Ingress Controller..." -ForegroundColor Gray
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
    Write-Host "Waiting for ingress controller to be ready..." -ForegroundColor Gray
    Start-Sleep -Seconds 10
    kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=300s
    Write-Host "✅ Ingress controller installed" -ForegroundColor Green
} else {
    Write-Host "Skipping ingress installation. Make sure ingress controller is installed." -ForegroundColor Yellow
}

Write-Host ""

# Step 5: Deploy with Helm
Write-Host "Step 5: Deploying with Helm..." -ForegroundColor Yellow
Write-Host ""

# Get configuration
$dbPassword = Read-Host "Enter database password (default: changeme)" -AsSecureString
$dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword))
if ([string]::IsNullOrEmpty($dbPasswordPlain)) {
    $dbPasswordPlain = "changeme"
}

$mailUsername = Read-Host "Enter email username (default: your-email@gmail.com)"
if ([string]::IsNullOrEmpty($mailUsername)) {
    $mailUsername = "your-email@gmail.com"
}

$mailPassword = Read-Host "Enter email password (default: your-password)" -AsSecureString
$mailPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($mailPassword))
if ([string]::IsNullOrEmpty($mailPasswordPlain)) {
    $mailPasswordPlain = "your-password"
}

Write-Host "Creating namespace..." -ForegroundColor Gray
kubectl create namespace bloodbank --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Deploying with Helm..." -ForegroundColor Gray
helm upgrade --install bloodbank ./helm/bloodbank `
    --namespace bloodbank `
    --set backend.image.repository=bloodbank-backend `
    --set backend.image.tag=1.0.0 `
    --set frontend.image.repository=bloodbank-frontend `
    --set frontend.image.tag=1.0.0 `
    --set backend.env.spring.datasource.password=$dbPasswordPlain `
    --set backend.env.spring.mail.username=$mailUsername `
    --set backend.env.spring.mail.password=$mailPasswordPlain `
    --set ingress.enabled=true `
    --set ingress.hosts[0].host=bloodbank.local `
    --wait --timeout=10m

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green
Write-Host ""

# Step 6: Verify Deployment
Write-Host "Step 6: Verifying Deployment..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Pod Status:" -ForegroundColor Cyan
kubectl get pods -n bloodbank

Write-Host "`nService Status:" -ForegroundColor Cyan
kubectl get svc -n bloodbank

Write-Host "`nIngress Status:" -ForegroundColor Cyan
kubectl get ingress -n bloodbank

Write-Host "`nHPA Status:" -ForegroundColor Cyan
kubectl get hpa -n bloodbank

Write-Host ""

# Step 7: Get Access Information
Write-Host "Step 7: Access Information..." -ForegroundColor Yellow
Write-Host ""

# Get ingress IP or hostname
$ingressHost = kubectl get ingress -n bloodbank -o jsonpath='{.items[0].spec.rules[0].host}' 2>$null
$ingressIP = kubectl get ingress -n bloodbank -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}' 2>$null

if ([string]::IsNullOrEmpty($ingressIP)) {
    # Try to get NodePort or port-forward
    Write-Host "Setting up port-forward for local access..." -ForegroundColor Gray
    Write-Host ""
    Write-Host "Access the application using:" -ForegroundColor Cyan
    Write-Host "  Frontend: http://localhost:3000" -ForegroundColor Green
    Write-Host "  Backend API: http://localhost:8080" -ForegroundColor Green
    Write-Host ""
    Write-Host "Run these commands in separate terminals:" -ForegroundColor Yellow
    Write-Host "  kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80" -ForegroundColor White
    Write-Host "  kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080" -ForegroundColor White
} else {
    Write-Host "Application is accessible at:" -ForegroundColor Cyan
    Write-Host "  http://$ingressHost" -ForegroundColor Green
    Write-Host "  http://$ingressIP" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  View pods: kubectl get pods -n bloodbank" -ForegroundColor White
Write-Host "  View logs: kubectl logs -f deployment/bloodbank-backend -n bloodbank" -ForegroundColor White
Write-Host "  View logs: kubectl logs -f deployment/bloodbank-frontend -n bloodbank" -ForegroundColor White
Write-Host "  Delete deployment: helm uninstall bloodbank -n bloodbank" -ForegroundColor White
Write-Host ""


