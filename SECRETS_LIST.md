# GitHub Secrets 清單

## 🔑 需要設定的 Secrets

在 GitHub repository 的 **Settings → Secrets and variables → Actions** 中添加：

### **AWS 認證**
- `AWS_ACCESS_KEY_ID` = 你的 AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY` = 你的 AWS Secret Access Key

### **Kubernetes 配置**
- `K8S_CLUSTER_URL` = 你的 K8s 集群 URL
- `K8S_CLUSTER_CA` = 你的集群 CA 憑證 (base64)
- `K8S_CLIENT_CERT` = 你的用戶端憑證 (base64)
- `K8S_CLIENT_KEY` = 你的用戶端金鑰 (base64)

## 📋 設定步驟

1. 前往 `https://github.com/jackycsie/PersonalWebSite/settings/secrets/actions`
2. 點擊 **New repository secret**
3. 輸入 Name 和 Value
4. 重複步驟 2-3 添加所有 Secrets

## 🚀 測試部署

設定完成後：
1. 推送到 `main` 分支 (自動觸發 CD)
2. 或在 Actions 頁面手動觸發 CD 工作流程
3. 監控部署狀態和日誌
