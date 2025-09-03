# Jekyll 部落格模組

這是專案的 Jekyll 部落格模組，負責生成靜態網站。

## 🚀 快速開始

### 本地開發
```bash
# 安裝依賴
bundle install

# 啟動開發伺服器
bundle exec jekyll serve

# 訪問 http://localhost:4000
```

### Docker 開發
```bash
# 建置映像
docker build -t jekyll-blog .

# 運行容器
docker run -p 4000:4000 jekyll-blog
```

## 📁 目錄結構

```
jekyll-blog/
├── _posts/          # 部落格文章
├── _data/           # 網站資料
├── _tabs/           # 導航標籤
├── assets/          # 靜態資源
├── _plugins/        # Jekyll 插件
├── _config.yml      # Jekyll 配置
├── Gemfile          # Ruby 依賴
└── Dockerfile       # Docker 配置
```

## 🐳 生產部署

使用 `Dockerfile.ultra-simple` 進行生產部署：

```bash
docker build -f Dockerfile.ultra-simple -t jekyll-blog:prod .
```

## 📝 新增文章

在 `_posts/` 目錄下創建 Markdown 檔案：

```markdown
---
layout: post
title: "文章標題"
date: 2025-01-02
categories: [技術, 部落格]
---

文章內容...
```

## ⚙️ 配置

主要配置在 `_config.yml` 中，包括：
- 網站標題和描述
- 社交媒體連結
- 評論系統
- 分析追蹤

## 🔧 自定義

- 修改 `assets/css/` 中的樣式
- 在 `_layouts/` 中自定義佈局
- 使用 `_includes/` 創建可重用組件
