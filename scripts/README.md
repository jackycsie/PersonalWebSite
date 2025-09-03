# 🚀 CI/CD 安全部署策略

## 📋 概述

本專案使用 **GitHub Actions CI/CD** 實現安全的 Kubernetes 部署，完全避免了強制刪除資源的問題。

## 🎯 部署策略

### ✅ **安全的滾動更新**
- **零停機時間**: 新版本啟動後才停止舊版本
- **自動回滾**: 部署失敗時自動回滾到上一個版本
- **健康檢查**: 部署前後都進行健康驗證
- **狀態監控**: 實時監控部署進度

### ❌ **不再使用的方法**
- ~~強制刪除所有資源~~
- ~~重建整個命名空間~~
- ~~服務中斷~~

## 🔄 CI/CD 工作流程

### **觸發條件**
- 推送到 `main` 分支時自動觸發
- 手動觸發 (workflow_dispatch)

### **部署流程**
1. **🔍 檢查當前狀態** - 檢查現有部署，決定是創建新部署還是滾動更新
2. **🏗️ 建置映像** - 建置並推送 Docker 映像到 ECR
3. **📋 部署資源** - 使用 Kustomize 或 kubectl 部署 Kubernetes 資源
4. **⏳ 等待就緒** - 等待新版本 Pod 就緒
5. **🏥 健康檢查** - 驗證服務是否正常響應
6. **📊 部署驗證** - 檢查所有資源狀態
7. **🔄 失敗回滾** - 如果失敗，自動回滾到上一個版本

## 🛡️ 安全特性

### **資源保護**
- 不會強制刪除現有資源
- 使用 `kubectl apply` 進行聲明式更新
- 保持現有配置和狀態

### **服務連續性**
- 滾動更新確保服務不間斷
- 新版本完全就緒後才切換流量
- 失敗時自動回滾，最小化影響

### **錯誤處理**
- 部署失敗時自動回滾
- 詳細的錯誤日誌和狀態檢查
- 多層次的驗證機制

## 📊 部署狀態檢查

### **GitHub Actions 中**
- 實時顯示部署進度
- 詳細的 Pod 狀態和事件
- 自動健康檢查結果

### **手動檢查**
```bash
# 檢查部署狀態
kubectl get deployment my-blog-project-single -n my-blog-project

# 檢查 Pod 狀態
kubectl get pods -n my-blog-project -l app=my-blog-project-single

# 檢查服務狀態
kubectl get service -n my-blog-project

# 查看部署歷史
kubectl rollout history deployment/my-blog-project-single -n my-blog-project
```

## 🚨 故障排除

### **部署失敗**
- GitHub Actions 會自動回滾
- 檢查 Pod 日誌: `kubectl logs -n my-blog-project <pod-name>`
- 檢查 Pod 詳情: `kubectl describe pod -n my-blog-project <pod-name>`

### **手動回滾**
```bash
# 回滾到上一個版本
kubectl rollout undo deployment/my-blog-project-single -n my-blog-project

# 回滾到特定版本
kubectl rollout undo deployment/my-blog-project-single -n my-blog-project --to-revision=<revision-number>
```

### **強制重啟**
```bash
# 重啟所有 Pod
kubectl delete pods -n my-blog-project -l app=my-blog-project-single

# 重啟特定 Pod
kubectl delete pod -n my-blog-project <pod-name>
```

## 📈 最佳實踐

### **部署前**
1. ✅ 確保代碼已通過 CI 測試
2. ✅ 檢查 ECR 映像是否成功推送
3. ✅ 確認 Kubernetes 集群狀態

### **部署中**
1. 📊 監控 GitHub Actions 執行狀態
2. 📊 關注 Pod 狀態變化
3. 📊 檢查健康檢查結果

### **部署後**
1. 🏥 驗證服務是否正常響應
2. 🌐 測試外部訪問
3. 📝 記錄部署結果

## 🔧 配置說明

### **環境變數**
```yaml
AWS_REGION: ap-east-2
ECR_REPOSITORY: jekyll-site
K8S_NAMESPACE: my-blog-project
DEPLOYMENT_NAME: my-blog-project-single
```

### **部署配置**
- 使用 `k8s/kustomization-single.yaml` 進行部署
- 支援 Kustomize 和 kubectl 兩種方式
- 自動更新映像標籤為 Git commit SHA

## 📚 參考資源

- [GitHub Actions 文檔](https://docs.github.com/en/actions)
- [Kubernetes 滾動更新](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment)
- [Kustomize 使用指南](https://kustomize.io/)
- [AWS ECR 整合](https://docs.aws.amazon.com/ecr/)

---

**最後更新**: 2025-01-17  
**維護者**: Jacky Huang  
**版本**: 2.0.0
