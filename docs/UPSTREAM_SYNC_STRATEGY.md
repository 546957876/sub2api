# Upstream Sync Strategy

这份文档的目标不是教人“怎么随便 merge 一次”，而是固定本仓库未来长期二开、持续同步 `upstream/main` 的做法，尽量减少冲突、返工和隐藏回归。

## 目标

需要同时满足 3 件事：

1. 持续保留二开能力
2. 能定期同步 `upstream/main`
3. 尽量不让同步过程反复冲突

## 当前结构判断

当前仓库已经做对了一半：

- 二开页面主体大多已经放进 `frontend/src/custom/packs/override/`
- `home` 已经通过 [frontend/src/views/public/HomeRouteEntry.vue](/D:/JS/sub2api/frontend/src/views/public/HomeRouteEntry.vue:1) 走 override 接入
- `/docs`、`/pricing` 已经通过 [frontend/src/custom/active.ts](/D:/JS/sub2api/frontend/src/custom/active.ts:1) 动态注入

这使得未来同步 upstream 时，`custom` 页面主体通常不会和上游直接冲突。

## 真实风险点

不是所有风险都在 `custom/` 目录里。当前真正容易在未来同步时反复冲突的点有：

1. 上游热点接入文件
   - [frontend/src/router/index.ts](/D:/JS/sub2api/frontend/src/router/index.ts:1)
   - [frontend/src/components/layout/AppSidebar.vue](/D:/JS/sub2api/frontend/src/components/layout/AppSidebar.vue:1)
   - [frontend/src/App.vue](/D:/JS/sub2api/frontend/src/App.vue:1)
   - [frontend/src/views/public/HomeRouteEntry.vue](/D:/JS/sub2api/frontend/src/views/public/HomeRouteEntry.vue:1)
   - [frontend/src/custom/active.ts](/D:/JS/sub2api/frontend/src/custom/active.ts:1)

2. 公共语言包
   - [frontend/src/i18n/locales/zh.ts](/D:/JS/sub2api/frontend/src/i18n/locales/zh.ts:1)
   - [frontend/src/i18n/locales/en.ts](/D:/JS/sub2api/frontend/src/i18n/locales/en.ts:1)

3. 本地专用脚本 / 部署文件
   - `script/*.ps1`
   - `package.json`
   - `deploy/*`

## 以后新增二开的硬规则

### 1. 页面主体

新的 UI 二开页面，一律优先放在：

```text
frontend/src/custom/packs/override/views/
```

不要把完整页面主体再写回：

- `frontend/src/views/HomeView.vue`
- `frontend/src/views/admin/*`
- `frontend/src/views/user/*`

除非只是加“稳定接入点”。

### 2. 路由和导航

自定义路由、导航入口，统一通过：

- [frontend/src/custom/active.ts](/D:/JS/sub2api/frontend/src/custom/active.ts:1)
- [frontend/src/custom/packs/override/index.ts](/D:/JS/sub2api/frontend/src/custom/packs/override/index.ts:1)

不要直接把二开页面长期塞回 `router/index.ts` 或 `AppSidebar.vue` 的主体逻辑里。

### 3. 文案

二开新增文案不要继续直接堆进公共语言包。

目标结构：

```text
frontend/src/custom/packs/override/locales/zh.ts
frontend/src/custom/packs/override/locales/en.ts
```

公共 `zh.ts / en.ts` 只保留 upstream 自己的文案和确实属于公共系统的翻译键。

### 4. 本地开发脚本

Windows 本地测试、开发辅助脚本属于 fork 本地能力，应尽量保留在：

- `script/*.ps1`
- 根 `package.json`

同步 upstream 时，默认保护这些文件，不要被上游回滚。

## 推荐同步流程

### A. 永远先同步到 `develop`

```powershell
cd D:\JS\sub2api
git checkout develop
git pull origin develop
git fetch upstream --prune
```

### B. 先看“真实冲突面”

不要一上来就 merge。

先找共同基线：

```powershell
git merge-base develop upstream/main
```

假设得到 `<base>`，再分别列出双方自那以后改过的文件：

```powershell
git diff --name-only <base>..develop > $env:TEMP\local.txt
git diff --name-only <base>..upstream/main > $env:TEMP\upstream.txt
Compare-Object (Get-Content $env:TEMP\local.txt) (Get-Content $env:TEMP\upstream.txt) -IncludeEqual -ExcludeDifferent | Select-Object -ExpandProperty InputObject
```

只处理这份重叠清单，不要被“上游没有 custom 文件”这种假象误导。

### C. 正式 merge

```powershell
git merge upstream/main
```

### D. 优先检查这几类文件

1. `router/index.ts`
2. `AppSidebar.vue`
3. `App.vue`
4. `HomeRouteEntry.vue`
5. `custom/active.ts`
6. `zh.ts / en.ts`
7. `package.json`
8. `script/*.ps1`
9. `deploy/*`

### E. 验证

```powershell
cd D:\JS\sub2api\backend
go test ./...

cd D:\JS\sub2api\frontend
npm.cmd run typecheck
```

再启动本地页面做冒烟验证：

```powershell
cd D:\JS\sub2api
npm.cmd run dev
```

重点看：

- `/home`
- `/pricing`
- `/docs`
- `/admin/usage`
- `/usage`
- `/admin/settings`

### F. 验证通过再推送

```powershell
git push origin develop
```

上线时再按仓库规则把 `develop` 合到 `main`。

## 未来还应继续做的优化

### 优先级最高

1. 把二开新增文案从公共语言包拆到 `custom locales`
2. 给 `custom` 接入层补 smoke tests

### 建议补的测试

至少应覆盖：

1. `/home` 是否正确走 override
2. `/pricing` 路由是否存在
3. `/docs` 路由是否存在
4. custom nav 是否出现在 sidebar / public layout
5. custom locale 是否成功合并

## 原则总结

以后同步 upstream，不追求“零差异”，而追求：

- 上游能力尽量吃到
- 二开主体不回写上游热点文件
- 接入点保持最小
- 冲突集中在少量稳定文件

做到这一点，未来才能持续二开，同时持续对齐 upstream。
