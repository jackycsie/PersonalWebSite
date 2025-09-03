# 🚀 雙容器整合部署指南

## 📋 專案概述

這個專案現在整合了兩個容器：

1. **FastAPI 應用** (`my-blog-project`)
   - 端口：8080
   - 功能：API 服務和靜態文件服務
   - 技術棧：Python + FastAPI + Uvicorn

2. **Jekyll 網站** (`jekyll-site`)
   - 端口：4000
   - 功能：靜態網站和部落格
   - 技術棧：Ruby + Jekyll + Nginx

## 🏗️ 架構設計

```
Kubernetes Pod (my-blog-project-multi)
├── 容器 1: FastAPI 應用 (fastapi-app)
│   ├── 端口: 8080
│   ├── 健康檢查: /healthz
│   └── 資源限制: CPU 200m, Memory 256Mi
│
└── 容器 2: Jekyll 網站 (jekyll-site)
    ├── 端口: 4000
    ├── 健康檢查: /
    ├── 資源限制: CPU 300m, Memory 512Mi
    └── 包含 Nginx 反向代理
```

## 🌐 訪問方式

部署完成後，您可以通過以下方式訪問：

- **FastAPI 應用**: `http://[NODE-IP]:30080`
- **Jekyll 網站**: `http://[NODE-IP]:30081`

## 🔄 部署流程

### 自動部署 (推薦)
1. 推送到 `main` 分支
2. GitHub Actions 自動觸發 CD
3. 建置兩個 Docker 映像
4. 推送到 AWS ECR
5. 部署到 Kubernetes

### 手動部署
```bash
# 使用多容器部署腳本
./scripts/deploy-multi.sh [image-tag]

# 或使用 Kustomize
kubectl apply -k k8s/kustomization-multi.yaml
```

## 📁 文件結構

```
my_blog_project/
├── app/                    # FastAPI 應用
├── jekyll-site/           # Jekyll 網站 (複製自 jackycsie.github.io)
├── k8s/                   # Kubernetes 配置
│   ├── deployment-multi.yaml    # 多容器部署
│   ├── service-multi.yaml       # 雙服務配置
│   └── kustomization-multi.yaml # 部署管理
└── scripts/               # 部署腳本
    └── deploy-multi.sh    # 多容器部署腳本
```

## 🐳 Docker 映像

### FastAPI 應用
- **倉庫**: `my-blog-project`
- **基礎映像**: `python:3.11-slim`
- **端口**: 8080

### Jekyll 網站
- **倉庫**: `jekyll-site`
- **基礎映像**: `ruby:3.2-slim`
- **端口**: 4000
- **包含**: Nginx 反向代理

## 🔧 故障排除

### 檢查容器狀態
```bash
# 查看 Pod 狀態
kubectl get pods -n my-blog-project

# 查看容器日誌
kubectl logs -n my-blog-project -l app=my-blog-project-multi -c fastapi-app
kubectl logs -n my-blog-project -l app=my-blog-project-multi -c jekyll-site

# 查看服務狀態
kubectl get services -n my-blog-project
```

### 常見問題
1. **容器啟動失敗**: 檢查健康檢查路徑和端口
2. **映像拉取失敗**: 確認 ECR 認證和映像標籤
3. **服務無法訪問**: 檢查 NodePort 配置和防火牆設置

## 🎯 優勢

✅ **統一部署**: 一個 CD 流程部署兩個應用  
✅ **資源共享**: 兩個容器共享 Pod 資源  
✅ **簡化管理**: 統一的命名空間和標籤  
✅ **靈活擴展**: 可以獨立調整每個容器的資源  
✅ **故障隔離**: 一個容器失敗不影響另一個  

## 📝 後續改進

- [ ] 添加 Ingress 配置，使用域名訪問
- [ ] 配置 SSL 證書
- [ ] 添加監控和日誌聚合
- [ ] 實現藍綠部署
- [ ] 添加自動擴縮容 (HPA)
