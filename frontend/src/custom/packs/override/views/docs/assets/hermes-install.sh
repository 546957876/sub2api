#!/usr/bin/env bash
set -euo pipefail

CLAUDE_BASE_URL="__ANTHROPIC_BASE_URL__"
CODEX_BASE_URL="__OPENAI_BASE_URL__"
CLAUDE_MODELS=("claude-opus-4-7" "claude-opus-4-6" "claude-sonnet-4-6" "claude-haiku-4-5")
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

detect_hermes() {
  if command -v hermes >/dev/null 2>&1; then
    say "Hermes 已安装：$(command -v hermes)"
    return 0
  fi

  say "未检测到 Hermes 客户端；本脚本只写入配置，不会自动安装或重装 Hermes。"
  return 1
}

can_import_yaml() {
  local candidate="$1"
  "$candidate" -c 'import yaml' >/dev/null 2>&1
}

hermes_python_from_shebang() {
  command -v hermes >/dev/null 2>&1 || return 1

  local hermes_bin shebang python_cmd
  hermes_bin="$(command -v hermes)"
  shebang="$(head -n 1 "$hermes_bin" 2>/dev/null || true)"
  case "$shebang" in
    '#!'*) ;;
    *) return 1 ;;
  esac

  python_cmd="${shebang#\#!}"
  python_cmd="${python_cmd%$'\r'}"
  if [[ "$python_cmd" == */env\ * ]]; then
    python_cmd="${python_cmd#*env }"
    python_cmd="${python_cmd%% *}"
  fi

  if [ -n "$python_cmd" ]; then
    printf '%s\n' "$python_cmd"
    return 0
  fi
  return 1
}

detect_python() {
  local candidate
  for candidate in python3 python; do
    if command -v "$candidate" >/dev/null 2>&1 && can_import_yaml "$candidate"; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  local hermes_python
  hermes_python="$(hermes_python_from_shebang || true)"
  if [ -n "$hermes_python" ] && can_import_yaml "$hermes_python"; then
    printf '%s\n' "$hermes_python"
    return 0
  fi

  ask "未找到可用于安全合并 YAML 的 Python 环境。"
  ask "请安装 python3 + PyYAML，或确认 Hermes 自带 Python 可执行且包含 yaml 模块。"
  ask "示例：python3 -m pip install PyYAML"
  return 1
}

merge_hermes_config() {
  local python_bin="$1"
  local config_file="$2"
  local provider_name="$3"
  local api_mode="$4"
  local base_url="$5"
  local api_key="$6"
  local env_key="$7"
  local model_id="$8"

  "$python_bin" - "$config_file" "$provider_name" "$api_mode" "$base_url" "$api_key" "$env_key" "$model_id" <<'PY'
import sys
from pathlib import Path

try:
    import yaml
except Exception:
    print("缺少 Python YAML 解析库，无法安全合并 Hermes 配置。", file=sys.stderr)
    print("请先运行：python3 -m pip install PyYAML", file=sys.stderr)
    sys.exit(1)

config_path = Path(sys.argv[1]).expanduser()
provider_name, api_mode, base_url, api_key, env_key, model_id = sys.argv[2:]

data = {}
if config_path.exists() and config_path.stat().st_size > 0:
    with config_path.open("r", encoding="utf-8") as fh:
        loaded = yaml.safe_load(fh)
    if loaded is None:
        data = {}
    elif isinstance(loaded, dict):
        data = loaded
    else:
        raise SystemExit("现有 Hermes config.yaml 不是 YAML 对象，已停止写入以避免破坏配置。")

model = data.get("model")
if not isinstance(model, dict):
    model = {}
data["model"] = model
model["default"] = model_id
model["provider"] = provider_name

providers = data.get("providers")
if not isinstance(providers, dict):
    providers = {}
data["providers"] = providers

provider_config = providers.get(provider_name)
if not isinstance(provider_config, dict):
    provider_config = {}

provider_config.update({
    "api_mode": api_mode,
    "base_url": base_url,
    "api_key": api_key,
    "api_key_env": env_key,
    "default_model": model_id,
})

models = provider_config.get("models")
if not isinstance(models, list):
    models = []
if model_id not in models:
    models.append(model_id)
provider_config["models"] = models
providers[provider_name] = provider_config

config_path.parent.mkdir(parents=True, exist_ok=True)
with config_path.open("w", encoding="utf-8") as fh:
    yaml.safe_dump(data, fh, allow_unicode=True, sort_keys=False)
PY
}

write_hermes_config() {
  local provider="$1"
  local base_url="$2"
  local api_key="$3"
  local model="$4"
  local config_dir="$HOME/.hermes"
  local config_file="$config_dir/config.yaml"
  local provider_name="__SITE_SLUG__-codex"
  local env_key="OPENAI_API_KEY"
  local api_mode="codex_responses"
  local python_bin

  if [ "$provider" = "anthropic" ]; then
    provider_name="__SITE_SLUG__-claude"
    env_key="ANTHROPIC_API_KEY"
    api_mode="anthropic_messages"
  fi

  mkdir -p "$config_dir"
  python_bin="$(detect_python)" || exit 1
  merge_hermes_config "$python_bin" "$config_file" "$provider_name" "$api_mode" "$base_url" "$api_key" "$env_key" "$model"

  if [ "$provider" = "anthropic" ]; then
    export ANTHROPIC_API_KEY="$api_key"
    export ANTHROPIC_BASE_URL="$base_url"
  else
    export OPENAI_API_KEY="$api_key"
    export OPENAI_BASE_URL="$base_url"
  fi
}

main() {
  say "__SITE_NAME__ Hermes 交互式配置"
  say ""

  local provider_label
  provider_label="$(select_item "请选择要接入的模型厂商：" "Anthropic（Claude）" "OpenAI（Codex）")"

  local provider base_url fallback_csv default_model
  if [[ "$provider_label" == Anthropic（Claude）* ]]; then
    provider="anthropic"
    base_url="$CLAUDE_BASE_URL"
    fallback_csv="$(IFS=,; printf '%s' "${CLAUDE_MODELS[*]}")"
    default_model="claude-opus-4-7"
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

  write_hermes_config "$provider" "$base_url" "$api_key" "$selected_model"

  say ""
  say "Hermes 配置已写入：$HOME/.hermes/config.yaml"
  say "当前选择：$provider / $selected_model"
  say ""
  say "如需使用 Hermes 交互命令调整模型，可运行：hermes model"
  say ""
  say "配置已写入，但正在运行的 Hermes 需要重启后才会读取新配置。"
  detect_hermes || true
  if confirm_yes "是否立即启动 Hermes？[y/N]: "; then
    if command -v hermes >/dev/null 2>&1; then
      attach_terminal_stdin
      exec hermes
    fi
    say "未找到 hermes 命令，请先安装后手动运行：hermes"
  else
    say "已跳过启动。请退出当前 Hermes 会话后重新运行：hermes"
  fi
}

main "$@"
