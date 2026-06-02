<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
        Hermes 配置教程
      </h1>
      <p class="mt-4 max-w-3xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/80">
        这页主要把 API Key、基地址和模型写进 `~/.hermes/config.yaml`。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="提示：">
          一键脚本只负责写配置，不负责安装客户端。合并现有 `config.yaml` 时需要本机有可用的 Python + PyYAML 环境。
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
              1. 先选系统。2. 能用脚本就先走脚本。3. 脚本里再选 Claude 或 Codex。
            </p>
          </div>

          <div class="text-sm leading-7 text-slate-600 dark:text-white/80">
            <div>Claude 接口：`{{ anthropicBaseUrl }}`</div>
            <div>Codex 接口：`{{ openAiBaseUrl }}`</div>
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
      </div>
    </DocsSection>

    <DocsAccordion
      title="推荐方式：一键配置（macOS / Linux）"
      description="脚本会让你选择 Claude / Codex、自动读取模型列表，并把配置安全合并进 `~/.hermes/config.yaml`。"
    >
      <div v-if="activePlatform === 'windows'" class="space-y-5">
        <DocsNoteBox title="当前没有 Windows 一键脚本：">
          当前只提供 macOS / Linux 的一键配置脚本。Windows 用户建议优先使用 WSL，或者直接看下面的 `高级 / 手动配置`。
        </DocsNoteBox>
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
      description="适合已经安装好 Hermes，只想自己写 `config.yaml` 的情况。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 先确认 Hermes 已经安装" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            这一页不内置 Hermes 安装脚本。请先按 Hermes 自己的安装方式装好客户端，并确认终端里可以直接运行 `hermes`。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="2. Claude / Anthropic 示例配置">
          <CopyCommandBlock label="config.yaml" :command="anthropicConfig" />
        </DocsMethodBlock>

        <DocsMethodBlock title="3. OpenAI / Codex 示例配置">
          <CopyCommandBlock label="config.yaml" :command="openAiConfig" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. 启动 Hermes">
          <CopyCommandBlock label="Run Hermes" command="hermes" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsSection>
      <DocsNoteBox title="怎么选：">
        如果你已经装好了 Hermes，优先用脚本；如果你更习惯自己维护 `config.yaml`，或者你在 Windows 上使用，就直接看 `高级 / 手动配置`。
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
import hermesTemplate from './assets/hermes-install.sh?raw'
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
  return replaceTemplateTokens(hermesTemplate, {
    '__SITE_NAME__': escapeBash(siteName.value),
    '__SITE_SLUG__': escapeBash(siteSlug.value),
    '__ANTHROPIC_BASE_URL__': escapeBash(anthropicBaseUrl.value),
    '__OPENAI_BASE_URL__': escapeBash(openAiBaseUrl.value)
  })
})

const unixPasteScript = computed(() => createUnixPasteScript(unixScript.value))

const anthropicConfig = computed(() => {
  return `model:
  default: claude-opus-4-7
  provider: ${siteSlug.value}-claude
providers:
  ${siteSlug.value}-claude:
    api_mode: anthropic_messages
    base_url: ${anthropicBaseUrl.value}
    api_key: your_api_key
    api_key_env: ANTHROPIC_API_KEY
    default_model: claude-opus-4-7
    models:
      - claude-opus-4-7`
})

const openAiConfig = computed(() => {
  return `model:
  default: gpt-5.5
  provider: ${siteSlug.value}-codex
providers:
  ${siteSlug.value}-codex:
    api_mode: codex_responses
    base_url: ${openAiBaseUrl.value}
    api_key: your_api_key
    api_key_env: OPENAI_API_KEY
    default_model: gpt-5.5
    models:
      - gpt-5.5`
})
</script>
