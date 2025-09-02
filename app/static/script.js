// Global variables
let currentPage = 1;
let postsPerPage = 6;
let allPosts = [];
let filteredPosts = [];

// Sample article data for testing
const sampleArticles = [
    {
        id: 1,
        title: "FastAPI 與 MongoDB 整合實戰指南",
        summary: "深入探討如何使用 FastAPI 框架與 MongoDB 資料庫進行整合，包含完整的 CRUD 操作實作範例。",
        content: `# FastAPI 與 MongoDB 整合實戰指南

## 前言

FastAPI 是一個現代化的 Python Web 框架，以其高效能和自動 API 文件生成而聞名。MongoDB 則是一個強大的 NoSQL 資料庫，特別適合處理非結構化資料。

## 專案架構

我們的專案將採用以下架構：

\`\`\`python
my_blog_project/
├── app/
│   ├── main.py          # FastAPI 應用程式入口
│   ├── models/          # 資料模型定義
│   ├── schemas/         # Pydantic 驗證模式
│   ├── services/        # 業務邏輯層
│   └── routers/         # API 路由定義
├── requirements.txt     # Python 依賴套件
└── Dockerfile          # 容器化設定
\`\`\`

## 安裝必要套件

首先，我們需要安裝必要的 Python 套件：

\`\`\`bash
pip install fastapi uvicorn motor pymongo
\`\`\`

## 建立資料模型

### 1. MongoDB 連接設定

\`\`\`python
# app/config.py
from motor.motor_asyncio import AsyncIOMotorClient

MONGODB_URL = "mongodb://localhost:27017"
DATABASE_NAME = "blog_db"

async def connect_to_mongo():
    client = AsyncIOMotorClient(MONGODB_URL)
    return client[DATABASE_NAME]
\`\`\`

### 2. 文章模型定義

\`\`\`python
# app/models/article.py
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, Field

class Article(BaseModel):
    id: Optional[str] = Field(None, alias="_id")
    title: str = Field(..., min_length=1, max_length=200)
    summary: Optional[str] = Field(..., max_length=500)
    content: str = Field(..., min_length=1)
    tags: List[str] = Field(default_factory=list)
    category: Optional[str] = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    author: str = Field(default="Anonymous")
    read_count: int = Field(default=0)
\`\`\`

## 總結

本文詳細介紹了 FastAPI 與 MongoDB 的整合實作，包含：

1. **專案架構設計**：清晰的目錄結構和職責分離
2. **資料模型定義**：使用 Pydantic 進行資料驗證
3. **CRUD 操作實作**：完整的增刪改查功能
4. **效能優化**：索引設計和快取機制
5. **錯誤處理**：自定義異常和請求驗證
6. **測試策略**：單元測試和整合測試
7. **部署方案**：Docker 容器化和健康檢查

這個架構可以作為中大型專案的基礎，根據實際需求可以進一步擴展功能。`,
        tags: ["python", "fastapi", "mongodb", "api", "tutorial"],
        category: "technology",
        author: "Jacky Huang",
        created_at: "2024-09-02T10:00:00Z",
        read_count: 156
    },
    {
        id: 2,
        title: "Docker 容器化最佳實踐",
        summary: "分享在實際專案中使用 Docker 的經驗，包含映像檔優化、安全性考量、以及 CI/CD 流程整合。",
        content: `# Docker 容器化最佳實踐

## 前言

Docker 已經成為現代軟體開發不可或缺的工具，它不僅簡化了部署流程，還提供了環境一致性和可移植性。本文將分享我在實際專案中使用 Docker 的經驗和最佳實踐。

## 映像檔優化

### 1. 多階段建置 (Multi-stage Build)

多階段建置可以大幅減少最終映像檔的大小：

\`\`\`dockerfile
# 建置階段
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# 執行階段
FROM node:18-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
\`\`\`

## 總結

Docker 容器化是一個持續改進的過程，需要根據專案需求和團隊經驗不斷優化。`,
        tags: ["docker", "containerization", "devops", "ci-cd", "best-practices"],
        category: "tutorial",
        author: "Jacky Huang",
        created_at: "2024-09-02T09:30:00Z",
        read_count: 89
    }
];

// Simple debug function
function debugLog(message) {
    console.log(`[DEBUG] ${message}`);
}

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    debugLog('DOM loaded, initializing app...');
    
    // Show immediate feedback
    document.body.style.backgroundColor = '#f0f8ff';
    
    try {
        initializeApp();
    } catch (error) {
        console.error('Error initializing app:', error);
        // Show error on page
        showError('應用程式初始化失敗: ' + error.message);
    }
});

