<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="docs-page-title">
        OpenClaw 配置教程
      </h1>
      <p class="docs-page-intro mt-4 max-w-3xl">
        这页主要把 API Key、基地址和模型写进 <code class="docs-inline-code">~/.openclaw/config.yml</code>。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="脚本只负责写配置" tone="accent">
          一键脚本不负责安装客户端。请先确认你本机已经能运行 <code class="docs-inline-code">openclaw</code>。
        </DocsNoteBox>
      </div>

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
            1. 先选系统。2. 能用脚本就先走脚本。3. 脚本里再选 Claude 或 Codex。
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
      title="一键配置（macOS / Linux）"
      description="脚本会让你选择 Claude / Codex，并把配置写进 ~/.openclaw/config.yml。"
      default-open
    >
      <div v-if="activePlatform === 'windows'" class="space-y-5">
        <DocsNoteBox title="当前没有 Windows 一键脚本" tone="warning">
          当前只提供 macOS / Linux 的一键配置脚本。Windows 用户建议优先使用 WSL，或者直接看下面的
          <DocsTag size="xs">高级 / 手动配置</DocsTag>。
        </DocsNoteBox>
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
      title="手动配置"
      description="已经安装好 OpenClaw、想自己写 config.yml 时再看。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 安装 OpenClaw">
          <DocsCodeBlock :label="installLabel" :command="installCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="2. Claude / Anthropic 示例配置">
          <DocsCodeBlock label="config.yml" :command="anthropicConfig" />
        </DocsMethodBlock>

        <DocsMethodBlock title="3. OpenAI / Codex 示例配置">
          <DocsCodeBlock label="config.yml" :command="openAiConfig" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. 启动 OpenClaw">
          <DocsCodeBlock label="Run OpenClaw" command="openclaw" />
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
import openclawTemplate from './assets/openclaw-install.sh?raw'
import { createUnixPasteScript, escapeBash, replaceTemplateTokens, useDocsRuntime } from './useDocsRuntime'

const {
  activePlatform,
  platforms,
  siteName,
  siteSlug,
  hasConfiguredApiBaseUrl,
  anthropicBaseUrl,
  openAiBaseUrl
} = useDocsRuntime()

const unixScript = computed(() => {
  return replaceTemplateTokens(openclawTemplate, {
    '__SITE_NAME__': escapeBash(siteName.value),
    '__SITE_SLUG__': escapeBash(siteSlug.value),
    '__ANTHROPIC_BASE_URL__': escapeBash(anthropicBaseUrl.value),
    '__OPENAI_BASE_URL__': escapeBash(openAiBaseUrl.value)
  })
})

const unixPasteScript = computed(() => createUnixPasteScript(unixScript.value))

const installLabel = computed(() => {
  return activePlatform.value === 'windows' ? 'PowerShell' : 'Terminal'
})

const installCommand = computed(() => {
  if (activePlatform.value === 'windows') {
    return 'iwr -useb https://openclaw.ai/install.ps1 | iex'
  }
  return 'curl -fsSL https://openclaw.ai/install.sh | bash'
})

const anthropicConfig = computed(() => {
  return `apiProvider: ${siteSlug.value}-claude
apiKey: your_api_key
baseUrl: ${anthropicBaseUrl.value}
model: claude-opus-4-7
compatibility: anthropic
providers:
  ${siteSlug.value}-claude:
    type: anthropic
    baseUrl: ${anthropicBaseUrl.value}
    apiKeyEnv: ANTHROPIC_API_KEY
    models:
      - claude-opus-4-7`
})

const openAiConfig = computed(() => {
  return `apiProvider: ${siteSlug.value}-codex
apiKey: your_api_key
baseUrl: ${openAiBaseUrl.value}
model: gpt-5.5
compatibility: openai
providers:
  ${siteSlug.value}-codex:
    type: openai
    baseUrl: ${openAiBaseUrl.value}
    apiKeyEnv: OPENAI_API_KEY
    models:
      - gpt-5.5`
})
</script>
