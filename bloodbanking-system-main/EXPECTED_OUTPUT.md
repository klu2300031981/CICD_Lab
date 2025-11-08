# Expected Output from Blood Banking System Deployment

## What You Will See When Deployment is Successful

### 1. Prerequisites Check Output

```
=== Checking Prerequisites ===

✅ Docker is installed: Docker version 28.5.1, build e180ab8
✅ kubectl is installed
✅ Helm is installed: v3.12.0
✅ Connected to Kubernetes cluster
```

### 2. Building Docker Images Output

```
=== Building Docker Images ===

Building backend image...
[+] Building 45.2s (15/15) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 2.45kB
 => [internal] load .dockerignore
 => => transferring context: 2B
 => [internal] load metadata for docker.io/library/maven:3.9-eclipse-temurin-21
 => [internal] load metadata for docker.io/library/eclipse-temurin:21-jre-alpine
 => [build 1/6] FROM docker.io/library/maven:3.9-eclipse-temurin-21
 => [internal] load build context
 => => transferring context: 12.5MB
 => [build 2/6] WORKDIR /app
 => [build 3/6] COPY pom.xml .
 => [build 4/6] COPY src ./src
 => [build 5/6] RUN mvn clean package -DskipTests
 => [build 6/6] COPY --from=build /app/target/*.war app.war
 => exporting to image
 => => exporting layers
 => => writing image sha256:abc123...
 => => naming to docker.io/library/bloodbank-backend:1.0.0

✅ Backend image built successfully

Building frontend image...
[+] Building 38.5s (12/12) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 1.89kB
 => [internal] load .dockerignore
 => => transferring context: 2B
 => [internal] load metadata for docker.io/library/node:20-alpine
 => [internal] load metadata for docker.io/library/nginx:alpine
 => [build 1/5] FROM docker.io/library/node:20-alpine
 => [internal] load build context
 => => transferring context: 8.2MB
 => [build 2/5] WORKDIR /app
 => [build 3/5] COPY package*.json ./
 => [build 4/5] RUN npm ci
 => [build 5/5] RUN npm run build
 => [stage-1 2/3] COPY --from=build /app/dist /usr/share/nginx/html
 => [stage-1 3/3] COPY nginx.conf.template /etc/nginx/templates/default.conf.template
 => exporting to image
 => => exporting layers
 => => writing image sha256:def456...
 => => naming to docker.io/library/bloodbank-frontend:1.0.0

✅ Frontend image built successfully
```

### 3. Installing Ingress Controller Output

```
=== Installing Ingress Controller ===

namespace/ingress-nginx created
serviceaccount/ingress-nginx created
configmap/ingress-nginx-controller created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
service/ingress-nginx-controller-admission created
service/ingress-nginx-controller created
deployment.apps/ingress-nginx-controller created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created

Waiting for ingress controller to be ready...
pod/ingress-nginx-controller-xxxxx condition met

✅ Ingress controller installed
```

### 4. Deploying with Helm Output

```
=== Deploying with Helm ===

Creating namespace...
namespace/bloodbank created

Deploying with Helm...
Release "bloodbank" does not exist. Installing it now.
NAME: bloodbank
LAST DEPLOYED: Mon Jan 08 10:30:00 2024
NAMESPACE: bloodbank
STATUS: deployed
REVISION: 1
TEST SUITE: None

✅ Deployment completed successfully!
```

### 5. Pod Status Output

```
=== Pod Status ===

NAME                                  READY   STATUS    RESTARTS   AGE
bloodbank-backend-7d8f9c4b5d-abc12    1/1     Running   0          45s
bloodbank-backend-7d8f9c4b5d-xyz78    1/1     Running   0          45s
bloodbank-frontend-6c5e4d3b2a-def45   1/1     Running   0          42s
bloodbank-frontend-6c5e4d3b2a-ghi90   1/1     Running   0          42s
bloodbank-mysql-8b7a6c5d4e-jkl23      1/1     Running   0          50s
```

**Explanation:**
- **2 Backend pods**: Running and ready (high availability)
- **2 Frontend pods**: Running and ready (high availability)
- **1 MySQL pod**: Running and ready (database)

