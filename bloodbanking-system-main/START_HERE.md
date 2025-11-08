# 🚀 START HERE - Execute the Project

## Quick Execution (3 Steps)

### Step 1: Open PowerShell

Open PowerShell in the project directory:
```powershell
cd "C:\Users\seela\Downloads\bloodbanking-system-main\bloodbanking-system-main"
```

### Step 2: Run Execution Script

Choose one method:

**Method A: Full Automated Script**
```powershell
.\EXECUTE_PROJECT.ps1
```

**Method B: Quick Start (Faster)**
```powershell
.\quick-start.ps1
```

### Step 3: Access the Application

After deployment, run these commands in separate PowerShell windows:

```powershell
# Terminal 1: Frontend
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80

# Terminal 2: Backend
kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080
```

Then open your browser:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080

## View Output

### Check Deployment Status
```powershell
# View all resources
kubectl get all -n bloodbank

# View pods
kubectl get pods -n bloodbank

# View services
kubectl get svc -n bloodbank

# View HPA (auto-scaling)
kubectl get hpa -n bloodbank
```

### View Logs
```powershell
# Backend logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank

# Frontend logs
kubectl logs -f deployment/bloodbank-frontend -n bloodbank

# MySQL logs
kubectl logs -f deployment/bloodbank-mysql -n bloodbank
```

## Expected Output

When everything is working, you should see:

```
✅ 3 Pods Running:
   - bloodbank-backend (1/1 Ready)
   - bloodbank-frontend (1/1 Ready)
   - bloodbank-mysql (1/1 Ready)

✅ 3 Services:
   - bloodbank-backend (ClusterIP:8080)
   - bloodbank-frontend (ClusterIP:80)
   - bloodbank-mysql (ClusterIP:3306)

✅ 2 HPA Active:
   - bloodbank-backend-hpa (2-10 replicas)
   - bloodbank-frontend-hpa (2-10 replicas)

✅ Application Accessible:
   - Frontend: http://localhost:3000
   - Backend: http://localhost:8080
```

## Prerequisites

Before running, make sure you have:

1. ✅ **Docker Desktop** installed and running
2. ✅ **Kubernetes enabled** in Docker Desktop (Settings > Kubernetes)
3. ✅ **kubectl** installed
4. ✅ **Helm** installed

## Troubleshooting

### Docker not running?
→ Start Docker Desktop

### Kubernetes not available?
→ Enable Kubernetes in Docker Desktop: Settings > Kubernetes > Enable Kubernetes

### Pods not starting?
```powershell
kubectl describe pod <pod-name> -n bloodbank
kubectl logs <pod-name> -n bloodbank
```

### Images not found?
```powershell
docker build -t bloodbank-backend:1.0.0 ./backend
docker build -t bloodbank-frontend:1.0.0 ./frontend
```

## Cleanup

To remove the deployment:
```powershell
helm uninstall bloodbank -n bloodbank
kubectl delete namespace bloodbank
```

## Documentation

- **EXECUTE_PROJECT.md** - Detailed execution guide
- **GET_STARTED.md** - Quick start guide
- **KUBERNETES_DEPLOYMENT.md** - Full deployment documentation
- **README.md** - Project overview

---

## Ready? Execute Now!

```powershell
.\EXECUTE_PROJECT.ps1
```

Or for quick start:

```powershell
.\quick-start.ps1
```


