# 🚀 EC2 自建 Kubernetes 設置指南

## 概述

本指南說明如何在 EC2 自建的 Kubernetes 集群中設置和部署您的 Jekyll 部落格。

## 前置需求

1. **EC2 實例上已安裝 Kubernetes**
2. **kubectl 已配置並能連接到集群**
3. **適當的網路配置（安全組、VPC 等）**

## 配置 kubectl 連接到 EC2 K8s

### 1. 在本地配置 kubectl

```bash
# 從 EC2 實例複製 kubeconfig 文件
scp -i your-key.pem ec2-user@your-ec2-ip:~/.kube/config ~/.kube/config

# 或者手動創建 kubeconfig 文件
mkdir -p ~/.kube
cat > ~/.kube/config << EOF
apiVersion: v1
kind: Config
clusters:
- name: ec2-k8s-cluster
  cluster:
    server: https://your-ec2-ip:6443
    certificate-authority-data: YOUR_CA_DATA_HERE
contexts:
- name: ec2-k8s-context
  context:
    cluster: ec2-k8s-cluster
    user: ec2-k8s-user
current-context: ec2-k8s-context
users:
- name: ec2-k8s-user
  user:
    client-certificate-data: YOUR_CLIENT_CERT_DATA_HERE
    client-key-data: YOUR_CLIENT_KEY_DATA_HERE
EOF
```

### 2. 驗證連接

```bash
# 檢查集群狀態
kubectl cluster-info

# 檢查節點
kubectl get nodes

# 檢查命名空間
kubectl get namespaces
```

## GitHub Actions 配置

### 1. 方法一：使用 kubeconfig 作為 Secret

將您的 kubeconfig 文件內容作為 GitHub Secret 存儲：

```bash
# 在 GitHub 倉庫設置中添加以下 Secret：
# KUBE_CONFIG_DATA: 整個 kubeconfig 文件的 base64 編碼內容
cat ~/.kube/config | base64 -w 0
```

然後修改工作流程：

```yaml
- name: 🔐 Setup kubectl config
  run: |
    echo "設置 kubectl 配置..."
    mkdir -p $HOME/.kube
    echo "${{ secrets.KUBE_CONFIG_DATA }}" | base64 -d > $HOME/.kube/config
    chmod 600 $HOME/.kube/config
```

### 2. 方法二：使用 SSH 連接到 EC2

如果您的 EC2 實例可以從 GitHub Actions 訪問：

```yaml
- name: 🔐 Setup kubectl via SSH
  run: |
    echo "通過 SSH 設置 kubectl..."
    # 將 kubeconfig 從 EC2 複製到 runner
    scp -o StrictHostKeyChecking=no -i ${{ secrets.EC2_SSH_KEY }} \
      ec2-user@${{ secrets.EC2_IP }}:~/.kube/config ~/.kube/config
    chmod 600 ~/.kube/config
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

## 網路配置

### 1. 安全組設置

確保 EC2 實例的安全組允許以下端口：

- **6443** - Kubernetes API Server
- **30081** - Jekyll 服務端口
- **22** - SSH（如果需要）

### 2. 負載均衡器配置

如果使用 LoadBalancer 服務類型：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-blog-project-service
  namespace: my-blog-project
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 4000
    protocol: TCP
  selector:
    app: my-blog-project-single
```

## 故障排除

### 1. kubectl 連接問題

```bash
# 檢查 kubeconfig 文件
cat ~/.kube/config

# 檢查集群狀態
kubectl cluster-info

# 檢查認證
kubectl auth can-i get pods
```

### 2. 網路連接問題

```bash
# 檢查服務狀態
kubectl get services -n my-blog-project

# 檢查 Pod 網路
kubectl exec -n my-blog-project <pod-name> -- nslookup kubernetes.default

# 檢查防火牆規則
sudo iptables -L
```

### 3. 資源問題

```bash
# 檢查節點資源
kubectl describe nodes

# 檢查 Pod 事件
kubectl get events -n my-blog-project --sort-by='.lastTimestamp'

# 檢查 Pod 日誌
kubectl logs <pod-name> -n my-blog-project
```

## 監控和維護

### 1. 檢查集群健康狀態

```bash
# 檢查所有組件狀態
kubectl get componentstatuses

# 檢查節點狀態
kubectl get nodes -o wide

# 檢查 Pod 狀態
kubectl get pods --all-namespaces
```

### 2. 備份和恢復

```bash
# 備份 kubeconfig
cp ~/.kube/config ~/.kube/config.backup

# 備份資源配置
kubectl get all -n my-blog-project -o yaml > backup.yaml
```

## 安全注意事項

1. **kubeconfig 安全**：確保 kubeconfig 文件權限為 600
2. **網路安全**：限制對 Kubernetes API 的訪問
3. **認證管理**：定期輪換證書和密鑰
4. **RBAC 配置**：使用適當的角色和權限

## 相關資源

- [Kubernetes 官方文檔](https://kubernetes.io/docs/)
- [kubectl 命令參考](https://kubernetes.io/docs/reference/kubectl/)
- [GitHub Actions 文檔](https://docs.github.com/en/actions)
- [AWS EC2 文檔](https://docs.aws.amazon.com/ec2/)
