$ErrorActionPreference = "Stop"

$ClaudeBaseUrl = "__ANTHROPIC_BASE_URL__"
$ClaudeCodePackage = "@anthropic-ai/claude-code"
$MinNodeMajor = 22

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
    throw "Claude Code 需要 Node.js $MinNodeMajor+。请先安装后重新运行本脚本。"
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

Say "__SITE_NAME__ Claude Code 交互式配置"
Say ""
Say "接口地址：$ClaudeBaseUrl"
Say "脚本会写入用户级环境变量 ANTHROPIC_BASE_URL、ANTHROPIC_AUTH_TOKEN、CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC。"
Say ""

$ApiKey = Read-Host "请输入 __SITE_NAME__ 的 API 密钥"
if ([string]::IsNullOrWhiteSpace($ApiKey)) {
  throw "API Key 不能为空。"
}

[System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $ClaudeBaseUrl, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $ApiKey, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC", "1", [System.EnvironmentVariableTarget]::User)

$env:ANTHROPIC_BASE_URL = $ClaudeBaseUrl
$env:ANTHROPIC_AUTH_TOKEN = $ApiKey
$env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1"

Say ""
Say "Claude Code 配置已写入当前用户环境变量。"
Say "正在运行的 Claude Code 需要重启后才会读取新配置。"

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Say "未检测到 Claude Code。"
  if (Confirm-Yes "是否使用 npm 安装 Claude Code？" $true) {
    Ensure-Node
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
      throw "未找到 npm，请先安装 Node.js，再执行：npm install -g $ClaudeCodePackage"
    }
    npm install -g $ClaudeCodePackage
  }
} else {
  Say "Claude Code 已安装：$((Get-Command claude).Source)"
}

if (Confirm-Yes "是否立即启动 Claude Code？" $false) {
  if (Get-Command claude -ErrorAction SilentlyContinue) {
    & claude
  } else {
    Say "未找到 claude 命令，请安装后手动运行：claude"
  }
} else {
  Say "已跳过启动。请重开 PowerShell 后运行：claude"
}
