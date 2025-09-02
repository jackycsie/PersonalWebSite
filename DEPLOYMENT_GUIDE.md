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

### **3. 部署步驟**

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

### **4. 監控部署**

- **GitHub Actions**: 查看 CI/CD 執行狀態
- **AWS ECR**: 確認映像成功推送
- **Kubernetes**: 檢查 pods 和服務狀態

### **5. 安全原則**

✅ **使用 GitHub Secrets** 儲存敏感資訊  
✅ **只在 main 分支觸發 CD**  
✅ **保持 repository 為 public**  
❌ **不要上傳敏感資訊到任何分支**  

## 🎯 現在你需要做的

1. 設定 GitHub Secrets (按照上述步驟)
2. 建立 ECR Repository
3. 推送到 main 分支
4. 監控部署狀態

這樣設計既安全又實用！🚀
