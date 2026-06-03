<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="docs-page-title">
        Gemini CLI 配置教程
      </h1>
      <p class="docs-page-intro mt-4 max-w-3xl">
        Gemini CLI 当前没有一键脚本，直接按系统手动配置即可。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="默认通过环境变量接入" tone="accent">
          默认用 <code class="docs-inline-code">GEMINI_API_KEY</code>、
          <code class="docs-inline-code">GOOGLE_GEMINI_BASE_URL</code>、
          <code class="docs-inline-code">GEMINI_MODEL</code> 三个环境变量接入。
        </DocsNoteBox>
      </div>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点" tone="warning">
          当前站点还没有配置公开 <DocsTag tone="warning" size="xs">API 端点</DocsTag>，所以这里暂时只能显示占位地址。
          请先到管理后台的 <code class="docs-inline-code">设置 -> 站点设置 -> API 端点地址</code> 填好真实地址，再回来复制配置内容。
        </DocsNoteBox>
      </div>

      <div class="docs-surface-muted mt-6 p-5">
        <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
          <div>
            <h2 class="docs-heading">快速开始</h2>
            <p class="docs-copy-dense mt-2">
              1. 先选系统。2. 安装 Gemini CLI。3. 写入环境变量。4. 运行 <code class="docs-inline-code">gemini</code>。
            </p>
          </div>

          <div class="docs-copy-dense space-y-2">
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">当前站点</DocsTag>
              <code class="docs-inline-code">{{ siteName }}</code>
            </div>
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">Gemini 基地址</DocsTag>
              <code class="docs-inline-code">{{ apiRootBaseUrl }}</code>
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
          这里沿用站点根地址，不需要像 Codex 那样额外补 <DocsTag tone="warning" size="xs">/v1</DocsTag>。
        </p>
      </div>
    </DocsSection>

    <DocsAccordion
      badge="手动配置"
      badge-tone="accent"
      title="推荐方式：手动配置"
      description="Gemini CLI 当前没有一键脚本，直接按下面步骤配置即可。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 安装 Gemini CLI">
          <DocsCodeBlock :label="installLabel" :command="installCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 写入环境变量">
          <DocsCodeBlock :label="envLabel" :command="envCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="3. 启动 Gemini CLI">
          <DocsCodeBlock label="Run Gemini CLI" command="gemini" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      badge="可选方式"
      title="可选：临时运行"
      description="如果你不想全局安装，也可以先临时运行一次 Gemini CLI。"
    >
      <DocsMethodBlock title="npx 临时运行">
        <DocsCodeBlock :label="installLabel" command="npx @google/gemini-cli" />
      </DocsMethodBlock>
    </DocsAccordion>

    <DocsSection>
      <DocsNoteBox title="怎么选">
        Gemini CLI 当前没有一键脚本，所以直接按 <DocsTag tone="accent" size="xs">推荐方式：手动配置</DocsTag> 走就行。
        默认模型这里给的是 <code class="docs-inline-code">gemini-2.0-flash</code>，后续你也可以自己切到别的模型。
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
import { useDocsRuntime } from './useDocsRuntime'

const {
  activePlatform,
  platforms,
  siteName,
  hasConfiguredApiBaseUrl,
  apiRootBaseUrl
} = useDocsRuntime()

const installCommand = computed(() => {
  return 'npm install -g @google/gemini-cli'
})

const installLabel = computed(() => {
  return activePlatform.value === 'windows' ? 'PowerShell' : 'Terminal'
})

const envCommand = computed(() => {
  switch (activePlatform.value) {
    case 'windows':
      return `$env:GOOGLE_GEMINI_BASE_URL="${apiRootBaseUrl.value}"
$env:GEMINI_API_KEY="your_api_key"
$env:GEMINI_MODEL="gemini-2.0-flash"`
    default:
      return `export GOOGLE_GEMINI_BASE_URL="${apiRootBaseUrl.value}"
export GEMINI_API_KEY="your_api_key"
export GEMINI_MODEL="gemini-2.0-flash"`
  }
})

const envLabel = computed(() => {
  return activePlatform.value === 'windows' ? 'PowerShell' : 'Terminal'
})
</script>
