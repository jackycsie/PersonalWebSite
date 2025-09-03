.PHONY: help build up down logs clean dev prod restart

# 預設目標
help:
	@echo "🐳 Jacky 個人技術網站 - Docker 管理"
	@echo ""
	@echo "可用命令："
	@echo "  make build    - 建置 Docker 映像"
	@echo "  make up       - 啟動生產環境 (Jekyll + Nginx)"
	@echo "  make dev      - 啟動開發環境 (僅 Jekyll)"
	@echo "  make down     - 停止所有服務"
	@echo "  make logs     - 查看服務日誌"
	@echo "  make clean    - 清理 Docker 資源"
	@echo "  make restart  - 重新啟動服務"
	@echo "  make help     - 顯示此說明"

# 建置映像
build:
	@echo "🔨 建置 Docker 映像..."
	docker-compose build

# 啟動生產環境
up:
	@echo "🚀 啟動生產環境..."
	docker-compose up -d
	@echo "✅ 生產環境已啟動！"
	@echo "📍 Jekyll: http://localhost:4000"
	@echo "🌐 Nginx:  http://localhost:80"

# 啟動開發環境
dev:
	@echo "🚀 啟動開發環境..."
	docker-compose -f docker-compose.dev.yml up -d
	@echo "✅ 開發環境已啟動！"
	@echo "📍 網站: http://localhost:4000"
	@echo "🔄 即時重新載入已啟用"

# 停止服務
down:
	@echo "🛑 停止所有服務..."
	docker-compose down
	docker-compose -f docker-compose.dev.yml down
	@echo "✅ 所有服務已停止"

# 查看日誌
logs:
	@echo "📋 查看服務日誌..."
	docker-compose logs -f

# 查看開發環境日誌
logs-dev:
	@echo "📋 查看開發環境日誌..."
	docker-compose -f docker-compose.dev.yml logs -f

# 清理 Docker 資源
clean:
	@echo "🧹 清理 Docker 資源..."
	docker system prune -f
	docker volume prune -f
	@echo "✅ 清理完成"

# 重新啟動服務
restart:
	@echo "🔄 重新啟動服務..."
	make down
	make up

# 重新啟動開發環境
restart-dev:
	@echo "🔄 重新啟動開發環境..."
	docker-compose -f docker-compose.dev.yml down
	make dev

# 建置並啟動生產環境
build-up:
	@echo "🔨 建置並啟動生產環境..."
	docker-compose up --build -d
	@echo "✅ 生產環境已啟動！"

# 建置並啟動開發環境
build-dev:
	@echo "🔨 建置並啟動開發環境..."
	docker-compose -f docker-compose.dev.yml up --build -d
	@echo "✅ 開發環境已啟動！"

# 進入容器
shell:
	@echo "🐚 進入 Jekyll 容器..."
	docker-compose exec jekyll-site /bin/bash

# 進入開發容器
shell-dev:
	@echo "🐚 進入開發容器..."
	docker-compose -f docker-compose.dev.yml exec jekyll-site /bin/bash

# 重新建置網站
rebuild-site:
	@echo "🔨 重新建置網站..."
	docker-compose exec jekyll-site bundle exec jekyll build
	@echo "✅ 網站重新建置完成"

# 狀態檢查
status:
	@echo "📊 檢查服務狀態..."
	docker-compose ps
	@echo ""
	@echo "📊 開發環境狀態..."
	docker-compose -f docker-compose.dev.yml ps
