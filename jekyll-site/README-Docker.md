# 🐳 Jacky 個人技術網站 - Docker 版本

這個專案已經配置好 Docker 容器化，讓您可以輕鬆運行個人技術部落格網站。

## 🚀 快速開始

### 前置需求
- Docker Desktop 已安裝並運行
- Docker Compose 已安裝

### 一鍵啟動
```bash
./docker-run.sh
```

### 手動啟動
```bash
# 建置並啟動容器
docker-compose up --build -d

# 查看服務狀態
docker-compose ps

# 查看日誌
docker-compose logs -f
```

## 🌐 訪問網站

啟動成功後，您可以通過以下地址訪問：

- **Jekyll 開發服務器**: http://localhost:4000
- **Nginx 生產服務器**: http://localhost:80

## 📁 專案結構

```
.
├── Dockerfile              # Docker 映像建置配置
├── docker-compose.yml      # Docker Compose 配置
├── nginx.conf             # Nginx 反向代理配置
├── .dockerignore          # Docker 忽略檔案
├── docker-run.sh          # 一鍵啟動腳本
├── _config.yml            # Jekyll 網站配置
├── _posts/                # 部落格文章
├── _tabs/                 # 頁面標籤
└── assets/                # 靜態資源
```

## 🔧 常用命令

### 開發模式
```bash
# 啟動開發服務器
docker-compose up -d

# 查看即時日誌
docker-compose logs -f jekyll-site

# 重新建置網站
docker-compose exec jekyll-site bundle exec jekyll build
```

### 生產模式
```bash
# 建置生產版本
docker-compose exec jekyll-site bundle exec jekyll build --production

# 使用 Nginx 服務靜態檔案
docker-compose up -d nginx
```

### 管理容器
```bash
# 停止所有服務
docker-compose down

# 重新建置並啟動
docker-compose up --build -d

# 清理未使用的映像
docker system prune -f
```

## 🎨 自訂配置

### 修改網站設定
編輯 `_config.yml` 檔案來自訂：
- 網站標題和描述
- 個人資訊
- 社交媒體連結
- 主題設定

### 添加新文章
在 `_posts/` 目錄下創建新的 `.md` 檔案，使用以下格式：

```markdown
---
title: "文章標題"
author: "Jacky Huang"
date: 2025-01-XX
categories: ["技術分類"]
tags: ["標籤1", "標籤2"]
description: "文章描述"
image:
  path: /assets/圖片路徑
---
```

### 修改主題
目前使用 Chirpy 主題，您可以：
- 自訂 CSS 樣式
- 修改頁面佈局
- 添加自訂功能

## 🐛 故障排除

### 常見問題

1. **端口被佔用**
   ```bash
   # 檢查端口使用情況
   lsof -i :4000
   lsof -i :80
   
   # 修改 docker-compose.yml 中的端口映射
   ```

2. **權限問題**
   ```bash
   # 確保腳本有執行權限
   chmod +x docker-run.sh
   ```

3. **建置失敗**
   ```bash
   # 清理並重新建置
   docker-compose down
   docker system prune -f
   docker-compose up --build -d
   ```

### 查看日誌
```bash
# 查看所有服務日誌
docker-compose logs

# 查看特定服務日誌
docker-compose logs jekyll-site
docker-compose logs nginx

# 即時追蹤日誌
docker-compose logs -f
```

## 🔄 更新網站

### 添加新內容
1. 編輯或添加 Markdown 檔案
2. 容器會自動重新載入變更
3. 或手動重新建置：`docker-compose exec jekyll-site bundle exec jekyll build`

### 更新依賴
```bash
# 更新 Ruby gems
docker-compose exec jekyll-site bundle update

# 重新建置容器
docker-compose up --build -d
```

## 📚 技術架構

- **Jekyll**: 靜態網站生成器
- **Chirpy Theme**: 現代化技術部落格主題
- **Docker**: 容器化部署
- **Nginx**: 反向代理和靜態檔案服務
- **Ruby**: Jekyll 運行環境

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request 來改善這個專案！

## 📄 授權

本專案採用 MIT 授權條款。
