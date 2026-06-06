# AGENTS

## 分支约定

本仓库采用以下最小分支策略：

- `main`
  - 作为**生产分支**
  - 服务器正式环境默认从 `main` 拉取并部署
  - 只允许合并已经完成开发、测试通过、确认可上线的内容

- `develop`
  - 作为**开发分支**
  - 新功能、UI 优化、实验性改动、重构、临时测试，默认都先在 `develop` 进行
  - 不确定是否上线的内容，不要直接进入 `main`

## 日常工作流

### 1. 开发

默认在 `develop` 上工作：

```bash
git checkout develop
git pull origin develop
```

如 `develop` 不存在，则先创建：

```bash
git checkout -b develop
git push -u origin develop
```

### 2. 功能完成后

在本地验证通过后，再把 `develop` 合并到 `main`：

```bash
git checkout main
git pull origin main
git merge develop
git push origin main
```

### 3. 服务器部署

服务器正式环境只跟随 `main`：

```bash
cd ~/sub2api
./deploy/update-fork.sh
```

### 4. Windows 本地测试版 EXE

本地如需保留旧的 `backend/sub2api.exe`，同时测试新的 Windows 可执行文件，统一使用：

```bash
cd D:\JS\sub2api
npm.cmd run build:sub2api2
```

输出文件：

```bash
D:\JS\sub2api\backend\sub2api2.exe
```

仅启动已编译好的测试版：

```bash
cd D:\JS\sub2api
npm.cmd run run:sub2api2
```

一键重新编译并启动：

```bash
cd D:\JS\sub2api
npm.cmd run start:sub2api2
```

说明：

- `sub2api2.exe` 用于本地测试，不覆盖旧的 `sub2api.exe`
- 本地测试版采用 `embed` 构建，支持直接访问前端页面
- 本地测试版不使用 `-trimpath`，避免 Windows 下 `Asia/Shanghai` 时区报错

### 5. 前端二开隔离层

前端二开的**首要目标**不是“先把页面改出来”，而是：

- 未来继续同步 `upstream/main` 时，**尽量减少冲突**
- 减少因为二开散落在上游文件里而带来的合并错误、回归和隐藏 BUG

为了实现这一点，前端默认采用“二开隔离层”策略。

自定义前端代码优先放在：

```bash
frontend/src/custom/
```

当前约定的主二开包目录为：

```bash
frontend/src/custom/packs/override/
```

这里的 `override` 含义不是品牌名，而是：

- 这是对上游前端的**覆盖层**
- 目标是把二开代码与上游代码分开
- 方便后续同步 `upstream/main` 时减少冲突
- 这是当前前端二开的**默认落点**

#### 允许放在隔离层的内容

- 自定义路由
- 自定义侧边栏菜单
- 自定义页面（例如新的 `/home`、`/pricing`）
- 后续必要的页面 override 入口

当前约定示例：

- `/home` 的自定义版本应放在：

```bash
frontend/src/custom/packs/override/views/
```

- `/pricing` 这类明确属于二开自己新写的页面，也应放在：

```bash
frontend/src/custom/packs/override/views/
```

不要继续长期保留在上游原始 `frontend/src/views/` 目录中。

#### 不应放在隔离层的内容

- 本来就可以通过后台“系统设置”完成的站点配置
- 例如：站点名、站点 Logo、文档链接、公告内容等

这些应继续优先通过后台配置完成，而不是重新硬编码进 `custom` 层。

#### 开发约束

- 不要使用品牌名给二开隔离层目录命名
- 能通过 `frontend/src/custom/` 承接的 UI 二开，不要继续散落回上游目录
- 只有“接入点”本身才允许少量修改上游热点文件
- 新的 UI 二开需求，默认先判断能否放进 `override` 层；不要先去改上游原始页面
- 如果一个页面已经明确属于“我们自己新写/长期自定义”的页面（例如 `/home`、`/pricing`），页面主体应保留在 `override/views/`，不要再回写到上游 `frontend/src/views/`
- 修改上游热点文件时，目标应该是“增加稳定接入点”，而不是继续把业务/UI 细节堆进去

#### 尽量少直接改的上游热点文件

以下文件后续仍可能被上游频繁更新，非必要不要长期直接写业务逻辑进去：

- `frontend/src/router/index.ts`
- `frontend/src/components/layout/AppSidebar.vue`
- `frontend/src/views/HomeView.vue`
- `frontend/src/views/KeyUsageView.vue`
- `frontend/src/views/admin/UsageView.vue`
- `frontend/src/views/admin/AccountsView.vue`

原则：

- 如需新增页面/入口，优先通过 `frontend/src/custom/` 接入
- 能放在 `custom` 的，不要继续散落回上游目录
- 如需同步上游更新，优先保护这些接入点的稳定性，而不是在上游热点文件里反复手工补丁

## 上游同步建议

上游 `upstream/main` 有更新时，建议优先同步到本地，再根据情况决定是先进入 `develop` 测试，还是直接合入 `main`。

默认推荐：

1. 先同步上游
2. 本地测试
3. 再推到 `origin`
4. 最后更新服务器

### 上游同步前的固定检查

未来同步 `upstream/main` 时，不要直接凭感觉 merge，先固定执行一次：

```bash
cd D:\JS\sub2api
npm.cmd run sync:upstream:check
```

如果你希望把“检测到重叠文件就停止”作为硬门槛，统一使用：

```bash
cd D:\JS\sub2api
npm.cmd run sync:upstream:guard
```

这两个命令会先抓取 `upstream` 最新状态，再输出：

- 当前分支 / upstream 提交
- 当前共同基线
- 本地与 upstream 的 ahead / behind
- 自共同基线以来双方都改过的重叠文件
- 是否命中同步热点文件

#### 当前约定的同步热点文件

以下文件即使已经做了二开隔离，未来仍应优先检查，因为它们是“接入点”而不是“页面主体”：

- `frontend/src/router/index.ts`
- `frontend/src/components/layout/AppSidebar.vue`
- `frontend/src/App.vue`
- `frontend/src/views/public/HomeRouteEntry.vue`
- `frontend/src/custom/active.ts`
- `frontend/src/i18n/locales/zh.ts`
- `frontend/src/i18n/locales/en.ts`
- `package.json`
- `script/*.ps1`
- `deploy/*`

#### 二开新增内容放置规则

- 新页面主体继续优先放在 `frontend/src/custom/packs/override/views/`
- 自定义导航 / 自定义路由继续通过 `frontend/src/custom/active.ts` 和 `frontend/src/custom/packs/override/index.ts` 接入
- 二开新增文案继续优先放在 `frontend/src/custom/packs/override/locales/`
- 不要把新的二开页面主体长期回写到上游热点文件里

## 约束

- 不要把未验证完成的功能直接提交到 `main`
- 非必要不要在服务器上直接改代码
- 与生产无关的试验性修改，优先放在 `develop`
