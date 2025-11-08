# Blood Banking System

A full-stack Blood Banking System deployed on Kubernetes using Helm and Ingress, ensuring scalability, automation, and high availability through containerization and orchestration.

## 🏗️ Architecture

- **Frontend**: React application served via Nginx
- **Backend**: Spring Boot REST API (Java 21)
- **Database**: MySQL 8.0 with persistent storage
- **Orchestration**: Kubernetes with Helm charts
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

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (v1.24+)
- kubectl (v1.24+)
- Helm (v3.12+)
- Docker (for building images)

### Deployment

```bash
# Build images
docker build -t bloodbank-backend:1.0.0 ./backend
docker build -t bloodbank-frontend:1.0.0 ./frontend

# Deploy with Helm
helm install bloodbank ./helm/bloodbank \
  --namespace bloodbank \
  --create-namespace \
  --set backend.image.repository=bloodbank-backend \
  --set frontend.image.repository=bloodbank-frontend
```

## 📚 Documentation

- **[README.md](README.md)** - Main documentation
- **[KUBERNETES_DEPLOYMENT.md](KUBERNETES_DEPLOYMENT.md)** - Detailed deployment guide
- **[EXECUTE_PROJECT.md](EXECUTE_PROJECT.md)** - Execution guide
- **[ACCESS_APPLICATION.md](ACCESS_APPLICATION.md)** - How to access the application
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Setup instructions

## 📊 Project Structure

```
bloodbanking-system/
├── backend/                 # Spring Boot backend
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
├── frontend/               # React frontend
│   ├── Dockerfile
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
└── Documentation files
```

## 🔧 Configuration

### Environment Variables

- Backend: Database connection, email configuration
- Frontend: API URL configuration

### Helm Values

Key configuration options in `helm/bloodbank/values.yaml`:

- Replica count
- Resource limits
- Autoscaling configuration
- Ingress configuration
- Database configuration

## 📈 Scaling and High Availability

### Horizontal Pod Autoscaler

- Backend HPA: 2-10 replicas (CPU 70%, Memory 80%)
- Frontend HPA: 2-10 replicas (CPU 70%)

### Multi-Replica Deployments

- Default: 2 replicas for frontend and backend
- Health checks and probes
- Rolling updates for zero-downtime

## 🔒 Security

- Kubernetes Secrets for sensitive data
- TLS/SSL support
- Security headers
- Network policies (configurable)

## 🔄 CI/CD

GitHub Actions workflow automates:
- Building Docker images
- Pushing to container registry
- Deploying to Kubernetes

## 📝 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues and questions:
- Check the [Troubleshooting](KUBERNETES_DEPLOYMENT.md#troubleshooting) section
- Review the [Documentation](README.md)
- Open an issue in this repository

## 🔗 Links

- **Repository**: https://github.com/klu2300031981/bloodbanking-system
- **Issues**: https://github.com/klu2300031981/bloodbanking-system/issues
- **Releases**: https://github.com/klu2300031981/bloodbanking-system/releases

---

**Made with ❤️ for healthcare**

