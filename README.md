# token-dashboard-github

GitHub 完整版骨架：
- `main` branch 放網站程式
- `data` branch 放最新 dashboard JSON
- Zeabur 從 `main` branch 部署網站
- 網站前端直接讀 `data` branch 的 JSON
- OpenClaw 這台定時把最新資料 push 到 `data` branch

## 結構
- `public/index.html`：前端頁面
- `Dockerfile`：Zeabur 用
- `scripts/sync-data.sh`：OpenClaw 同步資料到 `data` branch 的腳本
- `scripts/init-data-branch.sh`：初始化 `data` branch 內的 `dashboard/*.json`
- `data-sample/`：`data` branch 初始用的 JSON 樣板
- `.env.example`：同步腳本需要的環境變數範例

## 建立方式
1. 建 GitHub repo，例如 `token-dashboard`
2. 把這個專案內容推到 `main` branch
3. 編輯 `public/index.html` 裡的預設 repo 值，或先用網址參數測試：`?owner=你的帳號&repo=你的repo`
4. 在 GitHub 建 `data` branch，並把 `dashboard/*.json` 初始化進去
   - 可用 `scripts/init-data-branch.sh /path/to/data-branch-working-tree`
5. 讓 Zeabur 連 GitHub 的 `main` branch 部署
6. 在 OpenClaw 這台設定同步腳本需要的環境變數（可參考 `.env.example`）
7. 用 cron 每 20 或 30 分鐘執行一次 `scripts/sync-data.sh`

## 必要環境變數（同步腳本）
- `GITHUB_OWNER`
- `GITHUB_REPO`
- `GITHUB_TOKEN`
- `DATA_BRANCH`（預設 `data`）
- `WORKSPACE`（預設 `/home/node/.openclaw/workspace`）

## 安全建議
- 使用 fine-grained GitHub token
- 權限只給單一 repo 的 contents read/write
- 不要給多餘 scope
- 先完成這次 repo 初始化與部署後，就把目前外洩的舊 token revoke 掉，改成新的最小權限 token

## 最短部署檢查清單
1. `git init -b main`（若 repo 尚未初始化）
2. 提交 `main` branch 內容
3. 建立 `data` branch
4. 用 `scripts/init-data-branch.sh` 放入 `dashboard/*.json`
5. 提交 `data` branch
6. 在 Zeabur 指到 `main`
7. 在同步端設好 `.env` 後執行 `scripts/sync-data.sh`

## 說明
這個方案的優點是：
- 程式與資料分離
- 網站不需要每次 redeploy 才看到新資料
- OpenClaw 只要更新 `data` branch 即可
