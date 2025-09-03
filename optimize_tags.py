#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
優化 Jekyll 文章標籤
"""

import os
import re
from pathlib import Path
from collections import defaultdict

# 標籤映射表 - 舊標籤 -> 新標籤
TAG_MAPPING = {
    # 合併相似標籤
    "aws-ec2": "aws",
    "aws-lambda": "aws",
    "k8s": "kubernetes",
    "kubeadm": "kubernetes",
    "kubectl": "kubernetes",
    "meidum": "medium",
    "github-pages": "github",
    
    # 標準化格式
    "deep-learning": "machine-learning",
    "deepvariant": "bioinformatics",
    "netflow": "workflow",
    "nfs-server": "storage",
    "memorydb": "database",
    "documentdb": "database",
    "elasticache": "cache",
    "elb": "load-balancer",
    "sns": "messaging",
    "ecg": "medical-ai",
    "resnet": "cnn",
    "v100": "gpu",
    "jetson-nano": "edge-computing",
    "tensorrt": "ai-optimization",
    "cpython": "python",
    "multiprocess": "parallel-computing",
    "multithread": "parallel-computing",
    "paramiko": "ssh",
    "crawler": "web-scraping",
    "hashable": "data-structure",
    "cprofile": "performance",
    "numba": "performance",
    "axel": "download-tools",
    "filesystem": "storage",
    "containers": "containerization",
    "podman": "containerization",
    "ansible": "automation",
    "mlflow": "mlops",
    "jupyter": "data-science",
    "big-data": "data-engineering",
    "llama-3": "llm",
    "google-gemini": "ai-api",
    "notion": "productivity",
    "color-blindness": "accessibility",
    "business-model-innovation": "business",
    "subscription": "business",
    "scrum": "agile",
    "biology": "bioinformatics",
    "gene": "bioinformatics",
    "paper": "research",
    "life": "personal",
    "technology": "tech",
    "schedule": "workflow",
    "backup": "devops",
    "convert": "tools",
    "automotive": "industry",
    "storage": "infrastructure",
    "gpu": "hardware",
    "tensorflow": "machine-learning",
    "data-science": "analytics",
    "workflow": "automation",
    "hdfs": "distributed-storage",
    "hadoop": "big-data",
    "ubuntu": "linux",
    "ec2": "aws",
    "netflow": "workflow",
    "ecg": "medical-ai",
    "cnn": "deep-learning",
    "jekyll": "static-site",
    "ruby": "programming-language",
    "cloud": "cloud-computing",
    "automation": "devops",
    "machine-learning": "ai",
    "ai": "artificial-intelligence"
}

# 為沒有標籤的文章添加標籤
MISSING_TAGS = {
    "2019-01-19-c04fee852539.md": ["data-science", "analytics", "business"],
    "2019-01-15-f555d1eb6e34.md": ["data-science", "analytics", "business"],
    "2019-01-24-de47a58680d5.md": ["data-science", "analytics", "business"]
}

def normalize_tag(tag):
    """標準化標籤格式"""
    # 轉換為小寫
    tag = tag.lower()
    # 替換空格為連字號
    tag = re.sub(r'\s+', '-', tag)
    # 移除特殊字符
    tag = re.sub(r'[^a-z0-9\-]', '', tag)
    # 移除多餘的連字號
    tag = re.sub(r'-+', '-', tag)
    # 移除開頭和結尾的連字號
    tag = tag.strip('-')
    return tag

def update_tags_in_file(file_path):
    """更新單個檔案的標籤"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        try:
            with open(file_path, 'r', encoding='latin-1') as f:
                content = f.read()
        except:
            print(f"無法讀取檔案: {file_path}")
            return False
    
    original_content = content
    updated = False
    
    # 檢查是否需要添加標籤
    filename = Path(file_path).name
    if filename in MISSING_TAGS:
        # 尋找 tags: 行
        tags_match = re.search(r'^tags:\s*\[.*?\]', content, re.MULTILINE)
        if tags_match:
            # 替換現有的空標籤
            new_tags = '[' + ', '.join(f'"{tag}"' for tag in MISSING_TAGS[filename]) + ']'
            content = re.sub(r'^tags:\s*\[.*?\]', f'tags: {new_tags}', content, flags=re.MULTILINE)
            updated = True
            print(f"✅ 為 {filename} 添加標籤: {MISSING_TAGS[filename]}")
    
    # 更新現有標籤
    tags_match = re.search(r'^tags:\s*\[(.*?)\]', content, re.MULTILINE)
    if tags_match:
        tags_str = tags_match.group(1)
        old_tags = []
        for tag in tags_str.split(','):
            tag = tag.strip().strip('"\'')
            if tag:
                old_tags.append(tag)
        
        if old_tags:
            new_tags = []
            for tag in old_tags:
                # 應用標籤映射
                if tag in TAG_MAPPING:
                    new_tag = TAG_MAPPING[tag]
                    new_tags.append(new_tag)
                    print(f"🔄 標籤映射: {tag} -> {new_tag}")
                else:
                    # 標準化格式
                    normalized_tag = normalize_tag(tag)
                    if normalized_tag != tag:
                        new_tags.append(normalized_tag)
                        print(f"🔧 標準化標籤: {tag} -> {normalized_tag}")
                    else:
                        new_tags.append(tag)
            
            # 去重並排序
            new_tags = sorted(list(set(new_tags)))
            
            # 更新檔案內容
            new_tags_str = '[' + ', '.join(f'"{tag}"' for tag in new_tags) + ']'
            content = re.sub(r'^tags:\s*\[.*?\]', f'tags: {new_tags_str}', content, flags=re.MULTILINE)
            updated = True
    
    # 寫入更新後的內容
    if updated and content != original_content:
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        except Exception as e:
            print(f"❌ 寫入檔案失敗 {file_path}: {e}")
            return False
    
    return False

def optimize_all_tags():
    """優化所有文章的標籤"""
    posts_dir = Path("jekyll-site/_posts")
    
    if not posts_dir.exists():
        print("找不到 _posts 目錄")
        return
    
    updated_files = 0
    total_files = 0
    
    print("🚀 開始優化文章標籤...")
    print("=" * 60)
    
    # 遍歷所有文章
    for post_file in posts_dir.rglob("*.md"):
        if post_file.name.startswith('.'):
            continue
        
        total_files += 1
        print(f"\n📝 處理: {post_file.name}")
        
        if update_tags_in_file(post_file):
            updated_files += 1
    
    print("\n" + "=" * 60)
    print("✅ 標籤優化完成！")
    print(f"📊 總檔案數: {total_files}")
    print(f"🔄 更新檔案數: {updated_files}")
    print(f"📈 更新率: {updated_files/total_files*100:.1f}%")
    
    # 顯示標籤統計
    print("\n📋 新的標籤分類建議:")
    print("🏷️  技術類: python, aws, kubernetes, docker, git, api")
    print("☁️  雲端類: cloud-computing, aws, serverless, load-balancer")
    print("🤖 AI/ML類: artificial-intelligence, machine-learning, deep-learning, cnn")
    print("🔄 DevOps類: automation, devops, ci-cd, workflow")
    print("💾 資料類: data-engineering, analytics, database, storage")
    print("🔬 研究類: bioinformatics, research, medical-ai")
    print("💼 商業類: business, productivity, agile")

if __name__ == "__main__":
    optimize_all_tags()
