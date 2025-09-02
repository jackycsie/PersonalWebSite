# My Blog Project

一個使用 FastAPI 建立的部落格專案。

## 本機啟動步驟

1. 確保已安裝 Docker 和 Docker Compose
2. 建立並啟動服務：
   ```bash
   docker compose build
   docker compose up
   ```
3. 確認服務正常運行：
   瀏覽器開啟 http://localhost:8080/healthz 應該回傳 `{"status":"ok"}`

## 測試方式

在容器內執行測試：
```bash
docker compose exec api pytest
```

測試應該全部通過，確認 `/healthz` 端點正常運作。
