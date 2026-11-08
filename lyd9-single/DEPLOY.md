# LYD9 LEAD MANAGER — 自动化部署说明

单文件问卷系统（`index.html`）的自动化上线方案。目标：**改完代码 → `git push` → 自动上线**，几乎零人工操作。

---

## 一、方案总览（最自动化路径）

```
本地改 index.html / 配置
        │  git push origin main
        ▼
GitHub 仓库（触发 Actions）
        │  自动运行 .github/workflows/deploy.yml
        ▼
自动发布到 GitHub Pages
        │
        ▼
公网可访问：https://<用户名>.github.io/<仓库名>/
        │
        ▼
后台「设置 → 展会入口二维码」自动按当前地址生成可扫码图 → 打印/摆摊
```

**为什么选 GitHub Pages（Actions）作为主方案**：它复用 GitHub 自带的 `GITHUB_TOKEN`，
**不需要你在仓库里配置任何额外密钥或变量**，是"最少人工操作"的自动化部署。
单一静态 HTML 文件无需构建步骤，所以流水线极简、几乎不会失败。

---

## 二、触发机制

| 触发条件 | 行为 |
|---|---|
| `git push` 到 `main` 分支 | 自动运行部署工作流，几秒~1 分钟内上线 |
| 在 GitHub → Actions → 本工作流点 "Run workflow" | 手动触发一次部署（用于重跑） |

- 并发保护：同一时刻只允许一个部署在跑（`concurrency.cancel-in-progress: true`），避免重复推送时互相覆盖。
- 部署状态可在仓库 **Actions** 标签页实时查看；失败会邮件通知仓库所有者。

---

## 三、关键配置（已就绪，无需再改）

| 文件 | 作用 |
|---|---|
| `.github/workflows/deploy.yml` | 主部署流水线：检出 → 配置 Pages → 打包 → 发布 |
| `.nojekyll` | 关闭 GitHub Pages 的 Jekyll 处理（防止忽略 `_` 开头文件） |
| `netlify.toml` | 备选：Netlify "Import from Git" 自动部署配置 |
| `wrangler.toml` | 备选：Cloudflare Pages 配置 |
| `scripts/deploy-cloudflare.sh` / `deploy-netlify.sh` | 备选：本地一条命令发布（需自备令牌） |

工作流权限已设为 `pages: write` + `id-token: write`，这是 Pages 部署的硬性要求，已内置。

---

## 四、首次激活（仅第一次需要人工，之后全自动）

> 以下只需做一次。完成后，日常只需 `git push`。

1. **在 GitHub 新建一个仓库**（建议名 `lyd9-lead-manager`，Public 或 Private 均可）。
2. **把本目录推上去**（需要你的 GitHub 令牌/PAT）：
   ```bash
   git remote add origin https://github.com/<你的用户名>/lyd9-lead-manager.git
   git push -u origin main
   ```
   > 推送后会自动触发第一次部署。
3. **开启 Pages**：仓库 → **Settings → Pages → Build and deployment → Source** 选
   **"GitHub Actions"**（选了 Actions 后，上面那条流水线就会接管发布）。
4. **等 1 分钟**，访问 `https://<用户名>.github.io/lyd9-lead-manager/` 即可看到问卷。

> 自定义域名（如 `lead.lyd9.studio`）：在 Settings → Pages → Custom domain 里填，
> 并按提示加一条 CNAME 解析即可；与自动化部署不冲突。

---

## 五、日常更新（全自动）

改完 `index.html` 或任何配置后：

```bash
git add -A
git commit -m "调整问卷字段 / 文案"
git push
```

推送即上线，无需任何额外操作。二维码（见下）指向的地址不变，已打印的物料继续有效。

---

## 六、让客户扫码进入（二维码）

- 系统内置「展会入口二维码」面板：**后台 → 设置 → 展会入口二维码**，
  它会用当前页面地址（`location.origin + location.pathname`，即问卷首页、不含 `#admin`）
  自动生成可扫码图，并可一键复制链接。
- ⚠️ 前提：页面必须已经按第四节部署到公网。本地双击 `file:///...` 打开时生成的二维码客户扫不开。
- 部署后把这个二维码下载/截图，打印摆到展位即可；客户扫码 → 打开公网问卷 → 填写。

---

## 七、备选托管（如需更快/CDN/自定义域名）

三者都是"连 Git 仓库后自动部署"，与上面的触发机制完全一致，只是换发布目标：

- **Netlify**：把仓库连到 Netlify（Import from Git），`netlify.toml` 已配好，自动部署。
- **Cloudflare Pages**：把仓库连到 Cloudflare Pages（框架选 None、输出目录 `.`），`wrangler.toml` 已配好，自动部署；欧洲节点多、马德里访问快。
- **本地一键发布**（不连 Git 也行）：设好对应令牌后运行
  `bash scripts/deploy-cloudflare.sh` 或 `bash scripts/deploy-netlify.sh`。

> 若改用备选平台，把 `.github/workflows/deploy.yml` 留着也无妨（它只在 GitHub Pages 环境生效）；
> 也可以直接在对应平台控制台断开/忽略该工作流。

---

## 八、数据说明（重要）

- 本单文件版数据默认存在**浏览器本地（localStorage）**，适合单台设备（如展会平板）收集后导出 CSV。
- 若需**多台设备汇总**：后台 → 设置 → 填一个远程保存地址（如 Google Apps Script / SheetDB），
  每次提交会额外 POST 一份 JSON 过去，无需自建服务器。该地址与部署平台无关。
- 客户个人资料不会随静态站点泄露（数据只在提交设备的浏览器里，除非你配置了远程地址）。
