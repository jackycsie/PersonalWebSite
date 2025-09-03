# 🐳 Docker 設置指南 - 解決 "Unable to locate executable file: docker" 錯誤

## 問題描述

在 GitHub Actions 中執行 `aws-actions/amazon-ecr-login@v2` 時出現以下錯誤：

```
Error: Unable to locate executable file: docker. Please verify either the file path exists or the file can be found within a directory specified by the PATH environment variable.
```

## 原因分析

這個錯誤通常發生在以下情況：

1. **Self-hosted runner 上沒有安裝 Docker**
2. **Docker 不在 PATH 環境變數中**
3. **Docker 服務沒有啟動**
4. **權限問題**

## 解決方案

### 方案 1：在 Self-hosted Runner 上安裝 Docker（推薦）

如果您使用的是 self-hosted runner，請在該機器上執行以下步驟：

#### 1.1 使用自動安裝腳本

```bash
# 下載並執行安裝腳本
chmod +x scripts/install-docker.sh
./scripts/install-docker.sh
```

#### 1.2 手動安裝 Docker

```bash
# 更新套件列表
sudo apt-get update

# 安裝必要套件
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 添加 Docker GPG 金鑰
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 設置 Docker 倉庫
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安裝 Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 啟動 Docker 服務
sudo systemctl start docker
sudo systemctl enable docker

# 將用戶加入 docker 群組
sudo usermod -aG docker $USER
```

#### 1.3 驗證安裝

```bash
# 檢查 Docker 版本
docker --version

# 測試 Docker
sudo docker run hello-world

# 檢查 Docker 服務狀態
sudo systemctl status docker
```

### 方案 2：使用 GitHub-hosted Runner

如果您不想在 self-hosted runner 上安裝 Docker，可以修改工作流程使用 GitHub-hosted runner：

#### 2.1 修改工作流程

將 `runs-on: self-hosted` 改為 `runs-on: ubuntu-latest`：

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest  # 使用 GitHub-hosted runner
```

#### 2.2 使用修復版工作流程

我已經為您創建了修復版的工作流程：`.github/workflows/cd-single-fixed.yml`

### 方案 3：檢查 PATH 和權限

#### 3.1 檢查 Docker 路徑

```bash
# 查找 Docker 可執行文件
which docker
whereis docker

# 檢查 PATH 環境變數
echo $PATH
```

#### 3.2 檢查權限

```bash
# 檢查 Docker 服務權限
sudo systemctl status docker

# 檢查用戶群組
groups $USER

# 重新載入群組權限
newgrp docker
```

## 常見問題

### Q1：安裝後仍然找不到 Docker 命令

**解決方法：**
```bash
# 重新登入或重新啟動系統
# 或者執行：
newgrp docker

# 檢查 PATH
echo $PATH
which docker
```

### Q2：權限被拒絕

**解決方法：**
```bash
# 確保用戶在 docker 群組中
sudo usermod -aG docker $USER

# 重新啟動 Docker 服務
sudo systemctl restart docker

# 檢查權限
ls -la /var/run/docker.sock
```

### Q3：Docker 服務無法啟動

**解決方法：**
```bash
# 檢查 Docker 服務狀態
sudo systemctl status docker

# 查看詳細錯誤日誌
sudo journalctl -u docker.service

# 重新啟動服務
sudo systemctl restart docker
```

## 驗證步驟

安裝完成後，請執行以下步驟驗證：

1. **檢查 Docker 版本**
   ```bash
   docker --version
   ```

2. **測試 Docker 功能**
   ```bash
   sudo docker run hello-world
   ```

3. **檢查 Docker 服務**
   ```bash
   sudo systemctl status docker
   ```

4. **測試 ECR 登入**
   ```bash
   aws ecr get-login-password --region ap-east-2 | docker login --username AWS --password-stdin 728951503024.dkr.ecr.ap-east-2.amazonaws.com
   ```

## 注意事項

1. **安全性**：將用戶加入 docker 群組會給予該用戶 root 權限，請謹慎使用
2. **權限**：安裝後需要重新登入或重新啟動系統讓群組權限生效
3. **防火牆**：確保防火牆允許 Docker 相關端口
4. **磁碟空間**：Docker 會佔用大量磁碟空間，請確保有足夠空間

## 相關文件

- [Docker 官方安裝指南](https://docs.docker.com/engine/install/)
- [GitHub Actions Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [AWS ECR 登入指南](https://docs.aws.amazon.com/ecr/latest/userguide/registry_auth.html)
