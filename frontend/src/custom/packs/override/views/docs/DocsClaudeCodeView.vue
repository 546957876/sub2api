<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="docs-page-title">
        Claude Code 配置教程
      </h1>
      <p class="docs-page-intro mt-4 max-w-3xl">
        选好系统后，直接复制一键脚本执行即可。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="推荐优先使用一键脚本" tone="accent">
          脚本会自动写入环境变量，并在缺少 Node.js 或 Claude Code 时引导安装。
        </DocsNoteBox>
      </div>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点" tone="warning">
          当前站点还没有配置公开 <DocsTag tone="warning" size="xs">API 端点</DocsTag>，所以这里暂时只能显示占位地址。
          请先到管理后台的 <code class="docs-inline-code">设置 -> 站点设置 -> API 端点地址</code> 填好真实地址，再回来复制脚本或手动配置内容。
        </DocsNoteBox>
      </div>

      <div class="docs-surface-muted mt-6 p-5">
        <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
          <div>
            <h2 class="docs-heading">快速开始</h2>
            <p class="docs-copy-dense mt-2">
              1. 先选系统。2. 复制脚本。3. 执行。
            </p>
          </div>

          <div class="docs-copy-dense space-y-2">
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">当前站点</DocsTag>
              <code class="docs-inline-code">{{ siteName }}</code>
            </div>
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">Claude 接口</DocsTag>
              <code class="docs-inline-code">{{ anthropicBaseUrl }}</code>
            </div>
          </div>
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

        <p class="docs-copy-dense mt-4">
          这里使用的是 Claude / Anthropic 风格接口，<DocsTag tone="warning" size="xs">不要手动追加 /v1</DocsTag>。
        </p>
      </div>
    </DocsSection>

    <DocsAccordion
      badge="推荐方式"
      badge-tone="accent"
      title="推荐方式：一键脚本"
      description="复制整段脚本到终端执行即可。脚本会交互式询问你的 API Key，并根据情况配置或安装 Claude Code。"
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
            hint="长脚本会在框内滚动，不会继续把整页拉长"
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
            hint="长脚本会在框内滚动，不会继续把整页拉长"
          />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      badge="手动配置"
      badge-tone="neutral"
      title="高级 / 手动配置"
      description="只有在你想自己安装 Claude Code、自己写环境变量时，再看这一部分。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 安装 Claude Code">
          <DocsCodeBlock :label="installLabel" :command="installCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 写入环境变量">
          <DocsCodeBlock :label="envLabel" :command="envCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="3. 可选：给 VSCode 里的 Claude Code 写入设置">
          <DocsCodeBlock label="settings.json" :command="vscodeSettingsJson" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. 启动 Claude Code">
          <DocsCodeBlock label="Run Claude Code" command="claude" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsSection>
      <DocsNoteBox title="怎么选">
        大多数用户直接用 <DocsTag tone="accent" size="xs">推荐方式：一键脚本</DocsTag> 就够了。
        只有在你想自己维护环境变量或 <code class="docs-inline-code">~/.claude/settings.json</code> 时，再看
        <DocsTag size="xs">高级 / 手动配置</DocsTag>。
      </DocsNoteBox>
    </DocsSection>
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
import claudeWindowsTemplate from './assets/claude-code-install.ps1?raw'
import claudeUnixTemplate from './assets/claude-code-install.sh?raw'
import { createPowerShellPasteScript, createUnixPasteScript, escapeBash, escapePowerShell, replaceTemplateTokens, useDocsRuntime } from './useDocsRuntime'

const {
  activePlatform,
  platforms,
  siteName,
  hasConfiguredApiBaseUrl,
  anthropicBaseUrl
} = useDocsRuntime()

const windowsScript = computed(() => {
  return replaceTemplateTokens(claudeWindowsTemplate, {
    '__SITE_NAME__': escapePowerShell(siteName.value),
    '__ANTHROPIC_BASE_URL__': anthropicBaseUrl.value
  })
})

const windowsPasteScript = computed(() => createPowerShellPasteScript(windowsScript.value))

const unixScript = computed(() => {
  return replaceTemplateTokens(claudeUnixTemplate, {
    '__SITE_NAME__': escapeBash(siteName.value),
    '__ANTHROPIC_BASE_URL__': escapeBash(anthropicBaseUrl.value)
  })
})

const unixPasteScript = computed(() => createUnixPasteScript(unixScript.value))

const installCommand = computed(() => {
  return 'npm install -g @anthropic-ai/claude-code'
})

const installLabel = computed(() => {
  return activePlatform.value === 'windows' ? 'PowerShell' : 'Terminal'
})

const envCommand = computed(() => {
  switch (activePlatform.value) {
    case 'windows':
      return `$env:ANTHROPIC_BASE_URL="${anthropicBaseUrl.value}"
$env:ANTHROPIC_AUTH_TOKEN="your_api_key"
$env:CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`
    default:
      return `export ANTHROPIC_BASE_URL="${anthropicBaseUrl.value}"
export ANTHROPIC_AUTH_TOKEN="your_api_key"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`
  }
})

const envLabel = computed(() => {
  return activePlatform.value === 'windows' ? 'PowerShell' : 'Terminal'
})

const vscodeSettingsJson = computed(() => {
  return `{
  "env": {
    "ANTHROPIC_BASE_URL": "${anthropicBaseUrl.value}",
    "ANTHROPIC_AUTH_TOKEN": "your_api_key",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
    "CLAUDE_CODE_ATTRIBUTION_HEADER": "0"
  }
}`
})
</script>
