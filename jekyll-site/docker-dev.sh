#!/bin/bash

# 個人網站 Docker 開發版本運行腳本
echo "🚀 啟動 Jacky 的個人技術網站 (開發模式)..."

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
docker-compose -f docker-compose.dev.yml down

# 建置並啟動容器
echo "🔨 建置並啟動開發容器..."
docker-compose -f docker-compose.dev.yml up --build -d

# 等待服務啟動
echo "⏳ 等待服務啟動..."
sleep 15

# 檢查服務狀態
echo "📊 檢查服務狀態..."
docker-compose -f docker-compose.dev.yml ps

echo ""
echo "🎉 開發網站已啟動！"
echo "📍 網站地址: http://localhost:4000"
echo "🔄 即時重新載入已啟用"
echo ""
echo "📝 常用命令："
echo "  查看日誌: docker-compose -f docker-compose.dev.yml logs -f"
echo "  停止服務: docker-compose -f docker-compose.dev.yml down"
echo "  重新建置: docker-compose -f docker-compose.dev.yml up --build -d"
echo ""
echo "💡 提示：修改 Markdown 檔案後，網站會自動重新載入！"
