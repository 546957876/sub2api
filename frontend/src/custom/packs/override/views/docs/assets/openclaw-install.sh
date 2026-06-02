#!/usr/bin/env bash
set -euo pipefail

CLAUDE_BASE_URL="__ANTHROPIC_BASE_URL__"
CODEX_BASE_URL="__OPENAI_BASE_URL__"
CLAUDE_MODELS=("claude-opus-4-6" "claude-opus-4-7" "claude-sonnet-4-6" "claude-haiku-4-5")
CODEX_MODELS=("gpt-5.5" "gpt-5.4" "gpt-5.4-mini" "gpt-5.3-codex" "gpt-5.2")

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

ask() {
  printf '%s\n' "$*" >&2
}

read_input() {
  local var_name="$1"
  local prompt="$2"
  read -r -u 3 -p "$prompt" "$var_name"
}

confirm_yes() {
  local prompt="$1"
  local answer
  read_input answer "$prompt"
  case "$answer" in
    y|Y|yes|YES|Yes) return 0 ;;
    *) return 1 ;;
  esac
}

select_item() {
  local prompt="$1"
  shift
  local items=("$@")
  local choice

  ask "$prompt"
  local i
  for i in "${!items[@]}"; do
    printf '  %d) %s\n' "$((i + 1))" "${items[$i]}" >&2
  done

  while true; do
    read_input choice "请输入序号 [1-${#items[@]}]: "
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#items[@]}" ]; then
      printf '%s' "${items[$((choice - 1))]}"
      return
    fi
    ask "输入无效，请重新选择。"
  done
}

fetch_models() {
  local provider="$1"
  local base_url="$2"
  local api_key="$3"
  local fallback_csv="$4"
  local models_url="$base_url/models"

  if command -v curl >/dev/null 2>&1; then
    local response
    response="$(curl -fsS --connect-timeout 8 --max-time 20 \
      -H "Authorization: Bearer $api_key" \
      "$models_url" 2>/dev/null || true)"
    if [ -n "$response" ] && command -v python3 >/dev/null 2>&1; then
      local parsed
      parsed="$(printf '%s' "$response" | python3 -c 'import json,sys
try:
    data=json.load(sys.stdin)
    models=data.get("data", data if isinstance(data, list) else [])
    ids=[]
    for item in models:
        if isinstance(item, dict):
            value=item.get("id") or item.get("name") or item.get("model")
        else:
            value=str(item)
        if value:
            ids.append(str(value))
    print("\n".join(dict.fromkeys(ids)))
except Exception:
    pass
' 2>/dev/null || true)"
      if [ -n "$parsed" ]; then
        if [ "$provider" = "anthropic" ]; then
          printf '%s\n' "$parsed" | grep -E '^claude-' || true
        else
          printf '%s\n' "$parsed" | grep -E '^(gpt-|codex)' || true
        fi
        return
      fi
    fi
  fi

  printf '%s\n' "$fallback_csv" | tr ',' '\n'
}

detect_openclaw() {
  if command -v openclaw >/dev/null 2>&1; then
    say "OpenClaw 已安装：$(command -v openclaw)"
    return 0
  fi

  say "未检测到 OpenClaw 客户端；本脚本只写入配置，不会自动安装或重装 OpenClaw。"
  return 1
}

write_openclaw_config() {
  local provider="$1"
  local base_url="$2"
  local api_key="$3"
  local model="$4"
  local config_dir="$HOME/.openclaw"
  local config_file="$config_dir/config.yml"
  local provider_name="__SITE_SLUG__-codex"
  local env_key="OPENAI_API_KEY"

  if [ "$provider" = "anthropic" ]; then
    provider_name="__SITE_SLUG__-claude"
    env_key="ANTHROPIC_API_KEY"
  fi

  mkdir -p "$config_dir"
  cat > "$config_file" <<EOF
# __SITE_NAME__ OpenClaw 配置
# Claude / Anthropic 接口不要带 /v1，OpenAI / Codex 接口必须带 /v1。
apiProvider: ${provider_name}
apiKey: ${api_key}
baseUrl: ${base_url}
model: ${model}
compatibility: ${provider}
providers:
  ${provider_name}:
    type: ${provider}
    baseUrl: ${base_url}
    apiKeyEnv: ${env_key}
    models:
      - ${model}
EOF

  if [ "$provider" = "anthropic" ]; then
    export ANTHROPIC_API_KEY="$api_key"
    export ANTHROPIC_BASE_URL="$base_url"
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
  else
    export OPENAI_API_KEY="$api_key"
    export OPENAI_BASE_URL="$base_url"
  fi
}

main() {
  say "__SITE_NAME__ OpenClaw 交互式配置"
  say ""

  local provider_label
  provider_label="$(select_item "请选择要接入的模型厂商：" "Anthropic（Claude）" "OpenAI（Codex）")"

  local provider base_url fallback_csv default_model
  if [[ "$provider_label" == Anthropic（Claude）* ]]; then
    provider="anthropic"
    base_url="$CLAUDE_BASE_URL"
    fallback_csv="$(IFS=,; printf '%s' "${CLAUDE_MODELS[*]}")"
    default_model="claude-opus-4-6"
  else
    provider="openai"
    base_url="$CODEX_BASE_URL"
    fallback_csv="$(IFS=,; printf '%s' "${CODEX_MODELS[*]}")"
    default_model="gpt-5.5"
  fi

  say ""
  say "接口地址：$base_url"
  if [ "$provider" = "anthropic" ]; then
    say "提示：Anthropic（Claude） 使用 $CLAUDE_BASE_URL，不要追加 /v1。"
  else
    say "提示：OpenAI（Codex） 使用 $CODEX_BASE_URL，必须带 /v1。"
  fi

  local api_key
  read_input api_key "请输入 __SITE_NAME__ 的 API 密钥: "
  if [ -z "$api_key" ]; then
    say "API Key 不能为空。"
    exit 1
  fi

  say "正在获取可用模型，失败时使用平台推荐列表兜底..."
  mapfile -t models < <(fetch_models "$provider" "$base_url" "$api_key" "$fallback_csv" | sed '/^$/d')
  if [ "${#models[@]}" -eq 0 ]; then
    IFS=',' read -r -a models <<< "$fallback_csv"
  fi

  local selected_model
  selected_model="$(select_item "请选择模型，推荐默认示例：$default_model" "${models[@]}")"

  write_openclaw_config "$provider" "$base_url" "$api_key" "$selected_model"

  say ""
  say "OpenClaw 配置已写入：$HOME/.openclaw/config.yml"
  say "当前选择：$provider / $selected_model"
  say ""
  say "配置已写入，但正在运行的 OpenClaw 需要重启后才会读取新配置。"
  detect_openclaw || true
  if confirm_yes "是否立即启动 OpenClaw？[y/N]: "; then
    if command -v openclaw >/dev/null 2>&1; then
      attach_terminal_stdin
      exec openclaw
    fi
    say "未找到 openclaw 命令，请先安装后手动运行：openclaw"
  else
    say "已跳过启动。请退出当前 OpenClaw 会话后重新运行：openclaw"
  fi
}

main "$@"
