#!/bin/bash

# 多容器部署腳本
set -e

NAMESPACE="my-blog-project"
DEPLOYMENT_NAME="my-blog-project-multi"
IMAGE_TAG="${1:-latest}"

echo "🚀 開始部署多容器應用 (標籤: $IMAGE_TAG)"

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
kustomize edit set image 728951503024.dkr.ecr.ap-east-2.amazonaws.com/jackycsie-github-io:$IMAGE_TAG

# 應用多容器配置
echo "📋 應用多容器 Kubernetes 配置..."
kubectl apply -k kustomization-multi.yaml

# 等待部署完成
echo "⏳ 等待多容器部署完成..."
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE

# 顯示部署狀態
echo "📊 部署狀態："
echo ""
echo "=== Namespace ==="
kubectl get namespace $NAMESPACE

echo ""
echo "=== Pods ==="
kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME

echo ""
echo "=== Services ==="
kubectl get services -n $NAMESPACE -l app=$DEPLOYMENT_NAME

echo ""
echo "=== Deployments ==="
kubectl get deployments -n $NAMESPACE -l app=$DEPLOYMENT_NAME

echo ""
echo "🎉 多容器部署成功完成！"
echo ""
echo "🌐 訪問方式："
echo "   FastAPI 應用: http://[NODE-IP]:30080"
echo "   Jekyll 網站: http://[NODE-IP]:30081"
echo ""
echo "📝 使用以下命令查看詳細信息："
echo "   kubectl get all -n $NAMESPACE"
echo "   kubectl logs -n $NAMESPACE -l app=$DEPLOYMENT_NAME -c fastapi-app"
echo "   kubectl logs -n $NAMESPACE -l app=$DEPLOYMENT_NAME -c jekyll-site"
