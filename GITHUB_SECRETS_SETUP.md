# GitHub Secrets 設定指南

## 🔑 需要設定的 Secrets

在 GitHub repository 的 **Settings → Secrets and variables → Actions** 中添加以下 secrets：

### **AWS 認證**
```
AWS_ACCESS_KEY_ID=你的AWS_Access_Key_ID
AWS_SECRET_ACCESS_KEY=你的AWS_Secret_Access_Key
AWS_REGION=ap-east-2
```

### **Kubernetes 集群配置**
```
K8S_CLUSTER_URL=https://你的EC2_IP:6443
K8S_CLUSTER_CA=你的集群CA憑證(base64編碼)
K8S_CLIENT_CERT=你的用戶端憑證(base64編碼)
K8S_CLIENT_KEY=你的用戶端金鑰(base64編碼)
```

## 📋 設定步驟

### **1. 進入 GitHub Repository**
1. 前往你的 repository: `https://github.com/jackycsie/PersonalWebSite`
2. 點擊 **Settings** 標籤
3. 左側選單選擇 **Secrets and variables** → **Actions**

### **2. 添加 AWS Secrets**
點擊 **New repository secret** 按鈕，添加：
- `AWS_ACCESS_KEY_ID` = 你的 AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY` = 你的 AWS Secret Access Key

### **3. 添加 Kubernetes Secrets**
點擊 **New repository secret** 按鈕，添加：
- `K8S_CLUSTER_URL` = 你的 Kubernetes 集群 URL
- `K8S_CLUSTER_CA` = 你的集群 CA 憑證
- `K8S_CLIENT_CERT` = 你的用戶端憑證
- `K8S_CLIENT_KEY` = 你的用戶端金鑰

## 🚀 獲取 Kubernetes 配置

### **在你的 EC2 上執行：**
```bash
# 建立並執行配置提取腳本
cat << 'EOF' > get-k8s-config.sh
#!/bin/bash

echo "=== Kubernetes 集群配置資訊 ==="
echo ""

echo "1. 集群伺服器 URL:"
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}' 2>/dev/null
echo ""
echo ""

echo "2. 集群 CA 憑證 (base64):"
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' 2>/dev/null
echo ""
echo ""

echo "3. 用戶端憑證 (base64):"
kubectl config view --minify -o jsonpath='{.users[0].user.client-certificate-data}' 2>/dev/null
echo ""
echo ""

echo "4. 用戶端金鑰 (base64):"
kubectl config view --minify -o jsonpath='{.users[0].user.client-key-data}' 2>/dev/null
echo ""
EOF

chmod +x get-k8s-config.sh
./get-k8s-config.sh
```

### **複製輸出結果並貼給我**

## 🔧 驗證設定

設定完成後，你可以：

1. **手動觸發 CD 工作流程**
   - 前往 **Actions** 標籤
   - 選擇 **CD - Deploy to AWS K8s**
   - 點擊 **Run workflow**

2. **檢查執行日誌**
   - 查看每個步驟的執行狀態
   - 確認 AWS 認證和 K8s 連接成功

## 🚨 注意事項

- **不要**在程式碼中硬編碼這些認證資訊
- **定期輪換** AWS Access Key (建議每 90 天)
- **監控** GitHub Actions 的執行日誌
- **備份** Kubernetes 配置資訊

## 📝 下一步

1. 執行上述命令獲取 K8s 配置
2. 將結果貼給我
3. 我幫你設定 GitHub Secrets
4. 測試完整的 CI/CD 流程

## ❓ 常見問題

**Q: 為什麼需要 base64 編碼的憑證？**
A: GitHub Secrets 需要純文字格式，base64 編碼可以安全地傳輸二進制憑證資料。

**Q: 可以手動輸入這些值嗎？**
A: 可以，但建議使用腳本自動提取以避免錯誤。

**Q: 設定完成後如何測試？**
A: 可以手動觸發 CD 工作流程或在 Actions 頁面查看執行狀態。
