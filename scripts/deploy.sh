#!/bin/bash

# 部署腳本 - 使用 Kustomize 進行模組化部署
set -e

NAMESPACE="my-blog-project"
IMAGE_TAG="${1:-latest}"

echo "🚀 開始部署 my-blog-project (標籤: $IMAGE_TAG)"

# 檢查 kubectl 是否可用
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl 未安裝或不在 PATH 中"
    exit 1
fi

# 檢查集群連接
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ 無法連接到 Kubernetes 集群"
    exit 1
fi

echo "✅ 連接到 Kubernetes 集群成功"

# 切換到 k8s 目錄
cd k8s

# 更新映像標籤
echo "🏷️  更新映像標籤為: $IMAGE_TAG"
kustomize edit set image 728951503024.dkr.ecr.ap-east-2.amazonaws.com/my-blog-project:$IMAGE_TAG

# 應用所有配置
echo "📋 應用 Kubernetes 配置..."
kubectl apply -k .

# 等待部署完成
echo "⏳ 等待部署完成..."
kubectl rollout status deployment/my-blog-project -n $NAMESPACE

# 顯示部署狀態
echo "📊 部署狀態："
echo ""
echo "=== Namespace ==="
kubectl get namespace $NAMESPACE

echo ""
echo "=== Pods ==="
kubectl get pods -n $NAMESPACE -l app=my-blog-project

echo ""
echo "=== Services ==="
kubectl get services -n $NAMESPACE -l app=my-blog-project

echo ""
echo "=== Deployments ==="
kubectl get deployments -n $NAMESPACE -l app=my-blog-project

echo ""
echo "🎉 部署成功完成！"
echo "📝 使用以下命令查看詳細信息："
echo "   kubectl get all -n $NAMESPACE"
echo "   kubectl logs -n $NAMESPACE -l app=my-blog-project"
echo "   kubectl describe deployment my-blog-project -n $NAMESPACE"
