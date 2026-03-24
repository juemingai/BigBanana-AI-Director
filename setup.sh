#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

MIN_NODE_MAJOR=20
ENV_FILE=".env.local"
ENV_EXAMPLE_FILE=".env.example"

log() {
  printf '[setup] %s\n' "$1"
}

fail() {
  printf '[setup] 错误: %s\n' "$1" >&2
  exit 1
}

command -v node >/dev/null 2>&1 || fail "未检测到 node，请先安装 Node.js ${MIN_NODE_MAJOR}+。"
command -v npm >/dev/null 2>&1 || fail "未检测到 npm，请先安装 npm。"

NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")"
if [ "$NODE_MAJOR" -lt "$MIN_NODE_MAJOR" ]; then
  fail "当前 Node.js 版本过低: $(node -v)。请升级到 Node.js ${MIN_NODE_MAJOR}+。"
fi

log "检测到 Node.js $(node -v)"
log "检测到 npm $(npm -v)"

if [ ! -f "$ENV_FILE" ]; then
  if [ -f "$ENV_EXAMPLE_FILE" ]; then
    cp "$ENV_EXAMPLE_FILE" "$ENV_FILE"
    log "已创建 $ENV_FILE，请按需填写 ANTSK_API_KEY。"
  else
    cat > "$ENV_FILE" <<'EOF'
ANTSK_API_KEY=your_api_key_here
VITE_MEDIA_PROXY_ENDPOINT=/api/media-proxy
VITE_MEDIA_PROXY_ENABLED=true
EOF
    log "未找到 $ENV_EXAMPLE_FILE，已生成默认 $ENV_FILE。"
  fi
else
  log "$ENV_FILE 已存在，跳过创建。"
fi

log "开始安装依赖..."
npm install

log "环境准备完成。"
log "启动开发环境请执行: ./start.sh"
