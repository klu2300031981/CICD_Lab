# Execute Blood Banking System Project

This guide will help you execute the Blood Banking System project and see the output on your local machine.

## 🚀 Quick Start

### Option 1: Automated Execution (Windows PowerShell)

1. **Open PowerShell** in the project directory
2. **Run the execution script**:
   ```powershell
   .\EXECUTE_PROJECT.ps1
   ```
3. **Follow the prompts** to build and deploy

### Option 2: Manual Step-by-Step Execution

## Prerequisites

Before executing, ensure you have:

1. **Docker Desktop** installed and running
   - Download from: https://www.docker.com/products/docker-desktop
   - Enable Kubernetes in Docker Desktop (Settings > Kubernetes)

2. **kubectl** installed
   - Windows: Download from https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
   - Or use: `choco install kubernetes-cli`

3. **Helm** installed
   - Windows: Download from https://helm.sh/docs/intro/install/
   - Or use: `choco install kubernetes-helm`

## Step-by-Step Execution

### Step 1: Verify Prerequisites

```powershell
# Check Docker
docker --version

# Check kubectl
kubectl version --client

# Check Helm
helm version

# Check Kubernetes cluster
kubectl cluster-info
```

### Step 2: Build Docker Images

```powershell
# Build backend
cd backend
docker build -t bloodbank-backend:1.0.0 .
cd ..

# Build frontend
cd frontend
docker build -t bloodbank-frontend:1.0.0 --build-arg VITE_API_URL=/api .
cd ..
```

### Step 3: Load Images to Kubernetes (For Local Clusters)

If using **Docker Desktop Kubernetes** or **minikube**:

```powershell
# For Docker Desktop, images are already available
# For minikube:
minikube image load bloodbank-backend:1.0.0
minikube image load bloodbank-frontend:1.0.0

# For kind:
kind load docker-image bloodbank-backend:1.0.0
kind load docker-image bloodbank-frontend:1.0.0
```

### Step 4: Install Ingress Controller

```powershell
# Install NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Wait for ingress controller to be ready
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=300s
```

### Step 5: Deploy with Helm

```powershell
# Create namespace
kubectl create namespace bloodbank

# Deploy the application
helm install bloodbank .\helm\bloodbank `
    --namespace bloodbank `
    --set backend.image.repository=bloodbank-backend `
    --set backend.image.tag=1.0.0 `
    --set frontend.image.repository=bloodbank-frontend `
    --set frontend.image.tag=1.0.0 `
    --set backend.env.spring.datasource.password=changeme `
    --set backend.env.spring.mail.username=your-email@gmail.com `
    --set backend.env.spring.mail.password=your-password `
    --set ingress.enabled=true `
    --set ingress.hosts[0].host=bloodbank.local
```

### Step 6: Verify Deployment

```powershell
# Check pods
kubectl get pods -n bloodbank

# Check services
kubectl get svc -n bloodbank

# Check ingress
kubectl get ingress -n bloodbank

# Check HPA
kubectl get hpa -n bloodbank
```

### Step 7: Access the Application

#### Option A: Port Forward (Recommended for Local Testing)

```powershell
# Terminal 1: Forward frontend
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80

# Terminal 2: Forward backend
kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080
```

Then access:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080

#### Option B: Ingress (If configured)

```powershell
# Get ingress IP
kubectl get ingress -n bloodbank

# Add to hosts file (C:\Windows\System32\drivers\etc\hosts)
# <ingress-ip> bloodbank.local

# Access at: http://bloodbank.local
```

## View Output and Logs

### View Pod Status

```powershell
# Get all pods
kubectl get pods -n bloodbank

# Get detailed pod information
kubectl describe pod <pod-name> -n bloodbank
```

### View Logs

```powershell
# Backend logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank

# Frontend logs
kubectl logs -f deployment/bloodbank-frontend -n bloodbank

# MySQL logs
kubectl logs -f deployment/bloodbank-mysql -n bloodbank

# All pods logs
kubectl logs -f -l app.kubernetes.io/instance=bloodbank -n bloodbank
```

### View Services

