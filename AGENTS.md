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

## 上游同步建议

上游 `upstream/main` 有更新时，建议优先同步到本地，再根据情况决定是先进入 `develop` 测试，还是直接合入 `main`。

默认推荐：

1. 先同步上游
2. 本地测试
3. 再推到 `origin`
4. 最后更新服务器

## 约束

- 不要把未验证完成的功能直接提交到 `main`
- 非必要不要在服务器上直接改代码
- 与生产无关的试验性修改，优先放在 `develop`
