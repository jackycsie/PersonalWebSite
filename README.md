# My Blog Project - 模組化架構

這是一個整合了 Jekyll 部落格和 FastAPI 後端的模組化專案。

## 🏗️ 專案架構

```
my_blog_project/
├── modules/                     # 模組目錄
│   ├── jekyll-blog/           # Jekyll 部落格模組
│   └── fastapi-api/            # FastAPI API 模組
├── k8s/                        # Kubernetes 配置
├── scripts/                     # 部署腳本
├── docs/                        # 專案文檔
└── .github/                     # GitHub Actions
```

## 🚀 快速開始

### 部署 Jekyll 部落格（單容器）
```bash
# 觸發 GitHub Actions CD
git push origin main
```

### 本地開發
```bash
# Jekyll 部落格
cd modules/jekyll-blog
bundle install
bundle exec jekyll serve

# FastAPI 後端
cd modules/fastapi-api
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## 📚 模組說明

### Jekyll 部落格模組 (`modules/jekyll-blog/`)
- 靜態網站生成器
- 支援 Markdown 文章
- 響應式設計
- Docker 容器化

### FastAPI API 模組 (`modules/fastapi-api/`)
- RESTful API 服務
- Python 3.11
- 健康檢查端點
- Docker 容器化

## 🐳 部署

專案使用 GitHub Actions 自動部署到 AWS EKS：
- Jekyll 部落格：端口 30081
- 自動化 CI/CD 流程
- Kubernetes 部署

## 📖 詳細文檔

- [部署指南](docs/DEPLOYMENT.md)
- [專案結構](docs/PROJECT_STRUCTURE.md)
- [整合指南](docs/INTEGRATION.md)

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

## 📄 授權

MIT License