```powershell
# Get all services
kubectl get svc -n bloodbank

# Get service details
kubectl describe svc bloodbank-frontend -n bloodbank
kubectl describe svc bloodbank-backend -n bloodbank
```

### View Ingress

```powershell
# Get ingress
kubectl get ingress -n bloodbank

# Get ingress details
kubectl describe ingress bloodbank-ingress -n bloodbank
```

### View HPA Status

```powershell
# Get HPA
kubectl get hpa -n bloodbank

# Get HPA details
kubectl describe hpa bloodbank-backend-hpa -n bloodbank
kubectl describe hpa bloodbank-frontend-hpa -n bloodbank
```

### Test Health Endpoints

```powershell
# Test backend health
kubectl exec -it deployment/bloodbank-backend -n bloodbank -- curl http://localhost:8080/actuator/health

# Test frontend
kubectl exec -it deployment/bloodbank-frontend -n bloodbank -- curl http://localhost:80
```

## Expected Output

### Pods Should Be Running

```
NAME                                  READY   STATUS    RESTARTS   AGE
bloodbank-backend-xxxxxxxxxx-xxxxx    1/1     Running   0          2m
bloodbank-frontend-xxxxxxxxxx-xxxxx   1/1     Running   0          2m
bloodbank-mysql-xxxxxxxxxx-xxxxx      1/1     Running   0          2m
```

### Services Should Be Available

```
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
bloodbank-backend     ClusterIP   10.xx.xx.xx     <none>        8080/TCP   2m
bloodbank-frontend    ClusterIP   10.xx.xx.xx     <none>        80/TCP     2m
bloodbank-mysql       ClusterIP   10.xx.xx.xx     <none>        3306/TCP   2m
```

### Ingress Should Be Configured

```
NAME                CLASS   HOSTS              ADDRESS        PORTS     AGE
bloodbank-ingress   nginx   bloodbank.local    <pending>      80        2m
```

### HPA Should Be Active

```
NAME                        REFERENCE                      TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
bloodbank-backend-hpa       Deployment/bloodbank-backend   0%/70%, 0%/80%  2         10        2          2m
bloodbank-frontend-hpa      Deployment/bloodbank-frontend  0%/70%          2         10        2          2m
```

## Troubleshooting

### Pods Not Starting

```powershell
# Check pod status
kubectl get pods -n bloodbank

# Describe pod for details
kubectl describe pod <pod-name> -n bloodbank

# Check logs
kubectl logs <pod-name> -n bloodbank
```

### Images Not Found

```powershell
# Verify images are built
docker images | findstr bloodbank

# Load images to minikube
minikube image load bloodbank-backend:1.0.0
minikube image load bloodbank-frontend:1.0.0
```

### Database Connection Issues

```powershell
# Check MySQL pod
kubectl get pods -n bloodbank | findstr mysql

# Check MySQL logs
kubectl logs deployment/bloodbank-mysql -n bloodbank

# Test database connection
kubectl exec -it deployment/bloodbank-mysql -n bloodbank -- mysql -u root -p
```

### Ingress Not Working

```powershell
# Check ingress controller
kubectl get pods -n ingress-nginx

# Check ingress configuration
kubectl describe ingress bloodbank-ingress -n bloodbank

# Use port-forward instead
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80
```

## Cleanup

### Remove Deployment

```powershell
# Uninstall Helm release
helm uninstall bloodbank -n bloodbank

# Delete namespace
kubectl delete namespace bloodbank

# Remove images (optional)
docker rmi bloodbank-backend:1.0.0
docker rmi bloodbank-frontend:1.0.0
```

## Next Steps

1. **Access the application** using port-forward or ingress
2. **Test the functionality**:
   - Create user accounts
   - Add donors
   - View inventory
   - Create requests
3. **Monitor the deployment**:
   - Watch pod logs
   - Check HPA scaling
   - Monitor resource usage
4. **Scale the application**:
   ```powershell
   kubectl scale deployment bloodbank-backend --replicas=5 -n bloodbank
   ```

## Support

For issues:
1. Check the troubleshooting section
2. Review pod logs
3. Check Kubernetes events: `kubectl get events -n bloodbank --sort-by='.lastTimestamp'`
4. Review the deployment documentation

---

**Happy Deploying! 🚀**