function initializeApp() {
    debugLog('Initializing app...');
    
    // Load initial data first
    loadInitialData();
    
    // Set up navigation
    setupNavigation();
    
    // Set up event listeners
    setupEventListeners();
    
    // Show home section by default
    showSection('home');
    
    debugLog('App initialization complete');
}

function loadInitialData() {
    debugLog('Loading initial data...');
    
    // Load sample data
    allPosts = [...sampleArticles];
    filteredPosts = [...allPosts];
    
    debugLog(`Loaded ${allPosts.length} sample articles`);
    
    // Update stats immediately
    updateStats();
    
    // Load home content immediately
    loadHomeContent();
}

function updateStats() {
    debugLog('Updating stats...');
    
    const totalPosts = document.getElementById('totalPosts');
    const totalCategories = document.getElementById('totalCategories');
    const totalTags = document.getElementById('totalTags');
    
    if (totalPosts) {
        totalPosts.textContent = allPosts.length;
        debugLog(`Updated total posts: ${allPosts.length}`);
    }
    
    if (totalCategories) {
        const categories = new Set(allPosts.map(p => p.category));
        totalCategories.textContent = categories.size;
        debugLog(`Updated total categories: ${categories.size}`);
    }
    
    if (totalTags) {
        const tags = new Set(allPosts.flatMap(p => p.tags));
        totalTags.textContent = tags.size;
        debugLog(`Updated total tags: ${tags.size}`);
    }
}

function loadHomeContent() {
    debugLog('Loading home content...');
    
    // Load recent posts
    const recentPostsList = document.getElementById('recentPostsList');
    if (recentPostsList) {
        const recentPosts = allPosts.slice(0, 3); // Show first 3 posts
        debugLog(`Loading ${recentPosts.length} recent posts`);
        
        const postsHTML = recentPosts.map(post => createPostCard(post)).join('');
        recentPostsList.innerHTML = postsHTML;
        
        debugLog('Recent posts loaded successfully');
        debugLog('Posts HTML:', postsHTML);
    } else {
        console.error('Recent posts list element not found');
        showError('找不到最新文章列表元素');
    }
}

function createPostCard(post) {
    debugLog(`Creating post card for: ${post.title}`);
    
    const iconClass = getCategoryIcon(post.category);
    
    return `
        <div class="post-card" onclick="openArticleModal(${post.id})">
            <div class="post-image">
                <i class="${iconClass}"></i>
            </div>
            <div class="post-content">
                <h3 class="post-title">${post.title}</h3>
                <p class="post-summary">${post.summary}</p>
                <div class="post-meta">
                    <span>${formatDate(post.created_at)}</span>
                    <span>${post.read_count} 次閱讀</span>
                </div>
                <div class="post-tags">
                    ${post.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
                </div>
            </div>
        </div>
    `;
}

function getCategoryIcon(category) {
    const iconMap = {
        'technology': 'fas fa-microchip',
        'tutorial': 'fas fa-graduation-cap',
        'experience': 'fas fa-lightbulb',
        'default': 'fas fa-file-alt'
    };
    return iconMap[category] || iconMap.default;
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('zh-TW', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

function setupNavigation() {
    debugLog('Setting up navigation...');
    const navLinks = document.querySelectorAll('.nav-link');
    debugLog(`Found ${navLinks.length} nav links`);
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const section = this.getAttribute('data-section');
            debugLog(`Navigating to section: ${section}`);
            showSection(section);
            
            // Update active state
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

function showSection(sectionName) {
    debugLog(`Showing section: ${sectionName}`);
    
    // Hide all sections
    const contentSections = document.querySelectorAll('.content-section');
    contentSections.forEach(section => {
        section.classList.remove('active');
    });
    
    // Show target section
    const targetSection = document.getElementById(sectionName);
    if (targetSection) {
        targetSection.classList.add('active');
        debugLog(`Section ${sectionName} activated`);
        
        // Load section-specific content
        switch(sectionName) {
            case 'home':
                loadHomeContent();
                break;
            case 'articles':
                loadArticlesContent();
                break;
            case 'about':
                debugLog('About section is static, no loading needed');
                break;
        }
    } else {
        console.error(`Section ${sectionName} not found`);
    }
}

function loadArticlesContent() {
    debugLog('Loading articles content...');
    displayPosts();
}

function displayPosts() {
    debugLog('Displaying posts...');
    
    const postsList = document.getElementById('postsList');
    if (!postsList) {
        console.error('Posts list element not found');
        return;
    }
    
    const startIndex = (currentPage - 1) * postsPerPage;
    const endIndex = startIndex + postsPerPage;
    const pagePosts = filteredPosts.slice(startIndex, endIndex);
    
    debugLog(`Displaying posts ${startIndex + 1}-${endIndex} of ${filteredPosts.length}`);
    
    const postsHTML = pagePosts.map(post => createPostCard(post)).join('');
    postsList.innerHTML = postsHTML;
    
    // Update pagination
    updatePagination();
}

function updatePagination() {
    debugLog('Updating pagination...');
    
    const totalPages = Math.ceil(filteredPosts.length / postsPerPage);
    const pageInfo = document.getElementById('pageInfo');
    const prevBtn = document.getElementById('prevPage');
    const nextBtn = document.getElementById('nextPage');
    
    if (pageInfo) pageInfo.textContent = `第 ${currentPage} 頁，共 ${totalPages} 頁`;
    if (prevBtn) prevBtn.disabled = currentPage === 1;
    if (nextBtn) nextBtn.disabled = currentPage === totalPages;
    
    debugLog(`Pagination updated: page ${currentPage} of ${totalPages}`);
}

function setupEventListeners() {
    debugLog('Setting up event listeners...');
    
    // Pagination
    const prevBtn = document.getElementById('prevPage');
    const nextBtn = document.getElementById('nextPage');
    
    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            if (currentPage > 1) {
                currentPage--;
                displayPosts();
            }
        });
        debugLog('Previous button event listener added');
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            const totalPages = Math.ceil(filteredPosts.length / postsPerPage);
            if (currentPage < totalPages) {
                currentPage++;
                displayPosts();
            }
        });
        debugLog('Next button event listener added');
    }
}

