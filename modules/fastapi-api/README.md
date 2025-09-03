# FastAPI API 模組

這是專案的 FastAPI 後端 API 模組，提供 RESTful 服務。

## 🚀 快速開始

### 本地開發
```bash
# 安裝依賴
pip install -r requirements.txt

# 啟動開發伺服器
uvicorn app.main:app --reload --host 0.0.0.0 --port 8080

# 訪問 http://localhost:8080/docs
```

### Docker 開發
```bash
# 建置映像
docker build -t fastapi-api .

# 運行容器
docker run -p 8080:8080 fastapi-api
```

## 📁 目錄結構

```
fastapi-api/
├── app/              # 應用程式代碼
│   ├── __init__.py
│   ├── main.py       # 主應用程式
│   ├── config.py     # 配置
│   ├── models/       # 資料模型
│   ├── schemas/      # 資料驗證
│   ├── routers/      # 路由
│   └── services/     # 業務邏輯
├── requirements.txt   # Python 依賴
└── Dockerfile        # Docker 配置
```

## 🔌 API 端點

### 健康檢查
- `GET /healthz` - 健康狀態檢查

### 文檔
- `GET /docs` - Swagger UI 文檔
- `GET /redoc` - ReDoc 文檔

## 🐳 生產部署

使用 Docker 進行生產部署：

```bash
# 建置生產映像
docker build -t fastapi-api:prod .

# 運行生產容器
docker run -p 8080:8080 fastapi-api:prod
```

## ⚙️ 配置

主要配置在 `app/config.py` 中，包括：
- 資料庫連接
- 環境變數
- 日誌配置
- 安全設定

## 🔧 開發指南

### 新增路由
在 `app/routers/` 目錄下創建新的路由檔案：

```python
from fastapi import APIRouter

router = APIRouter()

@router.get("/example")
async def example_endpoint():
    return {"message": "Hello World"}
```

### 新增模型
在 `app/models/` 目錄下定義資料模型：

```python
from pydantic import BaseModel

class ExampleModel(BaseModel):
    id: int
    name: str
    description: str = None
```

## 🧪 測試

```bash
# 運行測試
pytest

# 運行測試並顯示覆蓋率
pytest --cov=app
```

## 📊 監控

- 健康檢查端點：`/healthz`
- 日誌記錄
- 效能監控
