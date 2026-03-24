#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

MODE="${1:-dev}"

log() {
  printf '[start] %s\n' "$1"
}

fail() {
  printf '[start] 错误: %s\n' "$1" >&2
  exit 1
}

command -v npm >/dev/null 2>&1 || fail "未检测到 npm，请先运行 ./setup.sh。"
[ -d "node_modules" ] || fail "未找到 node_modules，请先运行 ./setup.sh。"

case "$MODE" in
  dev)
    log "启动 Vite 开发服务器，地址默认是 http://localhost:3010"
    log "开发模式已内置 /api/media-proxy，无需额外启动代理。"
    exec npm run dev
    ;;
  proxy)
    log "启动独立媒体代理，默认地址是 http://localhost:8787"
    exec npm run media-proxy
    ;;
  preview)
    log "启动生产预览服务器。若需要媒体代理，请另开终端执行 ./start.sh proxy"
    exec npm run preview
    ;;
  *)
    fail "不支持的模式: $MODE。可用模式: dev | proxy | preview"
    ;;
esac