function openArticleModal(postId) {
    debugLog(`Opening article modal for ID: ${postId}`);
    
    const post = allPosts.find(p => p.id === postId);
    if (!post) {
        console.error(`Post with ID ${postId} not found`);
        return;
    }
    
    // Set modal content
    const modalTitle = document.getElementById('modalTitle');
    const modalContent = document.getElementById('modalContent');
    const articleModal = document.getElementById('articleModal');
    
    if (!modalTitle || !modalContent || !articleModal) {
        console.error('Modal elements not found');
        return;
    }
    
    modalTitle.textContent = post.title;
    
    // Simple content display without markdown parsing
    modalContent.innerHTML = `
        <div class="markdown-content">
            <pre style="white-space: pre-wrap; font-family: monospace;">${post.content}</pre>
        </div>
        <div class="article-meta">
            <p><strong>作者：</strong>${post.author}</p>
            <p><strong>分類：</strong>${post.category}</p>
            <p><strong>標籤：</strong>${post.tags.join(', ')}</p>
            <p><strong>發布時間：</strong>${formatDate(post.created_at)}</p>
            <p><strong>閱讀次數：</strong>${post.read_count}</p>
        </div>
    `;
    
    // Show modal
    articleModal.classList.add('show');
    document.body.style.overflow = 'hidden';
    
    debugLog('Article modal opened successfully');
}

function closeArticleModal() {
    debugLog('Closing article modal...');
    
    const articleModal = document.getElementById('articleModal');
    if (articleModal) {
        articleModal.classList.remove('show');
        document.body.style.overflow = 'auto';
        debugLog('Article modal closed');
    }
}

function showError(message) {
    console.error(message);
    
    // Create error display
    const errorDiv = document.createElement('div');
    errorDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #ff4444;
        color: white;
        padding: 20px;
        border-radius: 8px;
        z-index: 10000;
        max-width: 400px;
    `;
    errorDiv.innerHTML = `<strong>錯誤：</strong>${message}`;
    
    document.body.appendChild(errorDiv);
    
    // Remove after 5 seconds
    setTimeout(() => {
        if (errorDiv.parentNode) {
            errorDiv.parentNode.removeChild(errorDiv);
        }
    }, 5000);
}

// Global functions for onclick
window.openArticleModal = openArticleModal;
window.closeArticleModal = closeArticleModal;

// Close modal when clicking outside
window.addEventListener('click', function(event) {
    const articleModal = document.getElementById('articleModal');
    if (event.target === articleModal) {
        closeArticleModal();
    }
});

// Close modal with Escape key
document.addEventListener('keydown', function(event) {
    const articleModal = document.getElementById('articleModal');
    if (event.key === 'Escape' && articleModal && articleModal.classList.contains('show')) {
        closeArticleModal();
    }
});

// Debug info
console.log('Script loaded successfully');
console.log('Sample articles:', sampleArticles);
console.log('DOM ready, script will initialize when DOM is loaded');
