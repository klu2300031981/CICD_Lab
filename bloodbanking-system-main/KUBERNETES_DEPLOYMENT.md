# Blood Banking System - Kubernetes Deployment Guide

This guide provides comprehensive instructions for deploying the Blood Banking System on Kubernetes using Helm and Ingress, ensuring scalability, automation, and high availability.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Architecture Overview](#architecture-overview)
3. [Quick Start](#quick-start)
4. [Detailed Deployment Steps](#detailed-deployment-steps)
5. [Configuration](#configuration)
6. [Scaling and High Availability](#scaling-and-high-availability)
7. [Monitoring and Maintenance](#monitoring-and-maintenance)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools
- Kubernetes cluster (v1.24+)
- kubectl (v1.24+)
- Helm (v3.12+)
- Docker (for building images)
- Container Registry (Docker Hub, GitHub Container Registry, etc.)

### Kubernetes Cluster Setup
- Minimum 3 nodes (for high availability)
- At least 4 CPU cores and 8GB RAM per node
- Ingress controller installed (NGINX, Traefik, etc.)
- Storage class configured for persistent volumes

### Install Prerequisites

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installations
kubectl version --client
helm version
```

## Architecture Overview

The deployment consists of:

1. **Frontend Service**: React application served via Nginx
2. **Backend Service**: Spring Boot REST API
3. **MySQL Database**: Persistent database for application data
4. **Ingress**: External access routing
5. **HPA**: Horizontal Pod Autoscaler for automatic scaling
6. **Secrets**: Secure storage for sensitive data

### High Availability Features

- **Multi-replica deployments**: Default 2 replicas for frontend and backend
- **Horizontal Pod Autoscaler**: Automatic scaling based on CPU/memory
- **Persistent volumes**: Database data persistence
- **Health checks**: Liveness and readiness probes
- **Resource limits**: CPU and memory constraints

## Quick Start

### 1. Build Docker Images

```bash
# Build backend image
cd backend
docker build -t bloodbank-backend:1.0.0 .
cd ..

# Build frontend image
cd frontend
docker build -t bloodbank-frontend:1.0.0 --build-arg VITE_API_URL=http://backend-service:8080 .
cd ..
```

### 2. Push Images to Registry

```bash
# Tag images
docker tag bloodbank-backend:1.0.0 your-registry/bloodbank-backend:1.0.0
docker tag bloodbank-frontend:1.0.0 your-registry/bloodbank-frontend:1.0.0

# Push images
docker push your-registry/bloodbank-backend:1.0.0
docker push your-registry/bloodbank-frontend:1.0.0
```

### 3. Deploy with Helm

```bash
# Create namespace
kubectl create namespace bloodbank

# Install Ingress Controller (if not already installed)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Update values.yaml with your image registry and configuration
# Then deploy
helm install bloodbank ./helm/bloodbank \
  --namespace bloodbank \
  --set backend.image.repository=your-registry/bloodbank-backend \
  --set backend.image.tag=1.0.0 \
  --set frontend.image.repository=your-registry/bloodbank-frontend \
  --set frontend.image.tag=1.0.0 \
  --set backend.env.spring.datasource.password=your-secure-password \
  --set backend.env.spring.mail.username=your-email@gmail.com \
  --set backend.env.spring.mail.password=your-app-password \
  --set ingress.hosts[0].host=bloodbank.yourdomain.com
```

### 4. Verify Deployment

```bash
# Check pods
kubectl get pods -n bloodbank

# Check services
kubectl get svc -n bloodbank

# Check ingress
kubectl get ingress -n bloodbank

# View logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank
kubectl logs -f deployment/bloodbank-frontend -n bloodbank
```

## Detailed Deployment Steps

### Step 1: Prepare Configuration

1. **Update `helm/bloodbank/values.yaml`**:
   - Set image repositories and tags
   - Configure database credentials
   - Set email configuration
   - Configure ingress hostname
   - Adjust resource limits as needed

2. **Create Secrets** (if not using Helm secrets):
   ```bash
   kubectl create secret generic bloodbank-secrets \
     --from-literal=db-username=root \
     --from-literal=db-password=your-secure-password \
     --from-literal=mail-username=your-email@gmail.com \
     --from-literal=mail-password=your-app-password \
     -n bloodbank
   ```

### Step 2: Deploy MySQL Database

MySQL is deployed automatically with the Helm chart. To customize:

```yaml
mysql:
  enabled: true
  persistence:
    enabled: true
    size: 20Gi
    storageClass: "standard"
  resources:
    requests:
      cpu: 1000m
      memory: 1Gi
```

### Step 3: Deploy Backend Service

The backend service is configured with:
- Health checks on `/actuator/health`
- Environment variables for database connection
- Resource limits for CPU and memory
- Automatic scaling with HPA

### Step 4: Deploy Frontend Service

The frontend service:
- Serves static files via Nginx
- Configured with API URL via environment variable
- Health checks on root path
- Automatic scaling with HPA

### Step 5: Configure Ingress

Update ingress configuration in `values.yaml`:

```yaml
ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: bloodbank.yourdomain.com
  tls:
    - secretName: bloodbank-tls
      hosts:
        - bloodbank.yourdomain.com
```

For TLS certificates with cert-manager:

```bash
# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# Create ClusterIssuer
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

## Configuration

### Environment Variables

#### Backend
- `SPRING_DATASOURCE_URL`: Database connection URL
- `SPRING_DATASOURCE_USERNAME`: Database username
- `SPRING_DATASOURCE_PASSWORD`: Database password
- `SPRING_MAIL_HOST`: SMTP host
- `SPRING_MAIL_PORT`: SMTP port
- `SPRING_MAIL_USERNAME`: Email username
- `SPRING_MAIL_PASSWORD`: Email password

#### Frontend
- `VITE_API_URL`: Backend API URL

### Resource Limits

Adjust in `values.yaml`:

```yaml
backend:
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 2000m
      memory: 2Gi

frontend:
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 500m
      memory: 512Mi
```

## Scaling and High Availability

### Horizontal Pod Autoscaler

HPA is configured for both frontend and backend:

```yaml
backend:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 70
    targetMemoryUtilizationPercentage: 80
```

### Manual Scaling

```bash
# Scale backend
kubectl scale deployment bloodbank-backend --replicas=5 -n bloodbank

# Scale frontend
kubectl scale deployment bloodbank-frontend --replicas=5 -n bloodbank
```

### High Availability Configuration

1. **Multi-zone deployment**: Deploy nodes across multiple availability zones
2. **Pod Disruption Budget**: Create PDB for zero-downtime deployments
3. **Resource quotas**: Set namespace quotas to prevent resource exhaustion

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: bloodbank-backend-pdb
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app.kubernetes.io/component: backend
```

## Monitoring and Maintenance

### Viewing Logs

```bash
# Backend logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank

# Frontend logs
kubectl logs -f deployment/bloodbank-frontend -n bloodbank

# MySQL logs
kubectl logs -f deployment/bloodbank-mysql -n bloodbank
```

### Health Checks

```bash
# Check pod status
kubectl get pods -n bloodbank

# Check service endpoints
kubectl get endpoints -n bloodbank

# Test backend health
kubectl exec -it deployment/bloodbank-backend -n bloodbank -- curl http://localhost:8080/actuator/health
```

### Database Backup

```bash
# Create backup
kubectl exec -it deployment/bloodbank-mysql -n bloodbank -- \
  mysqldump -u root -p blood > backup.sql

# Restore backup
kubectl exec -i deployment/bloodbank-mysql -n bloodbank -- \
  mysql -u root -p blood < backup.sql
```

### Updating Application

```bash
# Update image
helm upgrade bloodbank ./helm/bloodbank \
  --namespace bloodbank \
  --set backend.image.tag=1.1.0 \
  --set frontend.image.tag=1.1.0

# Rollback if needed
helm rollback bloodbank -n bloodbank
```

## Troubleshooting

### Common Issues

1. **Pods not starting**:
   ```bash
   kubectl describe pod <pod-name> -n bloodbank
   kubectl logs <pod-name> -n bloodbank
   ```

2. **Database connection errors**:
   - Check MySQL service is running
   - Verify credentials in secrets
   - Check network policies

3. **Ingress not working**:
   - Verify Ingress Controller is installed
   - Check ingress configuration
   - Verify DNS settings

4. **HPA not scaling**:
   - Check metrics-server is installed
   - Verify resource requests are set
   - Check HPA status: `kubectl get hpa -n bloodbank`

### Debug Commands

```bash
# Get all resources
kubectl get all -n bloodbank

# Describe resources
kubectl describe deployment bloodbank-backend -n bloodbank
kubectl describe service bloodbank-backend -n bloodbank
kubectl describe ingress bloodbank-ingress -n bloodbank

# Check events
kubectl get events -n bloodbank --sort-by='.lastTimestamp'

# Port forward for testing
kubectl port-forward service/bloodbank-backend 8080:8080 -n bloodbank
kubectl port-forward service/bloodbank-frontend 80:80 -n bloodbank
```

## CI/CD Integration

The included GitHub Actions workflow automates:
- Building Docker images
- Pushing to container registry
- Deploying to Kubernetes

Configure secrets in GitHub:
- `KUBECONFIG`: Base64 encoded kubeconfig file
- `DB_PASSWORD`: Database password
- `MAIL_USERNAME`: Email username
- `MAIL_PASSWORD`: Email password
- `VITE_API_URL`: Frontend API URL (optional)

## Security Best Practices

1. **Use Secrets**: Store sensitive data in Kubernetes secrets
2. **Network Policies**: Restrict pod-to-pod communication
3. **RBAC**: Implement role-based access control
4. **TLS**: Enable TLS for ingress
5. **Image Security**: Scan images for vulnerabilities
6. **Resource Limits**: Set appropriate resource limits

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review Kubernetes and Helm logs
3. Consult the application logs
4. Open an issue in the repository

---

**Note**: Remember to update all placeholder values (passwords, domains, email addresses) before deploying to production.


