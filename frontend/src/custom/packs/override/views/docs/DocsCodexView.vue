<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
        Codex (OpenAI) 配置教程
      </h1>
      <p class="mt-4 max-w-3xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/80">
        这一页讲的是如何把当前站点接入 Codex。你可以直接使用一键脚本，也可以手动安装并写入 `~/.codex` 配置。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="提示：">
          推荐优先使用下方的一键脚本。脚本会帮你写入 `config.toml` 和 `auth.json`，并在缺少 Node.js 或 Codex CLI 时引导安装。
        </DocsNoteBox>
      </div>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点：">
          当前站点还没有配置公开 `API 端点`，所以这里暂时只能显示占位地址。
          请先到管理后台的 `设置 -> 站点设置 -> API 端点地址` 填好真实地址，再回来复制脚本或手动配置内容。
        </DocsNoteBox>
      </div>
    </DocsSection>

    <DocsSection>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">当前接入信息</h2>
      <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-600 dark:text-white/80">
        <li>1. 当前站点：`{{ siteName }}`</li>
        <li>2. 当前 Codex 接口地址：`{{ codexBaseUrl }}`</li>
        <li>3. 如果你只使用 Codex 桌面版 App，可以只写配置文件，不安装 CLI。</li>
      </ul>
    </DocsSection>

    <DocsAccordion
      title="方式一：一键脚本"
      description="按系统选择脚本，复制整段内容，粘贴到终端后直接执行。脚本会交互式询问你的 API Key，并根据选择配置 Codex CLI、Codex App 或两者一起使用。"
    >
      <div class="flex flex-wrap gap-2">
        <button
          v-for="platform in platforms"
          :key="platform.key"
          type="button"
          class="rounded-full border px-4 py-2 text-sm font-medium transition"
          :class="activePlatform === platform.key
            ? 'border-slate-900 bg-slate-900 text-white dark:border-white dark:bg-white dark:text-slate-950'
            : 'border-slate-200 bg-slate-50 text-slate-700 hover:border-slate-300 hover:text-slate-900 dark:border-white/30 dark:bg-white/[0.10] dark:text-white dark:hover:border-white/40 dark:hover:bg-white/[0.15] dark:hover:text-white'"
          @click="activePlatform = platform.key"
        >
          {{ platform.label }}
        </button>
      </div>

      <div v-if="activePlatform === 'windows'" class="mt-6 space-y-5">
        <DocsMethodBlock title="执行方式" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            打开 PowerShell，把下面整段脚本完整粘贴进去后回车执行。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="PowerShell 一键脚本">
          <CopyCommandBlock label="PowerShell Script" :command="windowsScript" />
        </DocsMethodBlock>
      </div>

      <div v-else class="mt-6 space-y-5">
        <DocsMethodBlock :title="activePlatform === 'macos' ? '执行方式' : '执行方式'" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            {{ activePlatform === 'macos'
              ? '打开 Terminal / iTerm，把下面整段脚本完整粘贴进去后回车执行。'
              : '打开终端，把下面整段脚本完整粘贴进去后回车执行。' }}
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="Bash 一键脚本">
          <CopyCommandBlock label="Bash Script" :command="unixPasteScript" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      title="方式二：手动配置"
      description="如果你不想执行整段脚本，也可以手动安装 Codex 并写入配置文件。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 安装 Codex CLI">
          <CopyCommandBlock :label="manualInstallLabel" :command="manualInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 创建配置目录" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            Windows 配置目录：`%userprofile%\.codex`
          </p>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            macOS / Linux 配置目录：`~/.codex`
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="3. 写入 config.toml">
          <CopyCommandBlock label="config.toml" :command="configTomlContent" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. 写入 auth.json">
          <CopyCommandBlock label="auth.json" :command="authJsonContent" />
        </DocsMethodBlock>

        <DocsMethodBlock title="5. 启动 Codex">
          <CopyCommandBlock label="Run Codex" :command="runCodexCommand" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsSection>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">补充说明</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="脚本方式适合什么场景" boxed>
          <ul class="space-y-2 text-sm leading-7 text-slate-600 dark:text-white/80">
            <li>1. 本机还没装 Codex CLI，想顺手一起装好。</li>
            <li>2. 不想自己手动编辑 `config.toml` 和 `auth.json`。</li>
            <li>3. 需要同时兼容 Codex CLI 和 Codex 桌面版 App。</li>
          </ul>
        </DocsMethodBlock>

        <DocsMethodBlock title="手动方式适合什么场景" boxed>
          <ul class="space-y-2 text-sm leading-7 text-slate-600 dark:text-white/80">
            <li>1. 想清楚知道每个文件写了什么内容。</li>
            <li>2. 已经安装好了 Codex，只需要接入当前站点。</li>
            <li>3. 后续要自己微调 `~/.codex/config.toml` 里的参数。</li>
          </ul>
        </DocsMethodBlock>
      </div>
    </DocsSection>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useAppStore } from '@/stores'
