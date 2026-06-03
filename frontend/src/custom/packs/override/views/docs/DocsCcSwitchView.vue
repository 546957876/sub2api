<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="docs-page-title">
        CC Switch 使用教程
      </h1>
      <p class="docs-text-body mt-4 max-w-3xl text-base leading-8 md:text-lg">
        如果你同时在用 Claude Code、Codex、Gemini CLI 这类工具，推荐先装 <DocsTag size="xs">CC Switch</DocsTag> 再接入本站。
        它可以帮你集中管理 provider、快速切换线路，也能减少反复手改配置文件的麻烦。
      </p>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点" tone="warning">
          当前站点还没有配置公开 <DocsTag tone="warning" size="xs">API 端点</DocsTag>，所以这里暂时只能显示占位地址。
          请先到管理后台的 <code class="docs-inline-code">设置 -> 站点设置 -> API 端点地址</code> 填好真实地址，再回来照着添加 provider。
        </DocsNoteBox>
      </div>
    </DocsSection>

    <DocsSection>
      <div class="grid gap-5 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,0.9fr)]">
        <div>
          <h2 class="docs-heading">先做哪三件事</h2>
          <ol class="docs-text-body mt-4 space-y-3 text-sm leading-7">
            <li><span class="docs-text-strong font-semibold">1.</span> 先下载并安装 CC Switch。</li>
            <li><span class="docs-text-strong font-semibold">2.</span> 进入 <code class="docs-inline-code">Add Provider</code>，按工具分别创建 provider。</li>
            <li><span class="docs-text-strong font-semibold">3.</span> 把本站 API Key 与基地址填进去，再启用。</li>
          </ol>
        </div>

        <div class="docs-surface-muted p-4">
          <div class="docs-text-body space-y-3 text-sm leading-7">
            <a
              href="https://ccswitch.io"
              target="_blank"
              rel="noreferrer"
              class="docs-link-card block rounded-2xl px-4 py-3 text-sm font-medium transition"
            >
              官方网站：ccswitch.io
            </a>
            <a
              href="https://github.com/farion1231/cc-switch/releases"
              target="_blank"
              rel="noreferrer"
              class="docs-link-card block rounded-2xl px-4 py-3 text-sm font-medium transition"
            >
              GitHub Releases 下载页
            </a>
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">当前站点</DocsTag>
              <code class="docs-inline-code">{{ siteName }}</code>
            </div>
            <div class="flex flex-wrap items-center gap-2">
              <DocsTag size="xs">根地址</DocsTag>
              <code class="docs-inline-code">{{ apiRootBaseUrl }}</code>
            </div>
          </div>
        </div>
      </div>
    </DocsSection>

    <DocsAccordion
      badge="地址速查"
      title="常用地址"
      description="先复制这里的地址，再回 CC Switch 填写。"
      default-open
    >
      <div class="grid gap-5 lg:grid-cols-3">
        <DocsMethodBlock title="Claude / Anthropic">
          <p class="docs-copy-dense mb-3">
            Claude 系列直接填站点根地址，不要手动补 <DocsTag tone="warning" size="xs">/v1</DocsTag>。
          </p>
          <DocsCodeBlock label="Anthropic Base URL" :command="anthropicBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="Codex / OpenAI">
          <p class="docs-copy-dense mb-3">
            Codex 走 OpenAI / Responses 风格地址，这里要保留 <DocsTag tone="warning" size="xs">/v1</DocsTag>。
          </p>
          <DocsCodeBlock label="OpenAI Base URL" :command="openAiBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="Gemini CLI">
          <p class="docs-copy-dense mb-3">
            Gemini CLI 一般直接填根地址即可，不需要像 Codex 一样补 <DocsTag tone="warning" size="xs">/v1</DocsTag>。
          </p>
          <DocsCodeBlock label="Gemini Root URL" :command="apiRootBaseUrl" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      badge="推荐流程"
      badge-tone="accent"
      title="配置步骤"
      description="第一次使用时，优先按单工具分别创建 provider。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 下载并安装 CC Switch" boxed>
          <p>
            CC Switch 是一个桌面管理器，支持 Windows / macOS / Linux。推荐从上面的官方网站或 GitHub Releases 安装最新版。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 打开 CC Switch，新增 Provider" boxed>
          <p>
            进入 <code class="docs-inline-code">Add Provider</code> 后，选择你要接入的工具类型。第一次配置不确定时，建议先分别给
            <code class="docs-inline-code">Claude Code</code>、<code class="docs-inline-code">Codex</code>、
            <code class="docs-inline-code">Gemini CLI</code> 各加一个 provider，成功后再考虑做统一管理。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="3. Claude Code / Claude Desktop 推荐填写">
          <p class="docs-copy-dense mb-3">
            Claude 系列建议使用 Anthropic 风格基地址，也就是站点根地址本身。这里
            <DocsTag tone="warning" size="xs">不要手动追加 /v1</DocsTag>。如果你看到的 provider
            是 <code class="docs-inline-code">Claude Code</code>、<code class="docs-inline-code">Claude Desktop</code>、
            <code class="docs-inline-code">Anthropic</code> 相关预设，优先从这些预设开始。
          </p>
          <DocsCodeBlock label="Anthropic Base URL" :command="anthropicBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. Codex 推荐填写">
          <p class="docs-copy-dense mb-3">
            Codex 建议使用 OpenAI 风格地址，这里要保留 <DocsTag tone="warning" size="xs">/v1</DocsTag>。如果 CC Switch 有
            <code class="docs-inline-code">Codex</code>、<code class="docs-inline-code">OpenAI</code> 或
            <code class="docs-inline-code">Responses</code> 相关预设，优先选预设再把地址替换成下面这个。
          </p>
          <DocsCodeBlock label="OpenAI Base URL" :command="openAiBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="5. Gemini CLI 推荐填写">
          <p class="docs-copy-dense mb-3">
            Gemini CLI 这边通常直接填站点根地址即可，不需要像 Codex 那样手动补
            <DocsTag tone="warning" size="xs">/v1</DocsTag>。如果你看到的是
            <code class="docs-inline-code">Gemini</code> 或 <code class="docs-inline-code">Google</code> 相关 provider 预设，也优先从预设开始。
          </p>
          <DocsCodeBlock label="Gemini Root URL" :command="apiRootBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="6. API Key 填写建议" boxed>
          <p>
            上面三个工具都填写你在本站创建的 API Key 即可。只要这个 Key 对应分组允许使用目标模型，CC Switch
            里切过去后就能直接调用。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="7. 启用 Provider 并重新打开工具" boxed>
          <p>
            大多数工具切换 provider 后，重新打开终端或重启对应 CLI 会更稳。Claude Code 对热切换支持会更好一些，
            但第一次接入本站时，仍然建议重新开一次工具确认配置生效。
          </p>
        </DocsMethodBlock>
      </div>
    </DocsAccordion>
  </div>
</template>

<script setup lang="ts">
import DocsAccordion from './components/DocsAccordion.vue'
import DocsCodeBlock from './components/DocsCodeBlock.vue'
import DocsMethodBlock from './components/DocsMethodBlock.vue'
import DocsNoteBox from './components/DocsNoteBox.vue'
import DocsSection from './components/DocsSection.vue'
import DocsTag from './components/DocsTag.vue'
import { useDocsRuntime } from './useDocsRuntime'

const {
  siteName,
  hasConfiguredApiBaseUrl,
  apiRootBaseUrl,
  anthropicBaseUrl,
  openAiBaseUrl
} = useDocsRuntime()
</script>
