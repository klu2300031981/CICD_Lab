# Show Expected Output - Blood Banking System
# This script shows what the deployment output will look like

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  BLOOD BANKING SYSTEM - EXPECTED OUTPUT" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check what's available
Write-Host "=== CURRENT SYSTEM STATUS ===" -ForegroundColor Yellow
Write-Host ""

# Check Docker
try {
    $docker = docker --version 2>&1
    Write-Host "✅ Docker: $docker" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker: Not available" -ForegroundColor Red
}

# Check kubectl
try {
    $kubectl = kubectl version --client 2>&1 | Select-String "Client Version" -Quiet
    if ($kubectl) {
        Write-Host "✅ kubectl: Installed" -ForegroundColor Green
    } else {
        Write-Host "❌ kubectl: Not available" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ kubectl: Not available" -ForegroundColor Red
}

# Check Helm
try {
    $helm = helm version --short 2>&1
    Write-Host "✅ Helm: $helm" -ForegroundColor Green
} catch {
    Write-Host "❌ Helm: Not installed (install with: choco install kubernetes-helm)" -ForegroundColor Red
}

# Check Kubernetes
try {
    $k8s = kubectl cluster-info 2>&1 | Select-String "is running" -Quiet
    if ($k8s) {
        Write-Host "✅ Kubernetes: Running" -ForegroundColor Green
    } else {
        Write-Host "❌ Kubernetes: Not running (enable in Docker Desktop)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Kubernetes: Not running (enable in Docker Desktop)" -ForegroundColor Red
}

Write-Host "`n=== EXPECTED DEPLOYMENT OUTPUT ===" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. POD STATUS (After Deployment):" -ForegroundColor Cyan
Write-Host "   NAME                                  READY   STATUS    RESTARTS   AGE" -ForegroundColor Gray
Write-Host "   bloodbank-backend-7d8f9c4b5d-abc12    1/1     Running   0          45s" -ForegroundColor Green
Write-Host "   bloodbank-backend-7d8f9c4b5d-xyz78    1/1     Running   0          45s" -ForegroundColor Green
Write-Host "   bloodbank-frontend-6c5e4d3b2a-def45   1/1     Running   0          42s" -ForegroundColor Green
Write-Host "   bloodbank-frontend-6c5e4d3b2a-ghi90   1/1     Running   0          42s" -ForegroundColor Green
Write-Host "   bloodbank-mysql-8b7a6c5d4e-jkl23      1/1     Running   0          50s" -ForegroundColor Green

Write-Host "`n2. SERVICE STATUS:" -ForegroundColor Cyan
Write-Host "   NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE" -ForegroundColor Gray
Write-Host "   bloodbank-backend     ClusterIP   10.96.145.23    <none>        8080/TCP   1m" -ForegroundColor Green
Write-Host "   bloodbank-frontend    ClusterIP   10.96.152.45    <none>        80/TCP     1m" -ForegroundColor Green
Write-Host "   bloodbank-mysql       ClusterIP   10.96.138.67    <none>        3306/TCP   1m" -ForegroundColor Green

Write-Host "`n3. HPA (Auto-Scaling) STATUS:" -ForegroundColor Cyan
Write-Host "   NAME                        REFERENCE                      TARGETS         MINPODS   MAXPODS   REPLICAS   AGE" -ForegroundColor Gray
Write-Host "   bloodbank-backend-hpa       Deployment/bloodbank-backend   0%/70%, 0%/80%  2         10        2          1m" -ForegroundColor Green
Write-Host "   bloodbank-frontend-hpa      Deployment/bloodbank-frontend  0%/70%          2         10        2          1m" -ForegroundColor Green

Write-Host "`n4. INGRESS STATUS:" -ForegroundColor Cyan
Write-Host "   NAME                CLASS   HOSTS              ADDRESS        PORTS     AGE" -ForegroundColor Gray
Write-Host "   bloodbank-ingress   nginx   bloodbank.local    <pending>      80        1m" -ForegroundColor Green

Write-Host "`n5. APPLICATION ACCESS (STEP-BY-STEP):" -ForegroundColor Cyan
Write-Host "   ⚠️  IMPORTANT: These links ONLY work AFTER setup!" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Step 1: Deploy the application" -ForegroundColor White
Write-Host "     .\EXECUTE_PROJECT.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "   Step 2: Set up port-forward (Run in separate terminals):" -ForegroundColor White
Write-Host "     Terminal 1: kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80" -ForegroundColor Gray
Write-Host "     Terminal 2: kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080" -ForegroundColor Gray
Write-Host ""
Write-Host "   Step 3: Then access in browser:" -ForegroundColor White
Write-Host "     Frontend: http://localhost:3000" -ForegroundColor Green
Write-Host "     Backend:  http://localhost:8080" -ForegroundColor Green
Write-Host "     Health:   http://localhost:8080/actuator/health" -ForegroundColor Green
Write-Host ""
Write-Host "   NOTE: Links will NOT work until:" -ForegroundColor Yellow
Write-Host "     ✓ Deployment is complete" -ForegroundColor Gray
Write-Host "     ✓ Port-forward commands are running" -ForegroundColor Gray
Write-Host "     ✓ Services are ready (check with: kubectl get svc -n bloodbank)" -ForegroundColor Gray

Write-Host "`n=== HOW TO SEE REAL OUTPUT ===" -ForegroundColor Yellow
Write-Host ""

# Check if we can show real output
$canDeploy = $false

try {
    $helmCheck = helm version --short 2>&1
    $k8sCheck = kubectl cluster-info 2>&1 | Select-String "is running" -Quiet
    if ($helmCheck -and $k8sCheck) {
        $canDeploy = $true
    }
} catch {
    $canDeploy = $false
}

if ($canDeploy) {
    Write-Host "✅ You can deploy now! Run:" -ForegroundColor Green
    Write-Host "   .\EXECUTE_PROJECT.ps1" -ForegroundColor White
    Write-Host "`n   Or check current deployment:" -ForegroundColor Yellow
    Write-Host "   kubectl get all -n bloodbank" -ForegroundColor White
} else {
    Write-Host "❌ Setup required first:" -ForegroundColor Red
    Write-Host "   1. Install Helm: choco install kubernetes-helm" -ForegroundColor Yellow
    Write-Host "   2. Enable Kubernetes in Docker Desktop" -ForegroundColor Yellow
    Write-Host "   3. Then run: .\EXECUTE_PROJECT.ps1" -ForegroundColor Yellow
}

Write-Host "`n=== COMMANDS TO VIEW OUTPUT ===" -ForegroundColor Yellow
Write-Host ""
Write-Host "After deployment, use these commands to see output:" -ForegroundColor White
Write-Host ""
Write-Host "View all resources:" -ForegroundColor Cyan
Write-Host "  kubectl get all -n bloodbank" -ForegroundColor Gray
Write-Host ""
Write-Host "View pods:" -ForegroundColor Cyan
Write-Host "  kubectl get pods -n bloodbank" -ForegroundColor Gray
Write-Host ""
Write-Host "View services:" -ForegroundColor Cyan
Write-Host "  kubectl get svc -n bloodbank" -ForegroundColor Gray
Write-Host ""
Write-Host "View HPA:" -ForegroundColor Cyan
Write-Host "  kubectl get hpa -n bloodbank" -ForegroundColor Gray
Write-Host ""
Write-Host "View logs:" -ForegroundColor Cyan
Write-Host "  kubectl logs -f deployment/bloodbank-backend -n bloodbank" -ForegroundColor Gray
Write-Host "  kubectl logs -f deployment/bloodbank-frontend -n bloodbank" -ForegroundColor Gray
Write-Host ""
Write-Host "View detailed pod info:" -ForegroundColor Cyan
Write-Host "  kubectl describe pod <pod-name> -n bloodbank" -ForegroundColor Gray
Write-Host ""
Write-Host "Watch pods in real-time:" -ForegroundColor Cyan
Write-Host "  kubectl get pods -n bloodbank -w" -ForegroundColor Gray

Write-Host "`n=== FILES WITH OUTPUT EXAMPLES ===" -ForegroundColor Yellow
Write-Host ""
Write-Host "  - EXPECTED_OUTPUT.md (Detailed output examples)" -ForegroundColor White
Write-Host "  - SETUP_GUIDE.md (Setup instructions)" -ForegroundColor White
Write-Host "  - EXECUTE_PROJECT.md (Execution guide)" -ForegroundColor White

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host ""

# Try to show current deployment if it exists
try {
    $existing = kubectl get pods -n bloodbank 2>&1
    if ($existing -notmatch "Error" -and $existing -notmatch "NotFound") {
        Write-Host "=== CURRENT DEPLOYMENT (If Exists) ===" -ForegroundColor Yellow
        Write-Host ""
        kubectl get all -n bloodbank
        Write-Host ""
    }
} catch {
    # No deployment yet
}

Write-Host "Run this script anytime to see expected output!" -ForegroundColor Green
Write-Host ""

