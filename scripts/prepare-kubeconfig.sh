#!/bin/bash

# 準備 kubeconfig 用於 GitHub Actions
# 這個腳本會幫助您準備 kubeconfig 文件並生成 base64 編碼

set -e

echo "🔧 準備 kubeconfig 用於 GitHub Actions..."

# 檢查 kubeconfig 是否存在
if [ ! -f ~/.kube/config ]; then
    echo "❌ 找不到 kubeconfig 文件 (~/.kube/config)"
    echo "請先配置 kubectl 連接到您的 EC2 Kubernetes 集群"
    exit 1
fi

echo "✅ 找到 kubeconfig 文件"

# 檢查 kubectl 連接
echo "🔍 檢查 kubectl 連接..."
if ! kubectl cluster-info > /dev/null 2>&1; then
    echo "❌ kubectl 無法連接到集群"
    echo "請檢查您的 kubeconfig 配置"
    exit 1
fi

echo "✅ kubectl 連接正常"

# 顯示集群信息
echo ""
echo "📊 集群信息："
kubectl cluster-info

echo ""
echo "🖥️  節點信息："
kubectl get nodes

echo ""
echo "📁 命名空間："
kubectl get namespaces

# 生成 base64 編碼的 kubeconfig
echo ""
echo "🔐 生成 base64 編碼的 kubeconfig..."
KUBE_CONFIG_B64=$(cat ~/.kube/config | base64 -w 0)

echo ""
echo "📋 請將以下內容添加到 GitHub Secrets："
echo ""
echo "Secret 名稱: KUBE_CONFIG_DATA"
echo "Secret 值:"
echo "$KUBE_CONFIG_B64"
echo ""

# 保存到文件
echo "$KUBE_CONFIG_B64" > kubeconfig-base64.txt
echo "✅ base64 編碼已保存到 kubeconfig-base64.txt"

echo ""
echo "📝 下一步操作："
echo "1. 複製上面的 base64 編碼內容"
echo "2. 在 GitHub 倉庫的 Settings > Secrets and variables > Actions 中添加新的 secret"
echo "3. Secret 名稱設為: KUBE_CONFIG_DATA"
echo "4. Secret 值設為上面的 base64 編碼內容"
echo "5. 推送代碼觸發部署"
