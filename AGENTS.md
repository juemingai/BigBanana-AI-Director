# Repository Guidelines

## Project Structure & Module Organization
This public repository is a documentation and deployment entrypoint for BigBanana AI Director. Keep changes scoped to the existing top-level layout:

- `README.md`, `README_EN.md`, `README_JA.md`: primary product and deployment docs in Chinese, English, and Japanese.
- `docker-compose.yaml`: the supported local deployment path using official images.
- `images/`: screenshots, QR code assets, and reference visuals used by the READMEs.
- `LICENSE*`: licensing files for distribution.

Do not introduce app source directories unless the repository scope changes. Prefer updating docs, compose config, and assets in place.

## Build, Test, and Development Commands
This repo does not include a local frontend build pipeline. Use Docker Compose for validation:

- `docker-compose up -d`: start the published services locally.
- `docker-compose logs -f`: inspect container startup and runtime logs.
- `docker-compose pull && docker-compose up -d --force-recreate`: refresh to the latest published images.
- `docker-compose down`: stop the local stack.

When changing documentation only, verify Markdown rendering and linked asset paths before opening a PR.

## Coding Style & Naming Conventions
Keep Markdown concise, product-facing, and aligned across all language variants. Use ATX headings (`#`, `##`) and short paragraphs. For assets, use descriptive names that match their UI content, for example `images/项目管理.png`.

For YAML edits, use 2-space indentation, keep service names lowercase kebab-case, and group related environment variables together. Avoid adding unused compose options.

## Testing Guidelines
There is no automated unit or E2E test suite in this public snapshot. Validation is manual:

- run `docker-compose config` after editing `docker-compose.yaml`
- start the stack locally for deployment-related changes
- open the updated README files and confirm image links resolve

If you add a new verification step, document it in the relevant README.

## Commit & Pull Request Guidelines
Recent history uses short, focused updates around image versions, README edits, and asset refreshes. Keep commits similarly narrow and descriptive. Prefer Conventional Commits, such as `docs: update deployment instructions` or `chore: bump compose image tags`.

PRs should include:

- a short summary of the user-facing change
- affected files or languages (`README_EN.md`, `docker-compose.yaml`, `images/`)
- screenshots when docs or assets change
- local verification performed, for example `docker-compose config`

## Security & Configuration Tips
Do not commit real API keys or private service endpoints. Keep secrets in environment variables such as `DASHSCOPE_API_KEY`, and use placeholder values in documentation.
