# 🚀 Get Started - Execute the Project

## Quick Execution Guide

### Step 1: Prerequisites Check

Make sure you have:
- ✅ Docker Desktop installed and running
- ✅ Kubernetes enabled in Docker Desktop (Settings > Kubernetes)
- ✅ kubectl installed
- ✅ Helm installed

### Step 2: Choose Your Execution Method

#### Method 1: Automated Script (Easiest)

**Run the PowerShell script:**

```powershell
.\EXECUTE_PROJECT.ps1
```

This script will:
- ✅ Check all prerequisites
- ✅ Build Docker images
- ✅ Deploy to Kubernetes
- ✅ Show you how to access the application

#### Method 2: Quick Start Script

**For a faster deployment with defaults:**

```powershell
.\quick-start.ps1
```

#### Method 3: Manual Execution

Follow the detailed steps in `EXECUTE_PROJECT.md`

### Step 3: Access the Application

After deployment, you'll see output like:

```
✅ Deployment Complete!

Access the application at:
  Frontend: http://localhost:3000
  Backend:  http://localhost:8080

Run these commands in separate terminals:
  kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80
  kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080
```

### Step 4: View Output

#### Check Pod Status
```powershell
kubectl get pods -n bloodbank
```

Expected output:
```
NAME                                  READY   STATUS    RESTARTS   AGE
bloodbank-backend-xxxxx-xxxxx         1/1     Running   0          2m
bloodbank-frontend-xxxxx-xxxxx        1/1     Running   0          2m
bloodbank-mysql-xxxxx-xxxxx           1/1     Running   0          2m
```

#### View Logs
```powershell
# Backend logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank

# Frontend logs
kubectl logs -f deployment/bloodbank-frontend -n bloodbank

# All pods
kubectl get pods -n bloodbank -w
```

#### Check Services
```powershell
kubectl get svc -n bloodbank
```

Expected output:
```
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
bloodbank-backend     ClusterIP   10.xx.xx.xx     <none>        8080/TCP   2m
bloodbank-frontend    ClusterIP   10.xx.xx.xx     <none>        80/TCP     2m
bloodbank-mysql       ClusterIP   10.xx.xx.xx     <none>        3306/TCP   2m
```

#### Check HPA (Auto-scaling)
```powershell
kubectl get hpa -n bloodbank
```

Expected output:
```
NAME                        REFERENCE                      TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
bloodbank-backend-hpa       Deployment/bloodbank-backend   0%/70%, 0%/80%  2         10        2          2m
bloodbank-frontend-hpa      Deployment/bloodbank-frontend  0%/70%          2         10        2          2m
```

### Step 5: Test the Application

1. **Open browser** and go to `http://localhost:3000` (after port-forward)
2. **Test features**:
   - Sign up / Sign in
   - Add donors
   - View inventory
   - Create requests

### Common Commands

#### View Everything
```powershell
# All resources
kubectl get all -n bloodbank

# Detailed view
kubectl get pods,svc,ingress,hpa -n bloodbank
```

#### Debug Issues
```powershell
# Describe pod
kubectl describe pod <pod-name> -n bloodbank

# Check events
kubectl get events -n bloodbank --sort-by='.lastTimestamp'

# Exec into pod
kubectl exec -it <pod-name> -n bloodbank -- sh
```

#### Scale Application
```powershell
# Scale backend
kubectl scale deployment bloodbank-backend --replicas=5 -n bloodbank

# Scale frontend
kubectl scale deployment bloodbank-frontend --replicas=5 -n bloodbank
```

#### Cleanup
```powershell
# Remove deployment
helm uninstall bloodbank -n bloodbank

# Delete namespace
kubectl delete namespace bloodbank
```

## Troubleshooting

### Issue: Docker not running
**Solution**: Start Docker Desktop

### Issue: Kubernetes not available
**Solution**: Enable Kubernetes in Docker Desktop (Settings > Kubernetes > Enable)

### Issue: Images not found
**Solution**: Rebuild images:
```powershell
docker build -t bloodbank-backend:1.0.0 ./backend
docker build -t bloodbank-frontend:1.0.0 ./frontend
```

### Issue: Pods not starting
**Solution**: Check logs:
```powershell
kubectl logs <pod-name> -n bloodbank
kubectl describe pod <pod-name> -n bloodbank
```

### Issue: Port-forward not working
**Solution**: Check if services are running:
```powershell
kubectl get svc -n bloodbank
```

## Expected Output Summary

When everything is working, you should see:

✅ **3 Pods Running**:
- bloodbank-backend (1/1 Ready)
- bloodbank-frontend (1/1 Ready)
- bloodbank-mysql (1/1 Ready)

✅ **3 Services**:
- bloodbank-backend (ClusterIP:8080)
- bloodbank-frontend (ClusterIP:80)
- bloodbank-mysql (ClusterIP:3306)

✅ **2 HPA Active**:
- bloodbank-backend-hpa (2-10 replicas)
- bloodbank-frontend-hpa (2-10 replicas)

✅ **Application Accessible**:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080

## Next Steps

1. ✅ **Access the application** via port-forward
2. ✅ **Test all features** (sign up, donors, inventory, requests)
3. ✅ **Monitor logs** to see application activity
4. ✅ **Scale the application** to test auto-scaling
5. ✅ **Check HPA** to see scaling in action

## Need Help?

- 📖 Read `EXECUTE_PROJECT.md` for detailed instructions
- 📖 Read `KUBERNETES_DEPLOYMENT.md` for deployment details
- 📖 Read `README.md` for general information

---

**Ready to execute? Run:** `.\EXECUTE_PROJECT.ps1`


