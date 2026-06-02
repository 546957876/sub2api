#!/usr/bin/env bash
set -euo pipefail

CLAUDE_BASE_URL="__ANTHROPIC_BASE_URL__"
CLAUDE_CODE_PKG="@anthropic-ai/claude-code"
MIN_NODE_MAJOR=22
INSTALL_NODE_VERSION="lts/*"
NVM_INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh"
TARGET_USER="${SUDO_USER:-$(id -un)}"
TARGET_HOME="$HOME"
TARGET_SHELL="${SHELL:-/bin/bash}"

if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
  if command -v getent >/dev/null 2>&1; then
    TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
    TARGET_SHELL="$(getent passwd "$TARGET_USER" | cut -d: -f7)"
  else
    TARGET_HOME="$(eval "printf '%s' ~$TARGET_USER")"
  fi
fi

[ -n "$TARGET_HOME" ] || TARGET_HOME="$HOME"
[ -n "$TARGET_SHELL" ] || TARGET_SHELL="/bin/bash"

if ! { exec 3</dev/tty; } 2>/dev/null; then
  exec 3<&0
fi

say() {
  printf '%s\n' "$*"
}

attach_terminal_stdin() {
  if [ -r /dev/tty ]; then
    exec </dev/tty
  fi
}

target_group() {
  id -gn "$TARGET_USER" 2>/dev/null || printf '%s' "$TARGET_USER"
}

fix_target_ownership() {
  if [ "$(id -u)" -eq 0 ] && [ "$TARGET_USER" != "root" ]; then
    chown -R "$TARGET_USER:$(target_group)" "$@" 2>/dev/null || true
  fi
}

shell_quote() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"
}

run_target_bash() {
  local script="$1"
  if [ "$(id -u)" -eq 0 ] && [ "$TARGET_USER" != "root" ] && command -v sudo >/dev/null 2>&1; then
    sudo -H -u "$TARGET_USER" env HOME="$TARGET_HOME" bash -lc "$script"
  else
    HOME="$TARGET_HOME" bash -lc "$script"
  fi
}

target_env_args() {
  printf 'HOME=%s\0' "$TARGET_HOME"
  if [ -n "${ANTHROPIC_BASE_URL:-}" ]; then
    printf 'ANTHROPIC_BASE_URL=%s\0' "$ANTHROPIC_BASE_URL"
  fi
  if [ -n "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
    printf 'ANTHROPIC_AUTH_TOKEN=%s\0' "$ANTHROPIC_AUTH_TOKEN"
  fi
  if [ -n "${CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC:-}" ]; then
    printf 'CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=%s\0' "$CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC"
  fi
}

exec_target_command() {
  local command_name="$1"
  attach_terminal_stdin
  if [ "$(id -u)" -eq 0 ] && [ "$TARGET_USER" != "root" ] && command -v sudo >/dev/null 2>&1; then
    local env_args=()
    while IFS= read -r -d '' item; do
      env_args+=("$item")
    done < <(target_env_args)
    exec sudo -H -u "$TARGET_USER" env "${env_args[@]}" bash -lc "export NVM_DIR=\"\$HOME/.nvm\"; [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"; command -v nvm >/dev/null 2>&1 && nvm use --silent default >/dev/null 2>&1 || true; exec $(shell_quote "$command_name")"
  fi

  load_target_node_env
  if command -v "$command_name" >/dev/null 2>&1; then
    exec "$command_name"
  fi
  return 1
}

read_input() {
  local var_name="$1"
  local prompt="$2"
  read -r -u 3 -p "$prompt" "$var_name"
}

confirm_yes() {
  local prompt="$1"
  local default_yes="${2:-no}"
  local answer
  read_input answer "$prompt"
  if [ -z "$answer" ]; then
    [ "$default_yes" = "yes" ]
    return
  fi
  case "$answer" in
    y|Y|yes|YES|Yes) return 0 ;;
    *) return 1 ;;
  esac
}

