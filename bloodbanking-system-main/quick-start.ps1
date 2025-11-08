# Quick Start Script for Blood Banking System
# This script provides a quick way to get started

Write-Host "Blood Banking System - Quick Start" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check Kubernetes
Write-Host "Checking Kubernetes..." -ForegroundColor Yellow
try {
    kubectl cluster-info | Out-Null
    Write-Host "✅ Kubernetes is available" -ForegroundColor Green
} catch {
    Write-Host "❌ Kubernetes is not available. Please enable Kubernetes in Docker Desktop." -ForegroundColor Red
    Write-Host "   Settings > Kubernetes > Enable Kubernetes" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting deployment..." -ForegroundColor Yellow
Write-Host ""

# Build images
Write-Host "Building Docker images..." -ForegroundColor Cyan
docker build -t bloodbank-backend:1.0.0 ./backend
docker build -t bloodbank-frontend:1.0.0 --build-arg VITE_API_URL=/api ./frontend

# Install ingress
Write-Host "Installing Ingress Controller..." -ForegroundColor Cyan
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml | Out-Null
Start-Sleep -Seconds 5

# Create namespace
Write-Host "Creating namespace..." -ForegroundColor Cyan
kubectl create namespace bloodbank --dry-run=client -o yaml | kubectl apply -f - | Out-Null

# Deploy
Write-Host "Deploying application..." -ForegroundColor Cyan
helm upgrade --install bloodbank ./helm/bloodbank `
    --namespace bloodbank `
    --set backend.image.repository=bloodbank-backend `
    --set backend.image.tag=1.0.0 `
    --set frontend.image.repository=bloodbank-frontend `
    --set frontend.image.tag=1.0.0 `
    --set backend.env.spring.datasource.password=changeme `
    --set backend.env.spring.mail.username=test@test.com `
    --set backend.env.spring.mail.password=test `
    --set ingress.enabled=false `
    --wait --timeout=10m

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Setting up port-forward..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Access the application at:" -ForegroundColor Yellow
Write-Host "  Frontend: http://localhost:3000" -ForegroundColor Green
Write-Host "  Backend:  http://localhost:8080" -ForegroundColor Green
Write-Host ""
Write-Host "Run these commands in separate terminals:" -ForegroundColor Yellow
Write-Host "  kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80" -ForegroundColor White
Write-Host "  kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080" -ForegroundColor White
Write-Host ""

# Show status
Write-Host "Current Status:" -ForegroundColor Cyan
kubectl get pods -n bloodbank
Write-Host ""
kubectl get svc -n bloodbank


