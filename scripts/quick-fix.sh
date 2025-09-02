#!/bin/bash

# 快速修復腳本 - 更新健康檢查配置
set -e

echo "🔧 快速修復健康檢查配置..."

# 檢查 kubectl 連接
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ 無法連接到 Kubernetes 集群"
    exit 1
fi

echo "✅ 連接到 Kubernetes 集群成功"

# 應用修正後的配置
echo "📋 應用修正後的配置..."
kubectl apply -f k8s/deployment.yaml

# 等待部署更新
echo "⏳ 等待部署更新..."
kubectl rollout status deployment/my-blog-project -n my-blog-project --timeout=300s

# 顯示狀態
echo "📊 當前狀態："
kubectl get pods -n my-blog-project -l app=my-blog-project

echo ""
echo "🎉 修復完成！"
echo "📝 使用以下命令監控："
echo "   kubectl get pods -n my-blog-project"
echo "   kubectl logs -n my-blog-project -l app=my-blog-project"
