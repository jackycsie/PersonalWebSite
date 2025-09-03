# 使用官方 Ruby 3.2 映像作為基礎
FROM ruby:3.2-slim

# 安裝系統依賴
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/*

# 設定工作目錄
WORKDIR /app

# 複製 Gemfile 和 Gemfile.lock
COPY Gemfile Gemfile.lock ./

# 安裝 Ruby gems
RUN bundle install

# 複製整個專案
COPY . .

# 建立 Jekyll 網站
RUN bundle exec jekyll build

# 暴露端口
EXPOSE 4000

# 啟動 Jekyll 服務器
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000"]
