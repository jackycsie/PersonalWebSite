# Kubernetes 配置文件

這個目錄包含了所有的 Kubernetes 資源配置，採用模組化設計，每個資源類型都有獨立的 YAML 文件。

## 📁 文件結構

```
k8s/
├── namespace.yaml      # 命名空間定義
├── configmap.yaml      # 應用程式配置
├── secret.yaml         # ECR 認證密鑰（模板）
├── deployment.yaml     # Pod 部署配置
├── service.yaml        # 服務暴露配置
├── kustomization.yaml  # Kustomize 配置
└── README.md          # 說明文件
```

## 🔗 資源關係圖

```
Namespace: my-blog-project
├── ConfigMap: my-blog-project-config
├── Secret: ecr-secret
├── Deployment: my-blog-project
│   ├── ReplicaSet: my-blog-project-xxx
│   └── Pods: my-blog-project-xxx-yyy (x2)
└── Service: my-blog-project
    └── LoadBalancer → Pods:8080
```

## 🚀 部署方式

### 方法 1: 使用 Kustomize（推薦）
```bash
kubectl apply -k k8s/
```

### 方法 2: 按順序部署
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
# ECR secret 需要動態創建
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### 方法 3: 使用部署腳本
```bash
./scripts/deploy.sh [image-tag]
```

## 🧹 清理資源

```bash
./scripts/cleanup.sh
```

## 📋 配置說明

- **namespace.yaml**: 創建獨立的命名空間，隔離資源
- **configmap.yaml**: 存儲應用程式的非敏感配置
- **secret.yaml**: ECR 認證密鑰模板（由 CI/CD 動態創建）
- **deployment.yaml**: 定義 Pod 模板、副本數、健康檢查等
- **service.yaml**: 暴露服務，提供負載均衡
- **kustomization.yaml**: 管理資源部署順序和映像標籤
