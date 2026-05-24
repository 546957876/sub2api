[CmdletBinding()]
param(
  [int]$BackendPort = 18081,
  [int]$FrontendPort = 3001,
  [string]$BackendHost = "127.0.0.1"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$backendDir = Join-Path $repoRoot "backend"
$frontendDir = Join-Path $repoRoot "frontend"

function Test-PortInUse {
  param([int]$Port)

  $listener = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue
  return $null -ne $listener
}

if (-not (Get-Command go -ErrorAction SilentlyContinue)) {
  throw "go command not found. Install Go first."
}

if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
  throw "pnpm command not found. Install pnpm first."
}

if (Test-PortInUse -Port $BackendPort) {
  throw "Backend port $BackendPort is already in use."
}

if (Test-PortInUse -Port $FrontendPort) {
  throw "Frontend port $FrontendPort is already in use."
}

$backendCommand = @"
`$Host.UI.RawUI.WindowTitle = 'Sub2API Backend Dev'
Set-Location '$backendDir'
`$env:SERVER_HOST = '$BackendHost'
`$env:SERVER_PORT = '$BackendPort'
go run .\cmd\server\
"@

Write-Host "Starting backend on http://$($BackendHost):$BackendPort ..." -ForegroundColor Cyan
Start-Process -FilePath "powershell.exe" `
  -ArgumentList "-NoExit", "-Command", $backendCommand `
  -WorkingDirectory $backendDir `
  -WindowStyle Normal

Set-Location $frontendDir
$env:VITE_DEV_PROXY_TARGET = "http://localhost:$BackendPort"
$env:VITE_DEV_PORT = "$FrontendPort"

Write-Host "Starting frontend on http://localhost:$FrontendPort ..." -ForegroundColor Cyan
Write-Host "Proxy target: $env:VITE_DEV_PROXY_TARGET" -ForegroundColor DarkGray
Write-Host "A separate backend window was opened. Close that window to stop the backend." -ForegroundColor DarkGray

pnpm dev
