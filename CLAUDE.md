# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目简介

BigBanana AI Director 是一个 AI 驱动的短剧/漫剧一站式生成平台，支持"剧本→资产→分镜→成片"完整工作流。数据完全存储于浏览器本地（IndexedDB + OPFS），无后端服务依赖。

## 常用命令

```bash
# 环境初始化（首次）
./setup.sh

# 启动开发服务器（端口 3010）
npm run dev

# 构建生产版本（含 UTF-8 校验）
npm run build

# 预览构建产物
npm run preview

# 启动独立媒体代理服务（端口 8787，生产环境用）
npm run media-proxy
```

`.env.local` 中配置 `ANTSK_API_KEY`（AI API 密钥）。

## 技术栈注意事项

本项目**不使用** Tailwind CSS、Zustand、React Query、shadcn/ui 等常规依赖。实际技术栈：

- **React 19** + **TypeScript**（非 strict 模式，allowJs: true）
- **Vite 6**（开发服务器端口 3010，路径别名 `@` 指向项目根目录）
- **CSS 变量**驱动主题系统（`--bg-base`、`--text-primary` 等），通过 `data-theme` 属性切换暗/亮色
- **React Context**（无全局状态库）
- **IndexedDB**（数据库名 `BigBananaDB` v3）持久化所有数据

## 高层架构

### 工作流四阶段

路由 `/project/:projectId/episode/:episodeId` 下，按 `episode.stage` 渲染不同 Stage：

| stage | 组件 | 职责 |
|---|---|---|
| `script` | `StageScript` | AI 剧本解析、分镜脚本生成 |
| `assets` | `StageAssets` | 角色/场景/道具图像生成 |
| `director` | `StageDirector` | 关键帧管理、九宫格分镜、视频生成 |
| `export` | `StageExport` | 时间轴预览、渲染追踪、ZIP 导出 |
| `prompts` | `StagePrompts` | 提示词模板管理 |

### 目录职责

```
components/           # UI 组件（按 Stage 分子目录）
services/             # 业务逻辑
  ai/                 # AI 核心服务（apiCore → scriptService/visualService/videoService/shotService）
  adapters/           # API 协议适配（chat/image/video 三种协议）
contexts/             # React Context（ProjectContext、ThemeContext）
hooks/                # 自定义 Hooks
types.ts              # 全局核心类型（根目录）
types/model.ts        # 模型相关类型
constants/            # 常量（links、model）
server/               # 媒体代理 Node.js 服务（生产用）
```

### 数据层

- **IndexedDB**：5 个 object store：`projects`、`assetLibrary`、`seriesProjects`、`series`、`episodes`
- **图像存储**：base64 编码存入 IndexedDB
- **视频存储**：OPFS（Origin Private File System），`videoStorageService.ts` 管理
- **数据迁移**：`services/migrationService.ts` 处理版本升级

### AI 服务分层

```
aiService.ts（门面，re-export）
  └── services/ai/
        ├── apiCore.ts          # API Key 管理、重试、多 Provider 路由
        ├── scriptService.ts    # 剧本解析、分镜生成
        ├── visualService.ts    # 图像生成
        ├── videoService.ts     # 视频生成（Veo 同步 / Sora 异步）
        └── shotService.ts      # 分镜辅助

services/adapters/              # 协议适配层
        ├── chatAdapter.ts      # OpenAI-compatible chat
        ├── imageAdapter.ts     # Gemini 图像 API
        └── videoAdapter.ts     # Veo / Sora 视频 API
```

### 媒体代理

跨域媒体资源通过内置代理解决：
- **开发**：Vite 插件中间件（`vite.config.ts` 中的 `createDevMediaProxyPlugin`），路由 `/api/media-proxy`
- **生产**：独立 Node.js 服务 + Nginx 反代

### 状态管理

`ProjectContext`（`contexts/ProjectContext.tsx`）是核心状态容器，管理：
- `SeriesProject`、`Series`、`Episode` 层级数据
- 角色/场景/道具跨 Episode 同步（`characterSyncService.ts`）
- 全局资产库（`assetLibraryService.ts`）

### 组件组织规范

每个 Stage 目录结构：
```
StageXxx/
  index.tsx          # 主组件入口
  SomeSubComponent.tsx
  constants.ts       # 本地常量
  utils.ts           # 本地工具函数
```

## 构建注意事项

- `npm run build` 会先执行 `scripts/check-utf8.mjs`（UTF-8 合规校验），失败则中止构建
- Vite chunk 手动分割：`react`、`icons`（lucide-react）、`zip`（jszip）单独打包
- 路径别名 `@` → 项目根目录（非 `src/`）
