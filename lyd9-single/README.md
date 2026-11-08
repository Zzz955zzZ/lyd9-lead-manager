# LYD9 LEAD MANAGER · 单文件展会客户问卷系统

一个自包含的 HTML 文件（`index.html`）：中西双语单页问卷 + 自动评分/分级 + 自动分配
+ 客户编号 + 微信二维码展示 + 本地存储 + CSV 导出 + 简易管理后台。手机优先、无侧边竖线。

## 快速使用
- 直接双击 `index.html` 即可在电脑预览；手机端请把文件部署后扫码访问（见部署）。
- 后台：浏览器地址后加 `#admin`（或点右上角 ↗），默认密码 `lyd9`，可在设置修改。
- 设置里上传 LYD9 / Luna / Dan / Jenni 四个微信二维码（绝不虚构），并填远程汇总地址。

## 部署（自动化）
`git push` 即自动上线，详见 **[DEPLOY.md](./DEPLOY.md)**。
主方案为 GitHub Pages（GitHub Actions），无需额外密钥；另附 Netlify / Cloudflare Pages 配置。

## 目录
```
index.html                  # 交付物：整个系统（内联 CSS/JS）
DEPLOY.md                   # 自动化部署说明（步骤/触发/配置）
.github/workflows/deploy.yml# 主部署流水线
netlify.toml / wrangler.toml# 备选平台配置
scripts/                    # 备选：本地一键发布脚本
```
