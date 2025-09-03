# My Blog Project Makefile
# 簡化常用開發和部署命令

.PHONY: help build test clean deploy dev jekyll fastapi

# 預設目標
help:
	@echo "My Blog Project - 可用命令："
	@echo ""
	@echo "開發命令："
	@echo "  make jekyll     - 啟動 Jekyll 開發伺服器"
	@echo "  make fastapi    - 啟動 FastAPI 開發伺服器"
	@echo "  make dev        - 同時啟動兩個開發伺服器"
	@echo ""
	@echo "建置命令："
	@echo "  make build      - 建置所有 Docker 映像"
	@echo "  make build-jekyll - 建置 Jekyll 映像"
	@echo "  make build-fastapi - 建置 FastAPI 映像"
	@echo ""
	@echo "部署命令："
	@echo "  make deploy     - 部署到 Kubernetes"
	@echo "  make clean      - 清理 Kubernetes 資源"
	@echo ""
	@echo "測試命令："
	@echo "  make test       - 運行所有測試"
	@echo "  make test-fastapi - 運行 FastAPI 測試"
	@echo ""
	@echo "維護命令："
	@echo "  make status     - 檢查 Kubernetes 狀態"
	@echo "  make logs       - 查看 Pod 日誌"

# 開發命令
jekyll:
	@echo "🚀 啟動 Jekyll 開發伺服器..."
	cd modules/jekyll-blog && bundle exec jekyll serve --livereload

fastapi:
	@echo "🚀 啟動 FastAPI 開發伺服器..."
	cd modules/fastapi-api && uvicorn app.main:app --reload --host 0.0.0.0 --port 8080

dev:
	@echo "🚀 同時啟動兩個開發伺服器..."
	@echo "Jekyll: http://localhost:4000"
	@echo "FastAPI: http://localhost:8080"
	@make -j2 jekyll fastapi

# 建置命令
build: build-jekyll build-fastapi
	@echo "✅ 所有映像建置完成"

build-jekyll:
	@echo "🔨 建置 Jekyll 映像..."
	cd modules/jekyll-blog && docker build -f Dockerfile.ultra-simple -t jekyll-blog:latest .

build-fastapi:
	@echo "🔨 建置 FastAPI 映像..."
	cd modules/fastapi-api && docker build -t fastapi-api:latest .

# 測試命令
test: test-fastapi
	@echo "✅ 所有測試完成"

test-fastapi:
	@echo "🧪 運行 FastAPI 測試..."
	cd modules/fastapi-api && python -m pytest

# 部署命令
deploy:
	@echo "🚀 部署到 Kubernetes..."
	kubectl apply -k k8s/

clean:
	@echo "🧹 清理 Kubernetes 資源..."
	kubectl delete -k k8s/ --ignore-not-found=true

# 維護命令
status:
	@echo "📊 Kubernetes 狀態："
	kubectl get pods,services -n my-blog-project

logs:
	@echo "📝 Pod 日誌："
	kubectl logs -n my-blog-project -l app=my-blog-project-single --tail=50

# 安裝依賴
install:
	@echo "📦 安裝依賴..."
	@echo "安裝 Jekyll 依賴..."
	cd modules/jekyll-blog && bundle install
	@echo "安裝 FastAPI 依賴..."
	cd modules/fastapi-api && pip install -r requirements.txt

# 更新依賴
update:
	@echo "🔄 更新依賴..."
	@echo "更新 Jekyll 依賴..."
	cd modules/jekyll-blog && bundle update
	@echo "更新 FastAPI 依賴..."
	cd modules/fastapi-api && pip install --upgrade -r requirements.txt

# 清理建置檔案
clean-build:
	@echo "🧹 清理建置檔案..."
	cd modules/jekyll-blog && rm -rf _site .sass-cache
	cd modules/fastapi-api && find . -type d -name __pycache__ -exec rm -rf {} +
	cd modules/fastapi-api && find . -type f -name "*.pyc" -delete

# 完整清理
clean-all: clean clean-build
	@echo "🧹 完整清理完成"
