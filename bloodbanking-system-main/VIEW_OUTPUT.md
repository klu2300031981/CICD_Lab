# How to See Your Output

## Quick Answer

**Run this command to see expected output:**
```powershell
.\SHOW_OUTPUT.ps1
```

## Ways to See Output

### 1. See Expected Output (Works Now)

Run the script to see what the output will look like:
```powershell
.\SHOW_OUTPUT.ps1
```

This shows:
- ✅ Current system status
- ✅ Expected deployment output
- ✅ How to see real output
- ✅ Commands to view output

### 2. See Real Output (After Setup)

#### Step 1: Complete Setup
1. Install Helm: `choco install kubernetes-helm`
2. Enable Kubernetes in Docker Desktop
3. Wait for Kubernetes to start

#### Step 2: Deploy
```powershell
.\EXECUTE_PROJECT.ps1
```

#### Step 3: View Output

**View all resources:**
```powershell
kubectl get all -n bloodbank
```

**View pods:**
```powershell
kubectl get pods -n bloodbank
```

**View services:**
```powershell
kubectl get svc -n bloodbank
```

**View HPA:**
```powershell
kubectl get hpa -n bloodbank
```

**View logs:**
```powershell
# Backend logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank

# Frontend logs
kubectl logs -f deployment/bloodbank-frontend -n bloodbank

# MySQL logs
kubectl logs -f deployment/bloodbank-mysql -n bloodbank
```

**Watch in real-time:**
```powershell
# Watch pods
kubectl get pods -n bloodbank -w

# Watch all resources
kubectl get all -n bloodbank -w
```

### 3. View Detailed Information

**Describe a pod:**
```powershell
kubectl describe pod <pod-name> -n bloodbank
```

**View events:**
```powershell
kubectl get events -n bloodbank --sort-by='.lastTimestamp'
```

**View pod logs with timestamps:**
```powershell
kubectl logs -f deployment/bloodbank-backend -n bloodbank --timestamps
```

### 4. Access Application Output

**Set up port-forward:**
```powershell
# Terminal 1: Frontend
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80

# Terminal 2: Backend
kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080
```

**IMPORTANT: Port-forward must be running for these links to work!**

**Then access in browser:**
- Frontend: http://localhost:3000 (ONLY works when port-forward is running)
- Backend: http://localhost:8080 (ONLY works when port-forward is running)
- Health: http://localhost:8080/actuator/health (ONLY works when port-forward is running)

**Troubleshooting:**
- If links don't work, check that port-forward commands are running
- Make sure deployment is complete: `kubectl get pods -n bloodbank`
- Verify services exist: `kubectl get svc -n bloodbank`

### 5. View Deployment Status

**Check deployment status:**
```powershell
kubectl get deployment -n bloodbank
kubectl describe deployment bloodbank-backend -n bloodbank
kubectl describe deployment bloodbank-frontend -n bloodbank
```

**Check Helm release:**
```powershell
helm list -n bloodbank
helm status bloodbank -n bloodbank
```

## What Output You'll See

### After Successful Deployment

```
✅ 5 Pods Running:
   - 2x bloodbank-backend
   - 2x bloodbank-frontend
   - 1x bloodbank-mysql

✅ 3 Services:
   - Backend (8080)
   - Frontend (80)
   - MySQL (3306)

✅ 2 HPA Active:
   - Backend HPA (2-10 replicas)
   - Frontend HPA (2-10 replicas)

✅ Application Accessible:
   - Frontend: http://localhost:3000
   - Backend: http://localhost:8080
```

## Quick Commands Reference

```powershell
# See everything
kubectl get all -n bloodbank

# See pods
kubectl get pods -n bloodbank

# See services
kubectl get svc -n bloodbank

# See HPA
kubectl get hpa -n bloodbank

# See logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank

# Watch changes
kubectl get pods -n bloodbank -w

# Describe resources
kubectl describe pod <pod-name> -n bloodbank
```

## Troubleshooting

### No Output Showing?

1. **Check if deployment exists:**
   ```powershell
   kubectl get pods -n bloodbank
   ```

2. **Check if namespace exists:**
   ```powershell
   kubectl get namespace bloodbank
   ```

3. **Check Helm release:**
   ```powershell
   helm list -n bloodbank
   ```

4. **Check events:**
   ```powershell
   kubectl get events -n bloodbank
   ```

### Can't See Logs?

1. **Check pod is running:**
   ```powershell
   kubectl get pods -n bloodbank
   ```

2. **Check pod name:**
   ```powershell
   kubectl get pods -n bloodbank
   # Use the actual pod name from output
   ```

3. **View previous logs:**
   ```powershell
   kubectl logs <pod-name> -n bloodbank --previous
   ```

## Files to Check

- **SHOW_OUTPUT.ps1** - Run this to see expected output
- **EXPECTED_OUTPUT.md** - Detailed output examples
- **SETUP_GUIDE.md** - Setup instructions
- **EXECUTE_PROJECT.md** - Execution guide

## Next Steps

1. **Run `.\SHOW_OUTPUT.ps1`** to see expected output now
2. **Complete setup** (install Helm, enable Kubernetes)
3. **Run `.\EXECUTE_PROJECT.ps1`** to deploy
4. **Use the commands above** to view real output

---

**Quick Start: Run `.\SHOW_OUTPUT.ps1` now to see what output will look like!**

