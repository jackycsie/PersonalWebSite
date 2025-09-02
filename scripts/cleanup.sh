#!/bin/bash

# 清理腳本 - 刪除所有相關資源
set -e

NAMESPACE="my-blog-project"

echo "🧹 開始清理 Kubernetes 資源..."

# 檢查命名空間是否存在
if kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
    echo "🗑️  刪除命名空間: $NAMESPACE"
    echo "   這將刪除命名空間中的所有資源..."
    
    # 刪除命名空間（這會刪除其中的所有資源）
    kubectl delete namespace $NAMESPACE
    
    echo "⏳ 等待命名空間完全刪除..."
    # 等待命名空間完全刪除
    while kubectl get namespace $NAMESPACE >/dev/null 2>&1; do
        echo "   仍在刪除中..."
        sleep 5
    done
    
    echo "✅ 命名空間 $NAMESPACE 已完全刪除"
else
    echo "ℹ️  命名空間 $NAMESPACE 不存在，無需清理"
fi

echo "🎉 清理完成！"
