# Blood Banking System - Kubernetes Deployment

A full-stack Blood Banking System deployed on Kubernetes using Helm and Ingress, ensuring scalability, automation, and high availability through containerization and orchestration.

## 🏗️ Architecture

The system consists of:

- **Frontend**: React application served via Nginx
- **Backend**: Spring Boot REST API (Java 21)
- **Database**: MySQL 8.0 with persistent storage
- **Ingress**: NGINX Ingress Controller for external access
- **Autoscaling**: Horizontal Pod Autoscaler (HPA) for automatic scaling
- **CI/CD**: GitHub Actions for automated deployment

## ✨ Features

- ✅ **Containerized**: Docker images for frontend and backend
- ✅ **Orchestrated**: Kubernetes deployments with Helm charts
- ✅ **Scalable**: Horizontal Pod Autoscaler (HPA) for automatic scaling
- ✅ **High Availability**: Multi-replica deployments with health checks
- ✅ **Automated**: CI/CD pipeline with GitHub Actions
- ✅ **Secure**: Secrets management, TLS support, and security headers
- ✅ **Monitored**: Health checks, liveness, and readiness probes
- ✅ **Persistent Storage**: MySQL data persistence with PVCs

## 📋 Prerequisites

### Required Tools
- Kubernetes cluster (v1.24+)
- kubectl (v1.24+)
- Helm (v3.12+)
- Docker (for building images)
- Container Registry (Docker Hub, GHCR, etc.)

### Kubernetes Requirements
- Minimum 3 nodes (for high availability)
- At least 4 CPU cores and 8GB RAM per node
- Ingress controller installed (NGINX recommended)
- Storage class configured for persistent volumes

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd bloodbanking-system-main
```

### 2. Build Docker Images

```bash
# Build backend
cd backend
docker build -t bloodbank-backend:1.0.0 .
cd ..

# Build frontend
cd frontend
docker build -t bloodbank-frontend:1.0.0 --build-arg VITE_API_URL=/api .
cd ..
```

### 3. Push Images to Registry

```bash
# Tag and push backend
docker tag bloodbank-backend:1.0.0 your-registry/bloodbank-backend:1.0.0
docker push your-registry/bloodbank-backend:1.0.0

# Tag and push frontend
docker tag bloodbank-frontend:1.0.0 your-registry/bloodbank-frontend:1.0.0
docker push your-registry/bloodbank-frontend:1.0.0
```

### 4. Deploy with Helm

```bash
# Install Ingress Controller (if not already installed)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Deploy the application
helm install bloodbank ./helm/bloodbank \
  --namespace bloodbank \
  --create-namespace \
  --set backend.image.repository=your-registry/bloodbank-backend \
  --set backend.image.tag=1.0.0 \
  --set frontend.image.repository=your-registry/bloodbank-frontend \
  --set frontend.image.tag=1.0.0 \
  --set backend.env.spring.datasource.password=your-secure-password \
  --set backend.env.spring.mail.username=your-email@gmail.com \
  --set backend.env.spring.mail.password=your-app-password \
  --set ingress.hosts[0].host=bloodbank.yourdomain.com
```

### 5. Verify Deployment

```bash
# Check pods
kubectl get pods -n bloodbank

# Check services
kubectl get svc -n bloodbank

# Check ingress
kubectl get ingress -n bloodbank

# View logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank
```

## 📚 Documentation

- **[Kubernetes Deployment Guide](KUBERNETES_DEPLOYMENT.md)**: Comprehensive deployment instructions
- **[Deployment Scripts](DEPLOYMENT_SCRIPTS.md)**: Helper scripts for deployment automation

## 🔧 Configuration

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
- `VITE_API_URL`: Backend API URL (default: `/api` for production)

### Helm Values

Key configuration options in `helm/bloodbank/values.yaml`:

```yaml
# Replica count
replicaCount: 2

# Backend configuration
backend:
  image:
    repository: bloodbank-backend
    tag: "1.0.0"
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10

# Frontend configuration
frontend:
  image:
    repository: bloodbank-frontend
    tag: "1.0.0"
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10

# MySQL configuration
mysql:
  enabled: true
  persistence:
    enabled: true
    size: 10Gi

