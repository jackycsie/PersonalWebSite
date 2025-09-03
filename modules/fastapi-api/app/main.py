from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os

app = FastAPI(title="My Blog Project", version="1.0.0")

# Mount static files
app.mount("/static", StaticFiles(directory="app/static"), name="static")

@app.get("/")
async def root():
    """Serve the main HTML page"""
    return FileResponse("app/static/index.html")

@app.get("/healthz")
async def health_check():
    """Health check endpoint"""
    return {"status": "ok"}

