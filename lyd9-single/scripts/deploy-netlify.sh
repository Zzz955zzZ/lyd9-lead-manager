#!/usr/bin/env bash
# Netlify 本地一键发布（备选方案，非必须）
# 前置：export NETLIFY_AUTH_TOKEN=xxx          （Netlify → User settings → Access tokens）
#       export NETLIFY_SITE_ID=xxx            （建好 site 后在 Site settings → API ID）
set -euo pipefail
echo "▶ 正在发布到 Netlify ..."
npx netlify deploy --prod --dir=. --auth "$NETLIFY_AUTH_TOKEN" --site "$NETLIFY_SITE_ID"
echo "✅ 完成。"
