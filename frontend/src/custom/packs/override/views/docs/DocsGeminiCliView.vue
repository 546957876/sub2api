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
        <DocsNoteBox title="提示：">
          默认用 `GEMINI_API_KEY`、`GOOGLE_GEMINI_BASE_URL`、`GEMINI_MODEL` 三个环境变量接入。
        </DocsNoteBox>
      </div>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点：">
          当前站点还没有配置公开 `API 端点`，所以这里暂时只能显示占位地址。
          请先到管理后台的 `设置 -> 站点设置 -> API 端点地址` 填好真实地址，再回来复制配置内容。
        </DocsNoteBox>
      </div>

      <div class="docs-surface-muted mt-6 p-5">
        <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
          <div>
            <h2 class="docs-heading">快速开始</h2>
            <p class="docs-copy-dense mt-2">
              1. 先选系统。2. 安装 Gemini CLI。3. 写入环境变量。4. 运行 `gemini`。
            </p>
          </div>

          <div class="docs-copy-dense">
            <div>当前站点：`{{ siteName }}`</div>
            <div>Gemini 基地址：`{{ apiRootBaseUrl }}`</div>
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
          这里沿用站点根地址，不需要像 Codex 那样额外补 `/v1`。
        </p>
      </div>
    </DocsSection>

    <DocsAccordion
      title="推荐方式：手动配置"
      description="Gemini CLI 当前没有一键脚本，直接按下面步骤配置即可。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 安装 Gemini CLI">
          <CopyCommandBlock :label="installLabel" :command="installCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 写入环境变量">
          <CopyCommandBlock :label="envLabel" :command="envCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="3. 启动 Gemini CLI">
          <CopyCommandBlock label="Run Gemini CLI" command="gemini" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      title="可选：临时运行"
      description="如果你不想全局安装，也可以先临时运行一次 Gemini CLI。"
    >
      <DocsMethodBlock title="npx 临时运行">
        <CopyCommandBlock :label="installLabel" command="npx @google/gemini-cli" />
      </DocsMethodBlock>
    </DocsAccordion>

    <DocsSection>
      <DocsNoteBox title="怎么选：">
        Gemini CLI 当前没有一键脚本，所以直接按 `推荐方式：手动配置` 走就行。默认模型这里给的是 `gemini-2.0-flash`，后续你也可以自己切到别的模型。
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
