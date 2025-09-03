# 🚀 AWS EKS 設置指南

## 概述

本指南說明如何在 AWS EKS 環境中設置和部署您的 Jekyll 部落格。

## 前置需求

1. **AWS CLI 已安裝並配置**
2. **EKS 集群已創建**
3. **適當的 IAM 權限**

## EKS 集群配置

### 1. 檢查 EKS 集群狀態

```bash
# 列出所有 EKS 集群
aws eks list-clusters --region ap-east-2

# 檢查特定集群狀態
aws eks describe-cluster --name YOUR_CLUSTER_NAME --region ap-east-2
```

### 2. 更新 kubeconfig

```bash
# 更新 kubeconfig 以連接到 EKS 集群
aws eks update-kubeconfig --region ap-east-2 --name YOUR_CLUSTER_NAME

# 驗證連接
kubectl cluster-info
kubectl get nodes
```

## 修改工作流程配置

### 1. 更新集群名稱

在 `.github/workflows/cd-single-fixed.yml` 中，將 `your-cluster-name` 替換為您的實際 EKS 集群名稱：

```yaml
- name: 🔐 Configure kubectl for EKS
  run: |
    echo "配置 kubectl 連接到 EKS 集群..."
    aws eks update-kubeconfig --region ${{ env.AWS_REGION }} --name YOUR_ACTUAL_CLUSTER_NAME
```

### 2. 檢查 IAM 權限

確保您的 GitHub Actions 使用的 AWS 憑證具有以下權限：

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ],
            "Resource": "*"
        }
    ]
}
```

## 部署步驟

### 1. 創建命名空間

```bash
kubectl apply -f k8s/namespace.yaml
```

### 2. 創建 ECR 認證 Secret

```bash
# 創建 ECR 登入 token
aws ecr get-login-password --region ap-east-2 | kubectl create secret docker-registry ecr-secret \
  --docker-server=728951503024.dkr.ecr.ap-east-2.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region ap-east-2) \
  --docker-email=deploy@myblog.com \
  -n my-blog-project
```

### 3. 部署應用

```bash
# 使用 Kustomize
kubectl apply -k k8s/kustomization-single.yaml

# 或手動部署
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment-single.yaml
kubectl apply -f k8s/service-single.yaml
```

## 故障排除

### 1. kubectl 連接問題

```bash
# 檢查 AWS 認證
aws sts get-caller-identity

# 重新配置 kubeconfig
aws eks update-kubeconfig --region ap-east-2 --name YOUR_CLUSTER_NAME

# 檢查集群狀態
kubectl cluster-info
```

### 2. ECR 認證問題

```bash
# 測試 ECR 登入
aws ecr get-login-password --region ap-east-2 | docker login --username AWS --password-stdin 728951503024.dkr.ecr.ap-east-2.amazonaws.com

# 檢查 ECR 倉庫
aws ecr describe-repositories --region ap-east-2
```

### 3. Pod 啟動問題

```bash
# 檢查 Pod 狀態
kubectl get pods -n my-blog-project

# 查看 Pod 詳細信息
kubectl describe pod <pod-name> -n my-blog-project

# 查看 Pod 日誌
kubectl logs <pod-name> -n my-blog-project
```

## 監控和日誌

### 1. 檢查部署狀態

```bash
# 查看部署狀態
kubectl get deployments -n my-blog-project

# 查看服務狀態
kubectl get services -n my-blog-project

# 查看 Pod 狀態
kubectl get pods -n my-blog-project
```

### 2. 查看日誌

```bash
# 查看 Pod 日誌
kubectl logs -f deployment/my-blog-project-single -n my-blog-project

# 查看事件
kubectl get events -n my-blog-project --sort-by='.lastTimestamp'
```

## 安全注意事項

1. **IAM 權限最小化**：只授予必要的權限
2. **ECR 倉庫安全**：使用適當的倉庫策略
3. **Secret 管理**：定期輪換 ECR 認證
4. **網路安全**：配置適當的網路策略

## 相關資源

- [AWS EKS 文檔](https://docs.aws.amazon.com/eks/)
- [AWS ECR 文檔](https://docs.aws.amazon.com/ecr/)
- [Kubernetes 官方文檔](https://kubernetes.io/docs/)
- [GitHub Actions 文檔](https://docs.github.com/en/actions)