### 6. Service Status Output

```
=== Service Status ===

NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
bloodbank-backend     ClusterIP   10.96.145.23    <none>        8080/TCP   1m
bloodbank-frontend    ClusterIP   10.96.152.45    <none>        80/TCP     1m
bloodbank-mysql       ClusterIP   10.96.138.67    <none>        3306/TCP   1m
```

**Explanation:**
- **Backend Service**: Accessible on port 8080 within cluster
- **Frontend Service**: Accessible on port 80 within cluster
- **MySQL Service**: Accessible on port 3306 within cluster

### 7. HPA (Horizontal Pod Autoscaler) Status Output

```
=== HPA Status ===

NAME                        REFERENCE                      TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
bloodbank-backend-hpa       Deployment/bloodbank-backend   0%/70%, 0%/80%  2         10        2          1m
bloodbank-frontend-hpa      Deployment/bloodbank-frontend  0%/70%          2         10        2          1m
```

**Explanation:**
- **Backend HPA**: Automatically scales between 2-10 pods based on CPU (70%) and Memory (80%)
- **Frontend HPA**: Automatically scales between 2-10 pods based on CPU (70%)
- **Current Replicas**: 2 for each (minimum)

### 8. Ingress Status Output

```
=== Ingress Status ===

NAME                CLASS   HOSTS              ADDRESS        PORTS     AGE
bloodbank-ingress   nginx   bloodbank.local    <pending>      80        1m
```

**Explanation:**
- **Ingress**: Configured to route traffic to frontend and backend
- **Host**: bloodbank.local (can be accessed via port-forward)

### 9. Application Logs Output

#### Backend Logs:
```
=== Backend Logs ===

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.4.2)

2024-01-08 10:30:15.123  INFO 1 --- [           main] bb.BloodApplication                      : Starting BloodApplication
2024-01-08 10:30:18.456  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http)
2024-01-08 10:30:18.789  INFO 1 --- [           main] bb.BloodApplication                      : Started BloodApplication in 3.5 seconds
```

#### Frontend Logs:
```
=== Frontend Logs ===

/docker-entrypoint.sh: Configuration complete; ready for start up
2024/01/08 10:30:20 [notice] 1#1: using the "epoll" event method
2024/01/08 10:30:20 [notice] 1#1: nginx/1.25.3
2024/01/08 10:30:20 [notice] 1#1: start worker processes
2024/01/08 10:30:20 [notice] 1#1: start worker process 7
```

#### MySQL Logs:
```
=== MySQL Logs ===

2024-01-08T10:30:05.123456Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.35) starting as process 1
2024-01-08T10:30:08.789012Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections.
2024-01-08T10:30:08.890123Z 0 [System] [MY-011323] [Server] X Plugin ready for connections.
```

### 10. Health Check Output

#### Backend Health:
```bash
kubectl exec -it deployment/bloodbank-backend -n bloodbank -- curl http://localhost:8080/actuator/health
```

**Output:**
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": {
        "database": "MySQL",
        "validationQuery": "isValid()"
      }
    },
    "diskSpace": {
      "status": "UP"
    },
    "ping": {
      "status": "UP"
    }
  }
}
```

### 11. Port Forward Output

```
=== Setting up Port Forward ===

# Terminal 1: Frontend
kubectl port-forward -n bloodbank svc/bloodbank-frontend 3000:80

Output:
Forwarding from 127.0.0.1:3000 -> 80
Forwarding from [::1]:3000 -> 80

# Terminal 2: Backend
kubectl port-forward -n bloodbank svc/bloodbank-backend 8080:8080

Output:
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```

### 12. Access Application Output

Once port-forward is running:

**Browser Output:**
- **Frontend**: http://localhost:3000
  - Shows the Blood Banking System homepage
  - Sign in/Sign up interface
  - Navigation to Dashboard, Donors, Inventory, Requests

- **Backend API**: http://localhost:8080
  - Health endpoint: http://localhost:8080/actuator/health
  - API endpoints available at: http://localhost:8080/api/...

### 13. Complete Deployment Summary

```
========================================
  DEPLOYMENT SUMMARY
