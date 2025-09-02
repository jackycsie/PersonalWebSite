# 開發工作流程

## 分支策略

- **`dev`**: 開發分支，用於日常開發和測試
- **`main`**: 主分支，用於生產環境部署

## 工作流程

### 1. 日常開發 (dev branch)

```bash
# 確保在 dev 分支
git checkout dev

# 進行開發和修改
# ... 修改程式碼 ...

# 提交變更
git add .
git commit -m "feat: 新增功能描述"

# 推送到 dev 分支 (會觸發 CI)
git push origin dev
```

### 2. 合併到 main 分支

```bash
# 切換到 main 分支
git checkout main

# 拉取最新變更
git pull origin main

# 合併 dev 分支
git merge dev

# 推送到 main 分支
git push origin main
```

### 3. 切換回 dev 分支繼續開發

```bash
git checkout dev
```

## CI/CD

- 每次 push 到 `dev` 或 `main` 分支都會自動觸發 CI
- CI 會執行：
  - Python 測試 (pytest)
  - Docker 建置測試
  - Docker Compose 服務測試
  - 健康檢查端點測試

## 注意事項

- 開發時請使用 `dev` 分支
- 只有確認功能穩定後才合併到 `main` 分支
- 每次 push 都會自動執行 CI 測試
- 如果 CI 失敗，請檢查錯誤並修復後再次 push
