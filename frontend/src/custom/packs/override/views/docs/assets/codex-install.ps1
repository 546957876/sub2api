$ErrorActionPreference = "Stop"

$CodexBaseUrl = "__CODEX_BASE_URL__"
$CodexPackage = "@openai/codex"
$MinNodeMajor = 22

$CodexHome = Join-Path $HOME ".codex"
$ConfigFile = Join-Path $CodexHome "config.toml"
$AuthFile = Join-Path $CodexHome "auth.json"

function Say([string]$Message) {
  Write-Host $Message
}

function Confirm-Yes([string]$Prompt, [bool]$DefaultYes = $false) {
  $suffix = if ($DefaultYes) { "[Y/n]" } else { "[y/N]" }
  $answer = Read-Host "$Prompt $suffix"
  if ([string]::IsNullOrWhiteSpace($answer)) {
    return $DefaultYes
  }
  return @("y", "yes") -contains $answer.Trim().ToLowerInvariant()
}

function Get-NodeMajor {
  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    return $null
  }
  $version = (& node -v 2>$null)
  if ($version -match '^v?(\d+)\.') {
    return [int]$Matches[1]
  }
  return $null
}

function Ensure-Node {
  $major = Get-NodeMajor
  if ($null -ne $major -and $major -ge $MinNodeMajor) {
    Say "Node.js 已满足要求：$(& node -v)"
    return
  }

  if ($null -eq $major) {
    Say "未检测到 Node.js。"
  } else {
    Say "当前 Node.js 版本 $(& node -v) 低于 v$MinNodeMajor。"
  }

  if (-not (Confirm-Yes "是否使用 winget 安装稳定版 Node.js LTS？" $true)) {
    throw "Codex 需要 Node.js $MinNodeMajor+。请先安装后重新运行本脚本。"
  }

  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "未找到 winget，请手动安装 Node.js $MinNodeMajor+ 后重新运行本脚本。"
  }

  winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
  $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
  $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
  $env:Path = "$machinePath;$userPath"

  $major = Get-NodeMajor
  if ($null -eq $major -or $major -lt $MinNodeMajor) {
    throw "安装后仍未检测到符合要求的 Node.js，请重开 PowerShell 后重新运行本脚本。"
  }
}

function Backup-IfExists([string]$Path) {
  if (Test-Path $Path) {
    $stamp = Get-Date -Format "yyyyMMddHHmmss"
    $backup = "$Path.bak.$stamp"
    Copy-Item $Path $backup
    Say "已备份现有文件：$backup"
  }
}

function Write-CodexConfig {
  if (-not (Test-Path $CodexHome)) {
    New-Item -ItemType Directory -Path $CodexHome -Force | Out-Null
  }
  Backup-IfExists $ConfigFile
  $content = @'
model_provider = "OpenAI"
model = "gpt-5.5"
review_model = "gpt-5.5"
model_reasoning_effort = "xhigh"
disable_response_storage = true
network_access = "enabled"
windows_wsl_setup_acknowledged = true

[model_providers.OpenAI]
name = "OpenAI"
base_url = "__CODEX_BASE_URL__"
wire_api = "responses"
requires_openai_auth = true

[features]
goals = true
'@
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($ConfigFile, $content, $utf8NoBom)
}

function Write-CodexAuth([string]$ApiKey) {
  if (-not (Test-Path $CodexHome)) {
    New-Item -ItemType Directory -Path $CodexHome -Force | Out-Null
  }
  Backup-IfExists $AuthFile
  $payload = [ordered]@{ OPENAI_API_KEY = $ApiKey }
  $json = $payload | ConvertTo-Json -Depth 5
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($AuthFile, $json + "`n", $utf8NoBom)
}

Say "__SITE_NAME__ Codex 交互式配置"
Say ""
Say "接口地址：$CodexBaseUrl"
Say "脚本会写入 $ConfigFile 与 $AuthFile。"
Say ""

Say "请选择要在哪个 Codex 客户端中使用："
Say "1) Codex CLI"
Say "2) Codex 桌面版 App"
Say "直接回车：Codex CLI 和 Codex 桌面版 App 都使用"
$UsageTarget = Read-Host "请输入序列号 [直接回车=全部]"
if (-not ([string]::IsNullOrWhiteSpace($UsageTarget) -or $UsageTarget.Trim() -in @("1", "2"))) {
  throw "无效选择：$UsageTarget"
}
$UsageTarget = $UsageTarget.Trim()
Say ""

$ApiKey = Read-Host "请输入 __SITE_NAME__ 的 API 密钥"
if ([string]::IsNullOrWhiteSpace($ApiKey)) {
  throw "API Key 不能为空。"
}

Write-CodexConfig
Write-CodexAuth -ApiKey $ApiKey

Say ""
Say "Codex 配置已写入："
Say "  - $ConfigFile"
Say "  - $AuthFile"

if ($UsageTarget -eq "2") {
  Say "配置已写入，现在彻底退出 Codex App，并重新启动 Codex App 即可生效！"
  exit 0
}

if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
  Say "未检测到 Codex CLI。"
  if (Confirm-Yes "是否使用 npm 安装 Codex？" $true) {
    Ensure-Node
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
      throw "未找到 npm，请先安装 Node.js，再执行：npm install -g $CodexPackage"
    }
    npm install -g $CodexPackage
  }
} else {
  Say "Codex 已安装：$((Get-Command codex).Source)"
}

if (Confirm-Yes "是否立即启动 Codex？" $false) {
  if (Get-Command codex -ErrorAction SilentlyContinue) {
    & codex
  } else {
    Say "未找到 codex 命令，请安装后手动运行：codex"
  }
} else {
  Say "已跳过启动。请重开 PowerShell 后运行：codex"
}

Say "现在 Codex CLI 和 App 均已生效！"