import CopyCommandBlock from '../CopyCommandBlock.vue'
import DocsAccordion from './components/DocsAccordion.vue'
import DocsMethodBlock from './components/DocsMethodBlock.vue'
import DocsNoteBox from './components/DocsNoteBox.vue'
import DocsSection from './components/DocsSection.vue'
import windowsScriptTemplate from './assets/codex-install.ps1?raw'
import unixScriptTemplate from './assets/codex-install.sh?raw'

type PlatformKey = 'windows' | 'macos' | 'linux'

const platforms = [
  { key: 'windows', label: 'Windows' },
  { key: 'macos', label: 'macOS' },
  { key: 'linux', label: 'Linux' },
] as const

const activePlatform = ref<PlatformKey>('windows')
const appStore = useAppStore()

onMounted(() => {
  if (!appStore.publicSettingsLoaded) {
    void appStore.fetchPublicSettings()
  }
})

const siteName = computed(() => {
  const current = appStore.cachedPublicSettings?.site_name || appStore.siteName || 'Sub2API'
  return current.trim() || 'Sub2API'
})

const configuredApiBaseUrl = computed(() => {
  const raw = appStore.cachedPublicSettings?.api_base_url || appStore.apiBaseUrl || ''
  return raw.trim()
})

function ensureV1(value: string) {
  const trimmed = value.replace(/\/+$/, '')
  return trimmed.endsWith('/v1') ? trimmed : `${trimmed}/v1`
}

const hasConfiguredApiBaseUrl = computed(() => configuredApiBaseUrl.value.length > 0)

const codexBaseUrl = computed(() => {
  if (!hasConfiguredApiBaseUrl.value) {
    return 'https://your-api-endpoint.example.com/v1'
  }

  const baseRoot = configuredApiBaseUrl.value.replace(/\/v1\/?$/, '').replace(/\/+$/, '')
  return ensureV1(baseRoot)
})

function escapePowerShell(value: string) {
  return value.replace(/`/g, '``').replace(/"/g, '`"')
}

function escapeBash(value: string) {
  return value
    .replace(/\\/g, '\\\\')
    .replace(/"/g, '\\"')
    .replace(/\$/g, '\\$')
    .replace(/`/g, '\\`')
}

function replaceTemplateTokens(template: string, replacements: Record<string, string>) {
  return Object.entries(replacements).reduce((result, [token, value]) => {
    return result.split(token).join(value)
  }, template)
}

const windowsScript = computed(() => {
  return replaceTemplateTokens(windowsScriptTemplate, {
    '__SITE_NAME__': escapePowerShell(siteName.value),
    '__CODEX_BASE_URL__': codexBaseUrl.value
  })
})

const unixScript = computed(() => {
  return replaceTemplateTokens(unixScriptTemplate, {
    '__SITE_NAME__': escapeBash(siteName.value),
    '__CODEX_BASE_URL__': escapeBash(codexBaseUrl.value)
  })
})

const unixPasteScript = computed(() => {
  return `bash <<'__CODEX_SCRIPT__'
${unixScript.value}
__CODEX_SCRIPT__`
})

const manualInstallCommand = computed(() => {
  switch (activePlatform.value) {
    case 'windows':
      return `npm install -g @openai/codex`
    case 'macos':
      return `brew install --cask codex
# 或者
npm install -g @openai/codex`
    default:
      return `npm install -g @openai/codex`
  }
})

const manualInstallLabel = computed(() => {
  switch (activePlatform.value) {
    case 'windows':
      return 'PowerShell'
    case 'macos':
      return 'Terminal'
    default:
      return 'Bash'
  }
})

const configTomlContent = computed(() => {
  return `model_provider = "OpenAI"
model = "gpt-5.5"
review_model = "gpt-5.5"
model_reasoning_effort = "xhigh"
disable_response_storage = true
network_access = "enabled"
windows_wsl_setup_acknowledged = true

[model_providers.OpenAI]
name = "OpenAI"
base_url = "${codexBaseUrl.value}"
wire_api = "responses"
requires_openai_auth = true

[features]
goals = true`
})

const authJsonContent = `{
  "OPENAI_API_KEY": "your_api_key"
}`

const runCodexCommand = `codex`
</script>
