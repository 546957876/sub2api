<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
        Claude Code 配置教程
      </h1>
      <p class="mt-4 max-w-3xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/80">
        选好系统后，直接复制一键脚本执行即可。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="提示：">
          推荐优先使用一键脚本。脚本会自动写入环境变量，并在缺少 Node.js 或 Claude Code 时引导安装。
        </DocsNoteBox>
      </div>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点：">
          当前站点还没有配置公开 `API 端点`，所以这里暂时只能显示占位地址。
          请先到管理后台的 `设置 -> 站点设置 -> API 端点地址` 填好真实地址，再回来复制脚本或手动配置内容。
        </DocsNoteBox>
      </div>

      <div class="mt-6 rounded-2xl border border-slate-200 bg-slate-50/80 p-5 dark:border-white/8 dark:bg-white/[0.025]">
        <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
          <div>
            <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">快速开始</h2>
            <p class="mt-2 text-sm leading-7 text-slate-600 dark:text-white/80">
              1. 先选系统。2. 复制脚本。3. 执行。
            </p>
          </div>

          <div class="text-sm leading-7 text-slate-600 dark:text-white/80">
            <div>当前站点：`{{ siteName }}`</div>
            <div>Claude 接口：`{{ anthropicBaseUrl }}`</div>
          </div>
        </div>

        <div class="mt-4 flex flex-wrap gap-2">
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

        <p class="mt-4 text-sm leading-7 text-slate-600 dark:text-white/80">
          这里使用的是 Claude / Anthropic 风格接口，`不要手动追加 /v1`。
        </p>
      </div>
    </DocsSection>

    <DocsAccordion
      title="推荐方式：一键脚本"
      description="复制整段脚本到终端执行即可。脚本会交互式询问你的 API Key，并根据情况配置或安装 Claude Code。"
    >
      <div v-if="activePlatform === 'windows'" class="space-y-5">
        <DocsMethodBlock title="执行方式" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            打开 PowerShell，把下面整段脚本完整粘贴进去后回车执行。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="PowerShell 一键脚本">
          <CopyCommandBlock label="PowerShell Script" :command="windowsScript" />
        </DocsMethodBlock>
      </div>

      <div v-else class="space-y-5">
        <DocsMethodBlock title="执行方式" boxed>
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
      title="高级 / 手动配置"
      description="只有在你想自己安装 Claude Code、自己写环境变量时，再看这一部分。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 安装 Claude Code">
          <CopyCommandBlock :label="installLabel" :command="installCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 写入环境变量">
          <CopyCommandBlock :label="envLabel" :command="envCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="3. 可选：给 VSCode 里的 Claude Code 写入设置">
          <CopyCommandBlock label="settings.json" :command="vscodeSettingsJson" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. 启动 Claude Code">
          <CopyCommandBlock label="Run Claude Code" command="claude" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsSection>
      <DocsNoteBox title="怎么选：">
        大多数用户直接用 `推荐方式：一键脚本` 就够了。只有在你想自己维护环境变量或 `~/.claude/settings.json` 时，再看 `高级 / 手动配置`。
      </DocsNoteBox>
    </DocsSection>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import CopyCommandBlock from '../CopyCommandBlock.vue'
import DocsAccordion from './components/DocsAccordion.vue'
import DocsMethodBlock from './components/DocsMethodBlock.vue'
import DocsNoteBox from './components/DocsNoteBox.vue'
import DocsSection from './components/DocsSection.vue'
import claudeWindowsTemplate from './assets/claude-code-install.ps1?raw'
import claudeUnixTemplate from './assets/claude-code-install.sh?raw'
import { createUnixPasteScript, escapeBash, escapePowerShell, replaceTemplateTokens, useDocsRuntime } from './useDocsRuntime'

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
