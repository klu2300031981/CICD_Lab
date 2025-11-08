# Setup Guide - Get Ready to Execute

## Current Status Check

Based on the prerequisites check, you need to:

### ✅ Already Installed:
- Docker Desktop (version 28.5.1)
- kubectl

### ❌ Need to Install/Configure:
- Helm (NOT installed)
- Kubernetes (NOT running in Docker Desktop)

## Step-by-Step Setup

### Step 1: Install Helm

#### Option A: Using Chocolatey (Recommended for Windows)
```powershell
# Install Chocolatey if not installed
# Visit: https://chocolatey.org/install

# Install Helm
choco install kubernetes-helm
```

#### Option B: Manual Installation
1. Download Helm from: https://helm.sh/docs/intro/install/
2. Extract and add to PATH
3. Or use scoop: `scoop install helm`

#### Verify Installation:
```powershell
helm version
```

Expected output:
```
version.BuildInfo{Version:"v3.12.0", GitCommit:"...", GitTreeState:"clean", GoVersion:"go1.20"}
```

### Step 2: Enable Kubernetes in Docker Desktop

1. **Open Docker Desktop**
   - Look for the Docker icon in your system tray
   - Click to open Docker Desktop

2. **Go to Settings**
   - Click the gear icon (⚙️) in the top right
   - Or click "Settings" from the menu

3. **Enable Kubernetes**
   - Click on "Kubernetes" in the left sidebar
   - Check the box "Enable Kubernetes"
   - Click "Apply & Restart"
   - Wait for Kubernetes to start (this takes 1-2 minutes)

4. **Verify Kubernetes is Running**
   - You should see a green indicator next to "Kubernetes" in Docker Desktop
   - The status should show "Kubernetes is running"

### Step 3: Verify Kubernetes Cluster

```powershell
# Check cluster status
kubectl cluster-info

# Expected output:
# Kubernetes control plane is running at https://kubernetes.docker.internal:6443
# CoreDNS is running at https://kubernetes.docker.internal:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

### Step 4: Verify All Prerequisites

Run this command to verify everything is ready:

```powershell
# Check Docker
docker --version

# Check kubectl
kubectl version --client

# Check Helm
helm version

# Check Kubernetes
kubectl cluster-info
```

**Expected Output:**
```
✅ Docker: Docker version 28.5.1, build e180ab8
✅ kubectl: Client Version: version.Info{Major:"1", Minor:"28", ...}
✅ Helm: version.BuildInfo{Version:"v3.12.0", ...}
✅ Kubernetes: Kubernetes control plane is running at https://kubernetes.docker.internal:6443
```

## Quick Setup Script

Create and run this PowerShell script to check everything:

```powershell
# setup-check.ps1
Write-Host "=== Setup Check ===" -ForegroundColor Cyan

# Check Docker
Write-Host "`n1. Docker:" -ForegroundColor Yellow
try {
    $docker = docker --version
    Write-Host "   ✅ $docker" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker not found" -ForegroundColor Red
}

# Check kubectl
Write-Host "`n2. kubectl:" -ForegroundColor Yellow
try {
    $kubectl = kubectl version --client 2>&1 | Select-String "Client Version"
    Write-Host "   ✅ kubectl installed" -ForegroundColor Green
} catch {
    Write-Host "   ❌ kubectl not found" -ForegroundColor Red
}

# Check Helm
Write-Host "`n3. Helm:" -ForegroundColor Yellow
try {
    $helm = helm version --short
    Write-Host "   ✅ $helm" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Helm not found. Install with: choco install kubernetes-helm" -ForegroundColor Red
}

# Check Kubernetes
Write-Host "`n4. Kubernetes:" -ForegroundColor Yellow
try {
    $k8s = kubectl cluster-info 2>&1 | Select-String "is running"
    if ($k8s) {
        Write-Host "   ✅ Kubernetes is running" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Kubernetes not running. Enable in Docker Desktop" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Kubernetes not running. Enable in Docker Desktop" -ForegroundColor Red
}

Write-Host "`n=== Setup Check Complete ===" -ForegroundColor Cyan
```

## After Setup is Complete

Once all prerequisites are met, you can execute the project:

```powershell
# Run the execution script
.\EXECUTE_PROJECT.ps1
```

Or use the quick start:

```powershell
.\quick-start.ps1
```

## Troubleshooting Setup

### Helm Installation Issues

**Problem**: `helm: command not found`

**Solution**:
1. Install via Chocolatey: `choco install kubernetes-helm`
2. Or download from: https://helm.sh/docs/intro/install/
3. Add to PATH if manual installation

### Kubernetes Not Starting

**Problem**: Kubernetes shows "Starting..." for a long time

**Solution**:
1. Restart Docker Desktop
2. Check system resources (RAM, CPU)
3. Try disabling and re-enabling Kubernetes
4. Check Docker Desktop logs

### Kubernetes Connection Refused

**Problem**: `connection refused` when running `kubectl cluster-info`

**Solution**:
1. Make sure Kubernetes is enabled in Docker Desktop
2. Wait 1-2 minutes after enabling
3. Restart Docker Desktop
4. Check if port 6443 is available

### Docker Desktop Issues

**Problem**: Docker Desktop won't start

**Solution**:
1. Check if Hyper-V is enabled (Windows)
2. Check if WSL2 is installed and updated
3. Restart your computer
4. Reinstall Docker Desktop if necessary

## Next Steps

After setup is complete:

1. ✅ Verify all prerequisites
2. ✅ Run `.\EXECUTE_PROJECT.ps1`
3. ✅ Watch the deployment output
4. ✅ Access the application at http://localhost:3000

## Expected Setup Time

- **Helm Installation**: 2-5 minutes
- **Kubernetes Enable**: 1-2 minutes
- **Total Setup Time**: 5-10 minutes

---

**Ready to set up? Follow the steps above, then run `.\EXECUTE_PROJECT.ps1`!**


