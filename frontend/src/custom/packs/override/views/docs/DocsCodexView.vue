<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="docs-page-title">
        Codex (OpenAI) 配置教程
      </h1>
      <p class="docs-page-intro mt-4 max-w-3xl">
        大多数情况下，你只需要选好系统，然后复制一键脚本执行就可以了。
      </p>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点" tone="warning">
          当前站点还没有配置公开 <DocsTag tone="warning" size="xs">API 端点</DocsTag>，所以这里暂时只能显示占位地址。
          请先到管理后台的 <code class="docs-inline-code">设置 -> 站点设置 -> API 端点地址</code> 填好真实地址，再回来复制脚本或手动配置内容。
        </DocsNoteBox>
      </div>

      <div class="docs-surface-muted mt-6 p-5">
        <div>
          <h2 class="docs-heading">快速开始</h2>
          <p class="docs-copy-dense mt-2">
            1. 先选系统。2. 复制下面的一键脚本。3. 粘贴到终端执行。
          </p>
        </div>

        <div class="mt-4 flex flex-wrap gap-2">
          <button
            v-for="platform in platforms"
            :key="platform.key"
            type="button"
            class="px-4 py-2 text-sm font-medium transition"
            :class="activePlatform === platform.key
              ? 'docs-platform-pill-active'
              : 'docs-platform-pill-idle'"
            @click="activePlatform = platform.key"
          >
            {{ platform.label }}
          </button>
        </div>
      </div>
    </DocsSection>

    <DocsAccordion
      badge="推荐方式"
      badge-tone="accent"
      title="一键脚本"
      description="复制整段脚本到终端执行即可。脚本会询问 API Key，并完成 Codex 配置。"
      default-open
    >
      <div v-if="activePlatform === 'windows'" class="space-y-5">
        <DocsMethodBlock title="执行方式" boxed>
          <p>
            打开 PowerShell，把下面整段脚本完整粘贴进去后回车执行。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="PowerShell 一键脚本">
          <DocsCodeBlock
            label="PowerShell Script"
            :command="windowsPasteScript"
          />
        </DocsMethodBlock>
      </div>

      <div v-else class="space-y-5">
        <DocsMethodBlock title="执行方式" boxed>
          <p>
            {{ activePlatform === 'macos'
              ? '打开 Terminal / iTerm，把下面整段脚本完整粘贴进去后回车执行。'
              : '打开终端，把下面整段脚本完整粘贴进去后回车执行。' }}
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="Bash 一键脚本">
          <DocsCodeBlock
            label="Bash Script"
            :command="unixPasteScript"
          />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      badge="手动配置"
      badge-tone="neutral"
      title="手动配置"
      description="你想自己安装 Codex、自己写配置文件时，再看这一部分。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 安装 Codex CLI">
          <DocsCodeBlock :label="manualInstallLabel" :command="manualInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 创建配置目录" boxed>
          <div class="space-y-3">
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">Windows 配置目录</DocsTag>
              <code class="docs-inline-code">%userprofile%\.codex</code>
            </div>
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">macOS / Linux 配置目录</DocsTag>
              <code class="docs-inline-code">~/.codex</code>
            </div>
          </div>
        </DocsMethodBlock>

        <DocsMethodBlock title="3. 写入 config.toml">
          <DocsCodeBlock label="config.toml" :command="configTomlContent" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. 写入 auth.json">
          <DocsCodeBlock label="auth.json" :command="authJsonContent" />
        </DocsMethodBlock>

        <DocsMethodBlock title="5. 启动 Codex">
          <DocsCodeBlock label="Run Codex" :command="runCodexCommand" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import DocsAccordion from './components/DocsAccordion.vue'
import DocsCodeBlock from './components/DocsCodeBlock.vue'
import DocsMethodBlock from './components/DocsMethodBlock.vue'
import DocsNoteBox from './components/DocsNoteBox.vue'
import DocsSection from './components/DocsSection.vue'
import DocsTag from './components/DocsTag.vue'
import windowsScriptTemplate from './assets/codex-install.ps1?raw'
import unixScriptTemplate from './assets/codex-install.sh?raw'
import {
  createPowerShellPasteScript,
  createUnixPasteScript,
  escapeBash,
  escapePowerShell,
  replaceTemplateTokens,
  useDocsRuntime
} from './useDocsRuntime'

const {
  activePlatform,
  platforms,
  siteName,
  hasConfiguredApiBaseUrl,
  openAiBaseUrl: codexBaseUrl
} = useDocsRuntime()

const windowsScript = computed(() => {
  return replaceTemplateTokens(windowsScriptTemplate, {
    '__SITE_NAME__': escapePowerShell(siteName.value),
    '__CODEX_BASE_URL__': codexBaseUrl.value
  })
})

const windowsPasteScript = computed(() => createPowerShellPasteScript(windowsScript.value))

const unixScript = computed(() => {
  return replaceTemplateTokens(unixScriptTemplate, {
    '__SITE_NAME__': escapeBash(siteName.value),
    '__CODEX_BASE_URL__': escapeBash(codexBaseUrl.value)
  })
})

const unixPasteScript = computed(() => createUnixPasteScript(unixScript.value))

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
model_context_window = 1000000
model_auto_compact_token_limit = 800000
effective_context_window_percent = 95

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
