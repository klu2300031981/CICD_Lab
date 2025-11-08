# Deployment Scripts

This document contains helper scripts for deploying the Blood Banking System to Kubernetes.

## Prerequisites Check Script

```bash
#!/bin/bash
# check-prerequisites.sh

echo "Checking prerequisites..."

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed"
    exit 1
else
    echo "✅ kubectl is installed: $(kubectl version --client --short)"
fi

# Check Helm
if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed"
    exit 1
else
    echo "✅ Helm is installed: $(helm version --short)"
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed"
    exit 1
else
    echo "✅ Docker is installed: $(docker --version)"
fi

# Check Kubernetes cluster
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster"
    exit 1
else
    echo "✅ Connected to Kubernetes cluster"
    kubectl cluster-info
fi

echo "All prerequisites are met!"
```

## Build and Push Images Script

```bash
#!/bin/bash
# build-and-push.sh

set -e

REGISTRY=${REGISTRY:-"your-registry"}
BACKEND_IMAGE="${REGISTRY}/bloodbank-backend"
FRONTEND_IMAGE="${REGISTRY}/bloodbank-frontend"
VERSION=${VERSION:-"1.0.0"}

echo "Building and pushing images..."
echo "Registry: ${REGISTRY}"
echo "Version: ${VERSION}"

# Build backend
echo "Building backend image..."
cd backend
docker build -t ${BACKEND_IMAGE}:${VERSION} .
docker tag ${BACKEND_IMAGE}:${VERSION} ${BACKEND_IMAGE}:latest
cd ..

# Build frontend
echo "Building frontend image..."
cd frontend
docker build -t ${FRONTEND_IMAGE}:${VERSION} --build-arg VITE_API_URL=http://backend-service:8080 .
docker tag ${FRONTEND_IMAGE}:${VERSION} ${FRONTEND_IMAGE}:latest
cd ..

# Push images
echo "Pushing images to registry..."
docker push ${BACKEND_IMAGE}:${VERSION}
docker push ${BACKEND_IMAGE}:latest
docker push ${FRONTEND_IMAGE}:${VERSION}
docker push ${FRONTEND_IMAGE}:latest

echo "Images built and pushed successfully!"
```

## Deploy Script

```bash
#!/bin/bash
# deploy.sh

set -e

NAMESPACE=${NAMESPACE:-"bloodbank"}
RELEASE_NAME=${RELEASE_NAME:-"bloodbank"}
REGISTRY=${REGISTRY:-"your-registry"}
VERSION=${VERSION:-"1.0.0"}

# Read secrets
read -sp "Database password: " DB_PASSWORD
echo
read -sp "Email password: " MAIL_PASSWORD
echo
read -p "Email username: " MAIL_USERNAME
read -p "Ingress hostname: " INGRESS_HOST

# Create namespace
echo "Creating namespace..."
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Create secrets
echo "Creating secrets..."
kubectl create secret generic bloodbank-secrets \
  --from-literal=db-username=root \
  --from-literal=db-password=${DB_PASSWORD} \
  --from-literal=mail-username=${MAIL_USERNAME} \
  --from-literal=mail-password=${MAIL_PASSWORD} \
  -n ${NAMESPACE} \
  --dry-run=client -o yaml | kubectl apply -f -

# Deploy with Helm
echo "Deploying with Helm..."
helm upgrade --install ${RELEASE_NAME} ./helm/bloodbank \
  --namespace ${NAMESPACE} \
  --set backend.image.repository=${REGISTRY}/bloodbank-backend \
  --set backend.image.tag=${VERSION} \
  --set frontend.image.repository=${REGISTRY}/bloodbank-frontend \
  --set frontend.image.tag=${VERSION} \
  --set ingress.hosts[0].host=${INGRESS_HOST} \
  --wait --timeout 10m

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/instance=${RELEASE_NAME} \
  -n ${NAMESPACE} \
  --timeout=300s

# Show status
echo "Deployment status:"
kubectl get pods -n ${NAMESPACE}
kubectl get svc -n ${NAMESPACE}
kubectl get ingress -n ${NAMESPACE}

echo "Deployment completed!"
```

## Undeploy Script

```bash
#!/bin/bash
# undeploy.sh

set -e

NAMESPACE=${NAMESPACE:-"bloodbank"}
RELEASE_NAME=${RELEASE_NAME:-"bloodbank"}

echo "Undeploying Blood Banking System..."

# Uninstall Helm release
helm uninstall ${RELEASE_NAME} -n ${NAMESPACE} || true

# Delete namespace (optional)
read -p "Delete namespace ${NAMESPACE}? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    kubectl delete namespace ${NAMESPACE}
    echo "Namespace deleted"
else
    echo "Namespace kept"
fi

echo "Undeployment completed!"
```

## Update Script

```bash
#!/bin/bash
# update.sh

set -e

NAMESPACE=${NAMESPACE:-"bloodbank"}
RELEASE_NAME=${RELEASE_NAME:-"bloodbank"}
REGISTRY=${REGISTRY:-"your-registry"}
VERSION=${1:-"latest"}

echo "Updating Blood Banking System to version ${VERSION}..."

helm upgrade ${RELEASE_NAME} ./helm/bloodbank \
  --namespace ${NAMESPACE} \
  --set backend.image.repository=${REGISTRY}/bloodbank-backend \
  --set backend.image.tag=${VERSION} \
  --set frontend.image.repository=${REGISTRY}/bloodbank-frontend \
  --set frontend.image.tag=${VERSION} \
  --wait --timeout 10m

echo "Update completed!"
```

## Health Check Script

```bash
#!/bin/bash
# health-check.sh

set -e

NAMESPACE=${NAMESPACE:-"bloodbank"}
RELEASE_NAME=${RELEASE_NAME:-"bloodbank"}

echo "Checking health of Blood Banking System..."

# Check pods
echo "Pod status:"
kubectl get pods -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}

# Check services
echo -e "\nService status:"
kubectl get svc -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}

# Check ingress
echo -e "\nIngress status:"
kubectl get ingress -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}

# Check HPA
echo -e "\nHPA status:"
kubectl get hpa -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}

# Test backend health
echo -e "\nBackend health:"
BACKEND_POD=$(kubectl get pod -n ${NAMESPACE} -l app.kubernetes.io/component=backend -o jsonpath='{.items[0].metadata.name}')
if [ ! -z "$BACKEND_POD" ]; then
    kubectl exec -n ${NAMESPACE} ${BACKEND_POD} -- curl -s http://localhost:8080/actuator/health || echo "Backend health check failed"
fi

echo -e "\nHealth check completed!"
```

## Usage

Make scripts executable:
```bash
chmod +x check-prerequisites.sh
chmod +x build-and-push.sh
chmod +x deploy.sh
chmod +x undeploy.sh
chmod +x update.sh
chmod +x health-check.sh
```

Run scripts:
```bash
# Check prerequisites
./check-prerequisites.sh

# Build and push images
export REGISTRY=your-registry
export VERSION=1.0.0
./build-and-push.sh

# Deploy
./deploy.sh

# Update
./update.sh 1.1.0

# Health check
./health-check.sh

# Undeploy
./undeploy.sh
```


