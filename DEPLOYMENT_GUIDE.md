# 部署指南

## 🚀 如何在 Public Repository 中安全部署到 AWS

### **1. 設定 GitHub Secrets**
前往 `https://github.com/jackycsie/PersonalWebSite/settings/secrets/actions`

#### **AWS 認證**
- `AWS_ACCESS_KEY_ID` = 你的 AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY` = 你的 AWS Secret Access Key

#### **Kubernetes 配置**
- `K8S_CLUSTER_URL` = 你的 K8s 集群 URL
- `K8S_CLUSTER_CA` = 你的集群 CA 憑證 (base64)
- `K8S_CLIENT_CERT` = 你的用戶端憑證 (base64)
- `K8S_CLIENT_KEY` = 你的用戶端金鑰 (base64)

### **2. 工作流程觸發**

#### **CI 工作流程**
- **觸發**: 所有分支的 push
- **功能**: 執行測試、Docker 建置測試

#### **CD 工作流程**
- **觸發**: 只有 `main` 分支的 push
- **功能**: 部署到 AWS ECR 和 Kubernetes
- **自動清理**: 自動清理已存在的資源，避免 "AlreadyExists" 錯誤

### **3. 部署方法**

#### **方法 1: GitHub Actions 自動部署 (推薦)**
1. **設定 GitHub Secrets** (如上)
2. **建立 ECR Repository**:
   ```bash
   aws ecr create-repository --repository-name my-blog-project --region ap-east-2
   ```
3. **推送到 main 分支** (自動觸發 CD):
   ```bash
   git checkout main
   git merge dev-final
   git push origin main
   ```

#### **方法 2: 使用部署腳本 (手動部署)**
1. **確保 kubectl 已配置並可連接到集群**
2. **執行部署腳本**:
   ```bash
   # 部署最新版本
   ./deploy.sh
   
   # 部署特定標籤
   ./deploy.sh v1.0.0
   ```

#### **方法 3: 使用 Kubernetes 配置文件**
1. **修改 k8s-deployment.yaml 中的映像標籤**
2. **應用配置**:
   ```bash
   kubectl apply -f k8s-deployment.yaml
   ```

### **4. 故障排除**

#### **常見錯誤: "AlreadyExists"**
- **原因**: 資源已存在於集群中
- **解決方案**: 
  - 使用 `./deploy.sh` 腳本 (自動清理)
  - 手動清理: `kubectl delete deployment,service my-blog-project`
  - GitHub Actions 會自動處理此問題

#### **檢查部署狀態**
```bash
# 檢查 pods
kubectl get pods -l app=my-blog-project

# 檢查服務
kubectl get services -l app=my-blog-project

# 查看日誌
kubectl logs -l app=my-blog-project

# 檢查部署狀態
kubectl rollout status deployment/my-blog-project
```

### **5. 監控部署**

- **GitHub Actions**: 查看 CI/CD 執行狀態
- **AWS ECR**: 確認映像成功推送
- **Kubernetes**: 檢查 pods 和服務狀態

### **6. 安全原則**

✅ **使用 GitHub Secrets** 儲存敏感資訊  
✅ **只在 main 分支觸發 CD**  
✅ **保持 repository 為 public**  
✅ **自動清理資源** 避免部署衝突  
❌ **不要上傳敏感資訊到任何分支**  

## 🎯 現在你需要做的

1. 設定 GitHub Secrets (按照上述步驟)
2. 建立 ECR Repository
3. 選擇部署方法:
   - **自動**: 推送到 main 分支
   - **手動**: 使用 `./deploy.sh` 腳本
4. 監控部署狀態

## 🆕 新增功能

- **自動清理**: CD 工作流程現在會自動清理已存在的資源
- **部署腳本**: 提供 `deploy.sh` 腳本用於手動部署
- **配置文件**: 提供 `k8s-deployment.yaml` 用於聲明式部署
- **故障排除**: 詳細的錯誤解決方案

這樣設計既安全又實用，解決了 "AlreadyExists" 錯誤！🚀

---

**測試部署觸發** - 這行文字會觸發新的 CD 部署