========================================

✅ Prerequisites: All met
✅ Docker Images: Built successfully
✅ Ingress Controller: Installed and ready
✅ Helm Deployment: Completed successfully
✅ Pods: 5/5 Running (2 backend, 2 frontend, 1 mysql)
✅ Services: 3/3 Available
✅ HPA: 2/2 Active
✅ Health Checks: All passing

Application Access:
  Frontend: http://localhost:3000 (after port-forward)
  Backend:  http://localhost:8080 (after port-forward)

Useful Commands:
  View pods:     kubectl get pods -n bloodbank
  View logs:     kubectl logs -f deployment/bloodbank-backend -n bloodbank
  View services: kubectl get svc -n bloodbank
  View HPA:      kubectl get hpa -n bloodbank
  Scale:         kubectl scale deployment/bloodbank-backend --replicas=5 -n bloodbank

========================================
  DEPLOYMENT COMPLETE!
========================================
```

## What Happens During Deployment

1. **Namespace Creation**: Creates `bloodbank` namespace
2. **Secrets Creation**: Creates Kubernetes secrets for database and email credentials
3. **MySQL Deployment**: Deploys MySQL database with persistent storage
4. **Backend Deployment**: Deploys Spring Boot backend with 2 replicas
5. **Frontend Deployment**: Deploys React frontend with 2 replicas
6. **Service Creation**: Creates services for backend, frontend, and MySQL
7. **Ingress Setup**: Configures ingress for external access
8. **HPA Activation**: Enables automatic scaling
9. **Health Checks**: Verifies all pods are healthy
10. **Ready State**: All components are running and ready

## Monitoring Output

### Watch Pods:
```bash
kubectl get pods -n bloodbank -w
```

**Output:**
```
NAME                                  READY   STATUS    RESTARTS   AGE
bloodbank-backend-7d8f9c4b5d-abc12    0/1     Pending   0          0s
bloodbank-backend-7d8f9c4b5d-abc12    0/1     ContainerCreating   0          2s
bloodbank-backend-7d8f9c4b5d-abc12    0/1     Running   0          5s
bloodbank-backend-7d8f9c4b5d-abc12    1/1     Running   0          10s
```

### Describe Pod:
```bash
kubectl describe pod bloodbank-backend-7d8f9c4b5d-abc12 -n bloodbank
```

**Output:**
```
Name:             bloodbank-backend-7d8f9c4b5d-abc12
Namespace:        bloodbank
Priority:         0
Node:             docker-desktop/192.168.65.4
Start Time:       Mon, 08 Jan 2024 10:30:00 +0000
Labels:           app.kubernetes.io/component=backend
                  app.kubernetes.io/instance=bloodbank
                  app.kubernetes.io/name=bloodbank
Status:           Running
IP:               10.1.0.5
Containers:
  backend:
    Container ID:   docker://abc123...
    Image:          bloodbank-backend:1.0.0
    Image ID:       docker://sha256:def456...
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 08 Jan 2024 10:30:05 +0000
    Ready:          True
    Restart Count:  0
    Liveness:       http-get http://:8080/actuator/health delay=60s timeout=5s period=10s #success=1 #failure=3
    Readiness:      http-get http://:8080/actuator/health delay=30s timeout=3s period=5s #success=1 #failure=3
    Environment:
      SPRING_DATASOURCE_URL:      jdbc:mysql://bloodbank-mysql:3306/blood
      SPRING_DATASOURCE_USERNAME: <set to the key 'db-username' in secret 'bloodbank-secrets'>
      SPRING_DATASOURCE_PASSWORD: <set to the key 'db-password' in secret 'bloodbank-secrets'>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-xyz (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  1m    default-scheduler  Successfully assigned bloodbank/bloodbank-backend-7d8f9c4b5d-abc12 to docker-desktop
  Normal  Pulled     1m    kubelet            Container image "bloodbank-backend:1.0.0" already present on machine
  Normal  Created    1m    kubelet            Created container backend
  Normal  Started    1m    kubelet            Started container backend
```

This is what you will see when the deployment is successful!


