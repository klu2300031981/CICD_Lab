# How to Access the Application - Step by Step

## ⚠️ IMPORTANT: Links Only Work After Setup!

The frontend and backend links (http://localhost:3000 and http://localhost:8080) **will NOT work** until you complete the steps below.

## Prerequisites

Before accessing the application, you need:

1. ✅ **Kubernetes cluster running**
2. ✅ **Application deployed** (using `.\EXECUTE_PROJECT.ps1`)
3. ✅ **Services running** (check with `kubectl get svc -n bloodbank`)

## Step-by-Step: Access the Application

### Step 1: Verify Deployment

First, make sure the application is deployed and running:

```powershell
# Check if pods are running
kubectl get pods -n bloodbank

# Expected output:
# NAME                                  READY   STATUS    RESTARTS   AGE
# bloodbank-backend-xxxxx-xxxxx         1/1     Running   0          2m
# bloodbank-frontend-xxxxx-xxxxx        1/1     Running   0          2m
# bloodbank-mysql-xxxxx-xxxxx           1/1     Running   0          2m

# Check if services exist
kubectl get svc -n bloodbank

# Expected output:
# NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
# bloodbank-backend     ClusterIP   10.xx.xx.xx     <none>        8080/TCP   2m
# bloodbank-frontend    ClusterIP   10.xx.xx.xx     <none>        80/TCP     2m
```

**If pods are not running, deploy first:**
```powershell
.\EXECUTE_PROJECT.ps1
```

### Step 2: Set Up Port-Forward (REQUIRED!)

The application runs inside Kubernetes. To access it from your browser, you need to set up port-forwarding.

#### Option A: Manual Port-Forward (Recommended for Testing)

**Open TWO separate PowerShell terminals:**

**Terminal 1 - Frontend:**
```powershell
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80
```

**Terminal 2 - Backend:**
```powershell
kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080
```

**Keep both terminals running!** The port-forward must stay active for the links to work.

#### Option B: Background Port-Forward

If you want to run port-forward in the background:

```powershell
# Start frontend port-forward in background
Start-Process powershell -ArgumentList "-NoExit", "-Command", "kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80"

# Start backend port-forward in background
Start-Process powershell -ArgumentList "-NoExit", "-Command", "kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080"
```

### Step 3: Verify Port-Forward is Working

Check that port-forward is active:

```powershell
# Check if ports are listening
netstat -an | findstr "3000 8080"

# You should see:
# TCP    127.0.0.1:3000         0.0.0.0:0              LISTENING
# TCP    127.0.0.1:8080         0.0.0.0:0              LISTENING
```

### Step 4: Access the Application

**Now you can access the application in your browser:**

- **Frontend**: http://localhost:3000
  - This is the main web interface
  - You should see the Blood Banking System homepage
  - Sign in/Sign up interface

- **Backend API**: http://localhost:8080
  - This is the REST API
  - Health check: http://localhost:8080/actuator/health
  - API endpoints: http://localhost:8080/api/...

- **Health Check**: http://localhost:8080/actuator/health
  - Should return: `{"status":"UP"}`

## Troubleshooting

### Problem: Links Don't Work / Connection Refused

**Solution 1: Check if port-forward is running**
```powershell
# Check if port-forward processes are running
Get-Process | Where-Object {$_.ProcessName -like "*kubectl*"}

# If not running, start them again (see Step 2)
```

**Solution 2: Check if deployment exists**
```powershell
# Check pods
kubectl get pods -n bloodbank

# If no pods, deploy first
.\EXECUTE_PROJECT.ps1
```

**Solution 3: Check if services exist**
```powershell
# Check services
kubectl get svc -n bloodbank

# If services don't exist, deployment failed
# Check deployment status
kubectl get deployment -n bloodbank
```

**Solution 4: Check if ports are already in use**
```powershell
# Check if ports 3000 or 8080 are in use
netstat -an | findstr "3000 8080"

# If ports are in use by another process, either:
# - Stop that process, or
# - Use different ports in port-forward:
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3001:80
kubectl port-forward -n bloodbank svc/bloodbank-backend 8081:8080
```

### Problem: Port-Forward Keeps Disconnecting

**Solution:**
- Make sure your Kubernetes cluster is stable
- Check cluster status: `kubectl cluster-info`
- Restart port-forward if it disconnects

### Problem: Can't Connect to Backend from Frontend

**Solution:**
- Make sure both port-forwards are running
- Check backend health: http://localhost:8080/actuator/health
- Check backend logs: `kubectl logs -f deployment/bloodbank-backend -n bloodbank`

### Problem: 404 Error or Page Not Found

**Solution:**
- Verify pods are running: `kubectl get pods -n bloodbank`
- Check pod logs: `kubectl logs <pod-name> -n bloodbank`
- Verify services: `kubectl get svc -n bloodbank`
- Restart port-forward

## Alternative: Using Ingress (Advanced)

If you have an ingress controller configured, you can access the application via ingress:

```powershell
# Get ingress IP
kubectl get ingress -n bloodbank

# Add to hosts file (C:\Windows\System32\drivers\etc\hosts)
# <ingress-ip> bloodbank.local

# Access at: http://bloodbank.local
```

## Quick Reference

```powershell
# 1. Deploy
.\EXECUTE_PROJECT.ps1

# 2. Check status
kubectl get pods -n bloodbank
kubectl get svc -n bloodbank

# 3. Set up port-forward (2 terminals)
# Terminal 1:
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80

# Terminal 2:
kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080

# 4. Access
# Frontend: http://localhost:3000
# Backend: http://localhost:8080
```

## Summary

✅ **Links will work ONLY when:**
1. Deployment is complete
2. Port-forward commands are running (in separate terminals)
3. Services are ready and pods are running

❌ **Links will NOT work if:**
- Deployment is not complete
- Port-forward is not running
- Services are not ready
- Pods are not running

---

**Remember: Keep the port-forward terminals open while using the application!**