detect_shell_rc() {
  case "${TARGET_SHELL##*/}" in
    zsh)
      printf '%s/.zshrc' "$TARGET_HOME"
      return
      ;;
    bash)
      printf '%s/.bashrc' "$TARGET_HOME"
      return
      ;;
  esac
  if [ -n "${ZSH_VERSION:-}" ]; then
    printf '%s/.zshrc' "$TARGET_HOME"
    return
  fi
  if [ -n "${BASH_VERSION:-}" ]; then
    printf '%s/.bashrc' "$TARGET_HOME"
    return
  fi
  case "$(uname -s 2>/dev/null || true)" in
    Darwin) printf '%s/.zshrc' "$TARGET_HOME" ;;
    *) printf '%s/.profile' "$TARGET_HOME" ;;
  esac
}

persist_export() {
  local rc_file="$1"
  local key="$2"
  local value="$3"

  touch "$rc_file"
  if command -v sed >/dev/null 2>&1; then
    if [ "$(uname -s 2>/dev/null || true)" = "Darwin" ]; then
      sed -i '' "/^[[:space:]]*export[[:space:]]\\{1,\\}${key}=/d" "$rc_file" 2>/dev/null || true
    else
      sed -i "/^[[:space:]]*export[[:space:]]\\{1,\\}${key}=/d" "$rc_file" 2>/dev/null || true
    fi
  fi
  local escaped_value
  escaped_value=$(printf "%s" "$value" | sed "s/'/'\\\\''/g")
  printf "\n# __SITE_NAME__ Claude Code\nexport %s='%s'\n" "$key" "$escaped_value" >> "$rc_file"
  fix_target_ownership "$rc_file"
}

load_target_node_env() {
  export NVM_DIR="$TARGET_HOME/.nvm"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$NVM_DIR/nvm.sh"
    command -v nvm >/dev/null 2>&1 && nvm use --silent default >/dev/null 2>&1 || true
  fi
}

current_node_version() {
  load_target_node_env
  if command -v node >/dev/null 2>&1; then
    node -v 2>/dev/null
    return
  fi
  if [ "$(id -u)" -eq 0 ] && [ "$TARGET_USER" != "root" ]; then
    run_target_bash 'export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; command -v nvm >/dev/null 2>&1 && nvm use --silent default >/dev/null 2>&1 || true; command -v node >/dev/null 2>&1 && node -v' 2>/dev/null || true
  fi
}

current_node_major() {
  local version
  version="$(current_node_version || true)"
  if [ -n "$version" ]; then
    printf '%s\n' "$version" | sed 's/^v//' | cut -d. -f1
  fi
}

ensure_nvm_loaded() {
  export NVM_DIR="$TARGET_HOME/.nvm"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$NVM_DIR/nvm.sh"
    command -v nvm >/dev/null 2>&1 && nvm use --silent default >/dev/null 2>&1 || true
  fi
}

ensure_nvm_init_in_rc() {
  local rc_file="$1"
  local marker="# >>> __SITE_NAME__ nvm init >>>"
  if grep -qF "$marker" "$rc_file" 2>/dev/null; then
    return
  fi
  cat >> "$rc_file" <<'EOF'

# >>> __SITE_NAME__ nvm init >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/nvm.sh" ] && nvm use --silent default >/dev/null 2>&1 || true
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# <<< __SITE_NAME__ nvm init <<<
EOF
  fix_target_ownership "$rc_file"
}

auto_install_node_via_nvm() {
  local rc_file="$1"
  if ! command -v curl >/dev/null 2>&1; then
    say "未找到 curl，无法自动安装 nvm。请先安装 Node.js $MIN_NODE_MAJOR+ 后重试。"
    exit 1
  fi

  if [ "$(id -u)" -eq 0 ] && [ "$TARGET_USER" != "root" ]; then
    say "正在为 $TARGET_USER 安装 nvm..."
    run_target_bash "set -e; export NVM_DIR=\"\$HOME/.nvm\"; if [ ! -s \"\$NVM_DIR/nvm.sh\" ]; then curl -fsSL $(shell_quote "$NVM_INSTALL_URL") | bash; fi; . \"\$NVM_DIR/nvm.sh\"; nvm install $(shell_quote "$INSTALL_NODE_VERSION"); nvm alias default $(shell_quote "$INSTALL_NODE_VERSION"); nvm use default"
    ensure_nvm_loaded
    ensure_nvm_init_in_rc "$rc_file"
    return
  fi

  export NVM_DIR="$TARGET_HOME/.nvm"
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    say "正在安装 nvm..."
    curl -fsSL "$NVM_INSTALL_URL" | bash
  fi
  ensure_nvm_loaded
  if ! command -v nvm >/dev/null 2>&1; then
    say "nvm 加载失败，请重开终端后重试，或手动安装 Node.js $MIN_NODE_MAJOR+。"
    exit 1
  fi

  say "正在安装稳定版 Node.js LTS..."
  nvm install "$INSTALL_NODE_VERSION"
  nvm alias default "$INSTALL_NODE_VERSION"
  nvm use default
  ensure_nvm_init_in_rc "$rc_file"
}

