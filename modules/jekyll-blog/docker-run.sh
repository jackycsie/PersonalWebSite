#!/bin/bash

# 個人網站 Docker 運行腳本
echo "🚀 啟動 Jacky 的個人技術網站..."

# 檢查 Docker 是否安裝
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安裝，請先安裝 Docker"
    exit 1
fi

# 檢查 Docker Compose 是否安裝
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安裝，請先安裝 Docker Compose"
    exit 1
fi

# 停止現有容器
echo "🛑 停止現有容器..."
docker-compose down

# 建置並啟動容器
echo "🔨 建置並啟動容器..."
docker-compose up --build -d

# 等待服務啟動
echo "⏳ 等待服務啟動..."
sleep 10

# 檢查服務狀態
echo "📊 檢查服務狀態..."
docker-compose ps

echo ""
echo "🎉 網站已啟動！"
echo "📍 Jekyll 開發服務器: http://localhost:4000"
echo "🌐 Nginx 生產服務器: http://localhost:80"
echo ""
echo "📝 常用命令："
echo "  查看日誌: docker-compose logs -f"
echo "  停止服務: docker-compose down"
echo "  重新建置: docker-compose up --build -d"
echo ""
