#!/bin/bash

# 部署腳本 - 自動清理並重新部署
set -e

# 配置變數
NAMESPACE="default"
DEPLOYMENT_NAME="my-blog-project"
SERVICE_NAME="my-blog-project"
ECR_REGISTRY="728951503024.dkr.ecr.ap-east-2.amazonaws.com"
ECR_REPOSITORY="my-blog-project"
IMAGE_TAG="${1:-latest}"  # 允許傳入標籤，預設為 latest

echo "🚀 開始部署 $DEPLOYMENT_NAME (標籤: $IMAGE_TAG)"

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

# 清理已存在的資源
echo "🧹 檢查並清理已存在的資源..."

# 檢查並刪除已存在的 service
if kubectl get service $SERVICE_NAME -n $NAMESPACE &> /dev/null; then
    echo "🗑️  刪除已存在的 service: $SERVICE_NAME"
    kubectl delete service $SERVICE_NAME -n $NAMESPACE
    echo "⏳ 等待 service 完全刪除..."
    sleep 5
else
    echo "ℹ️  service $SERVICE_NAME 不存在，跳過刪除"
fi

# 檢查並刪除已存在的 deployment
if kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE &> /dev/null; then
    echo "🗑️  刪除已存在的 deployment: $DEPLOYMENT_NAME"
    kubectl delete deployment $DEPLOYMENT_NAME -n $NAMESPACE
    echo "⏳ 等待 deployment 完全刪除..."
    sleep 10
else
    echo "ℹ️  deployment $DEPLOYMENT_NAME 不存在，跳過刪除"
fi

# 檢查 ECR secret 是否存在
if ! kubectl get secret ecr-secret -n $NAMESPACE &> /dev/null; then
    echo "⚠️  ECR secret 不存在，請先運行 GitHub Actions 或手動創建"
    echo "   或者使用 kubectl 手動創建 ECR secret"
fi

echo "✅ 資源清理完成"

# 使用配置文件部署
if [ -f "k8s-deployment.yaml" ]; then
    echo "📋 使用 k8s-deployment.yaml 配置文件部署..."
    
    # 更新配置文件中的映像標籤
    sed -i.bak "s|image:.*|image: $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG|" k8s-deployment.yaml
    
    # 應用配置
    kubectl apply -f k8s-deployment.yaml -n $NAMESPACE
    
    # 恢復原始配置文件
    mv k8s-deployment.yaml.bak k8s-deployment.yaml
else
    echo "📋 使用 kubectl 命令部署..."
    
    # 創建 deployment
    kubectl create deployment $DEPLOYMENT_NAME \
        --image=$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG \
        --port=8080 \
        -n $NAMESPACE
    
    # 添加 imagePullSecrets 到 deployment
    kubectl patch deployment $DEPLOYMENT_NAME \
        -p '{"spec":{"template":{"spec":{"imagePullSecrets":[{"name":"ecr-secret"}]}}}}' \
        -n $NAMESPACE
    
    # 創建 service
    kubectl expose deployment $DEPLOYMENT_NAME \
        --port=80 \
        --target-port=8080 \
        --type=LoadBalancer \
        -n $NAMESPACE
fi

echo "✅ 部署完成！"

# 等待部署完成
echo "⏳ 等待部署完成..."
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE

# 顯示部署狀態
echo "📊 部署狀態："
kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME
kubectl get services -n $NAMESPACE -l app=$DEPLOYMENT_NAME

echo "🎉 部署成功完成！"
echo "📝 使用以下命令查看詳細信息："
echo "   kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME"
echo "   kubectl get services -n $NAMESPACE -l app=$DEPLOYMENT_NAME"
echo "   kubectl logs -n $NAMESPACE -l app=$DEPLOYMENT_NAME"