ensure_node() {
  local rc_file="$1"
  local major
  local version
  major="$(current_node_major || true)"
  if [ -n "$major" ] && [ "$major" -ge "$MIN_NODE_MAJOR" ]; then
    version="$(current_node_version || true)"
    say "Node.js 已满足要求：$version"
    return
  fi

  if [ -z "$major" ]; then
    say "未检测到 Node.js。"
  else
    version="$(current_node_version || true)"
    say "当前 Node.js 版本 ${version:-未知} 低于 v$MIN_NODE_MAJOR。"
  fi

  if ! confirm_yes "是否自动安装稳定版 Node.js LTS？[Y/n]: " yes; then
    say "Claude Code 需要 Node.js $MIN_NODE_MAJOR+。请先安装后重新运行本脚本。"
    exit 1
  fi

  auto_install_node_via_nvm "$rc_file"

  major="$(current_node_major || true)"
  if [ -z "$major" ] || [ "$major" -lt "$MIN_NODE_MAJOR" ]; then
    say "安装后仍未检测到符合要求的 Node.js，请重开终端后重新运行本脚本。"
    exit 1
  fi
}

ensure_claude() {
  local rc_file="$1"
  if command -v claude >/dev/null 2>&1; then
    say "Claude Code 已安装：$(command -v claude)"
    return
  fi

  say "未检测到 Claude Code。"
  if ! confirm_yes "是否使用 npm 安装 Claude Code？[Y/n]: " yes; then
    return
  fi

  ensure_node "$rc_file"
  load_target_node_env

  if ! command -v npm >/dev/null 2>&1; then
    say "未找到 npm，请先安装 Node.js，再执行：npm install -g $CLAUDE_CODE_PKG"
    exit 1
  fi

  if [ "$(id -u)" -eq 0 ] && [ "$TARGET_USER" != "root" ] && command -v sudo >/dev/null 2>&1; then
    run_target_bash "export NVM_DIR=\"\$HOME/.nvm\"; [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"; command -v nvm >/dev/null 2>&1 && nvm use --silent default >/dev/null 2>&1 || true; npm install -g $(shell_quote "$CLAUDE_CODE_PKG")"
  else
    npm install -g "$CLAUDE_CODE_PKG"
  fi
}

main() {
  local rc_file
  rc_file="$(detect_shell_rc)"

  say "__SITE_NAME__ Claude Code 交互式配置"
  say ""
  say "接口地址：$CLAUDE_BASE_URL"
  say "脚本会写入 ANTHROPIC_BASE_URL、ANTHROPIC_AUTH_TOKEN、CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC。"
  say ""

  local api_key
  read_input api_key "请输入 __SITE_NAME__ 的 API 密钥: "
  if [ -z "$api_key" ]; then
    say "API Key 不能为空。"
    exit 1
  fi

  export ANTHROPIC_BASE_URL="$CLAUDE_BASE_URL"
  export ANTHROPIC_AUTH_TOKEN="$api_key"
  export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

  persist_export "$rc_file" "ANTHROPIC_BASE_URL" "$CLAUDE_BASE_URL"
  persist_export "$rc_file" "ANTHROPIC_AUTH_TOKEN" "$api_key"
  persist_export "$rc_file" "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC" "1"

  say ""
  say "Claude Code 配置已写入：$rc_file"
  say "正在运行的 Claude Code 需要重启后才会读取新配置。"

  ensure_claude "$rc_file"

  if confirm_yes "是否立即启动 Claude Code？[y/N]: "; then
    exec_target_command claude || true
    say "未找到 claude 命令，请安装后手动运行：claude"
  else
    say "已跳过启动。请运行：claude"
  fi
}

main "$@"