# Ingress configuration
ingress:
  enabled: true
  hosts:
    - host: bloodbank.example.com
```

## 📊 Scaling and High Availability

### Horizontal Pod Autoscaler

The HPA automatically scales pods based on CPU and memory usage:

```bash
# Check HPA status
kubectl get hpa -n bloodbank

# View HPA details
kubectl describe hpa bloodbank-backend-hpa -n bloodbank
```

### Manual Scaling

```bash
# Scale backend
kubectl scale deployment bloodbank-backend --replicas=5 -n bloodbank

# Scale frontend
kubectl scale deployment bloodbank-frontend --replicas=5 -n bloodbank
```

## 🔒 Security

### Secrets Management

Secrets are stored in Kubernetes secrets:

```bash
# Create secrets
kubectl create secret generic bloodbank-secrets \
  --from-literal=db-password=your-password \
  --from-literal=mail-password=your-password \
  -n bloodbank
```

### TLS/SSL

Configure TLS in the ingress:

```yaml
ingress:
  tls:
    - secretName: bloodbank-tls
      hosts:
        - bloodbank.example.com
```

## 🔄 CI/CD

The GitHub Actions workflow automates:

1. Building Docker images
2. Pushing to container registry
3. Deploying to Kubernetes

Configure secrets in GitHub:
- `KUBECONFIG`: Base64 encoded kubeconfig
- `DB_PASSWORD`: Database password
- `MAIL_USERNAME`: Email username
- `MAIL_PASSWORD`: Email password

## 🐛 Troubleshooting

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

### Debug Commands

```bash
# Get all resources
kubectl get all -n bloodbank

# Describe resources
kubectl describe deployment bloodbank-backend -n bloodbank

# Check events
kubectl get events -n bloodbank --sort-by='.lastTimestamp'

# Port forward for testing
kubectl port-forward service/bloodbank-backend 8080:8080 -n bloodbank
```

## 📈 Monitoring

### Health Checks

```bash
# Backend health
kubectl exec -it deployment/bloodbank-backend -n bloodbank -- \
  curl http://localhost:8080/actuator/health

# Check pod status
kubectl get pods -n bloodbank

# Check service endpoints
kubectl get endpoints -n bloodbank
```

### Logs

```bash
# Backend logs
kubectl logs -f deployment/bloodbank-backend -n bloodbank

# Frontend logs
kubectl logs -f deployment/bloodbank-frontend -n bloodbank

# MySQL logs
kubectl logs -f deployment/bloodbank-mysql -n bloodbank
```

## 🗄️ Database

### Backup

```bash
# Create backup
kubectl exec -it deployment/bloodbank-mysql -n bloodbank -- \
  mysqldump -u root -p blood > backup.sql
```

### Restore

```bash
# Restore backup
kubectl exec -i deployment/bloodbank-mysql -n bloodbank -- \
  mysql -u root -p blood < backup.sql
```

## 🔄 Updates

### Update Application

```bash
# Update image
helm upgrade bloodbank ./helm/bloodbank \
  --namespace bloodbank \
  --set backend.image.tag=1.1.0 \
  --set frontend.image.tag=1.1.0

# Rollback if needed
helm rollback bloodbank -n bloodbank
```

## 📝 Project Structure

```
bloodbanking-system-main/
├── backend/                 # Spring Boot backend
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
├── frontend/               # React frontend
│   ├── Dockerfile
│   ├── nginx.conf.template
│   ├── package.json
│   └── src/
├── helm/                   # Helm charts
│   └── bloodbank/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
├── .github/                # CI/CD workflows
│   └── workflows/
│       └── ci-cd.yml
├── KUBERNETES_DEPLOYMENT.md
├── DEPLOYMENT_SCRIPTS.md
└── README.md
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🔗 Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [React Documentation](https://react.dev/)

## 📞 Support

For issues and questions:
1. Check the [Troubleshooting](#-troubleshooting) section
2. Review the [Kubernetes Deployment Guide](KUBERNETES_DEPLOYMENT.md)
3. Open an issue in the repository

---

**Note**: Remember to update all placeholder values (passwords, domains, email addresses) before deploying to production.


