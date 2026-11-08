#!/usr/bin/env bash
# Cloudflare Pages 本地一键发布（备选方案，非必须）
# 前置：export CLOUDFLARE_API_TOKEN=xxx   （Cloudflare → My Profile → API Tokens，需 Pages 编辑权限）
#       export CLOUDFLARE_ACCOUNT_ID=xxx  （右侧账号信息里）
set -euo pipefail
echo "▶ 正在用 wrangler 发布到 Cloudflare Pages ..."
npx wrangler pages deploy . --project-name lyd9-lead-manager
echo "✅ 完成。稍候几秒即可在分配的 *.pages.dev 域名访问。"
