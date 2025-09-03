#!/bin/bash

# Docker 安裝腳本 - 用於 self-hosted runner
# 適用於 Ubuntu/Debian 系統

set -e

echo "🐳 開始安裝 Docker..."

# 檢查是否已經安裝
if command -v docker &> /dev/null; then
    echo "✅ Docker 已經安裝"
    docker --version
    exit 0
fi

# 更新套件列表
echo "📦 更新套件列表..."
sudo apt-get update

# 安裝必要的套件
echo "🔧 安裝必要套件..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 添加 Docker 的官方 GPG 金鑰
echo "🔑 添加 Docker GPG 金鑰..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 設置穩定版倉庫
echo "📚 設置 Docker 倉庫..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 更新套件列表
echo "📦 更新套件列表..."
sudo apt-get update

# 安裝 Docker Engine
echo "🚀 安裝 Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 啟動 Docker 服務
echo "🔄 啟動 Docker 服務..."
sudo systemctl start docker
sudo systemctl enable docker

# 將當前用戶加入 docker 群組
echo "👤 將用戶加入 docker 群組..."
sudo usermod -aG docker $USER

# 驗證安裝
echo "✅ Docker 安裝完成！"
echo "📊 Docker 版本："
docker --version

echo ""
echo "⚠️  重要提醒："
echo "   您需要重新登入或重新啟動系統，讓群組權限生效"
echo "   或者執行：newgrp docker"
echo ""
echo "🧪 測試 Docker："
echo "   sudo docker run hello-world"
