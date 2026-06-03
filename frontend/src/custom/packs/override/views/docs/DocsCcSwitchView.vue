<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="docs-page-title">
        CC Switch 使用教程
      </h1>
      <p class="docs-text-body mt-4 max-w-3xl text-base leading-8 md:text-lg">
        如果你同时在用 Claude Code、Codex、Gemini CLI 这类工具，推荐先装 `CC Switch` 再接入本站。
        它可以帮你集中管理 provider、快速切换线路，也能减少反复手改配置文件的麻烦。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="它适合谁：">
          如果你经常在多个 AI CLI / 桌面工具之间切换，或者希望把 API Key、provider、MCP / Skills 一起管理，
          那么 CC Switch 通常会比手动改环境变量更省心。
        </DocsNoteBox>
      </div>

      <div v-if="!hasConfiguredApiBaseUrl" class="mt-5">
        <DocsNoteBox title="请先配置 API 端点：">
          当前站点还没有配置公开 `API 端点`，所以这里暂时只能显示占位地址。
          请先到管理后台的 `设置 -> 站点设置 -> API 端点地址` 填好真实地址，再回来照着添加 provider。
        </DocsNoteBox>
      </div>

      <div class="mt-8 grid gap-4 border-y border-slate-200/80 py-5 dark:border-white/10 lg:grid-cols-[1.3fr_1fr]">
        <div>
          <p class="docs-kicker text-[11px] font-semibold uppercase tracking-[0.22em]">
            推荐路径
          </p>
          <p class="docs-text-body mt-3 text-sm leading-7">
            先安装 `CC Switch`，再新增 provider，最后把本站 API Key 和对应基地址填进去。第一次使用时，
            不要一开始就做复杂整合，先单工具接通最稳。
          </p>
        </div>

        <div class="grid gap-3 sm:grid-cols-2 lg:grid-cols-1">
          <a
            href="https://ccswitch.io"
            target="_blank"
            rel="noreferrer"
            class="docs-link-card rounded-2xl px-4 py-3 text-sm font-medium transition"
          >
            官方网站：ccswitch.io
          </a>
          <a
            href="https://github.com/farion1231/cc-switch/releases"
            target="_blank"
            rel="noreferrer"
            class="docs-link-card rounded-2xl px-4 py-3 text-sm font-medium transition"
          >
            GitHub Releases 下载页
          </a>
        </div>
      </div>
    </DocsSection>

    <DocsSection>
      <div class="grid gap-5 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,0.9fr)]">
        <div>
          <h2 class="docs-heading">先做哪三件事</h2>
          <ol class="docs-text-body mt-4 space-y-3 text-sm leading-7">
            <li><span class="docs-text-strong font-semibold">1.</span> 先下载并安装 CC Switch。</li>
            <li><span class="docs-text-strong font-semibold">2.</span> 进入 `Add Provider`，按工具分别创建 provider。</li>
            <li><span class="docs-text-strong font-semibold">3.</span> 把本站 API Key 与基地址填进去，再启用。</li>
          </ol>
        </div>

        <div class="docs-surface-muted p-4">
          <p class="docs-kicker text-[11px] font-semibold uppercase tracking-[0.22em]">
            当前站点
          </p>
          <div class="docs-text-body mt-3 space-y-2 text-sm leading-7">
            <div>站点名：`{{ siteName }}`</div>
            <div>根地址：`{{ apiRootBaseUrl }}`</div>
          </div>
        </div>
      </div>
    </DocsSection>

    <DocsAccordion
      title="三组地址，先直接收好"
      description="如果你只是想先填对地址，这里是最快可用的三组值。先复制，再回 CC Switch 创建 provider。"
      default-open
    >
      <div class="grid gap-5 lg:grid-cols-3">
        <DocsMethodBlock title="Claude / Anthropic">
          <p class="docs-copy-dense mb-3">
            Claude 系列直接填站点根地址，不要手动补 `/v1`。
          </p>
          <CopyCommandBlock label="Anthropic Base URL" :command="anthropicBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="Codex / OpenAI">
          <p class="docs-copy-dense mb-3">
            Codex 走 OpenAI / Responses 风格地址，这里要保留 `/v1`。
          </p>
          <CopyCommandBlock label="OpenAI Base URL" :command="openAiBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="Gemini CLI">
          <p class="docs-copy-dense mb-3">
            Gemini CLI 一般直接填根地址即可，不需要像 Codex 一样补 `/v1`。
          </p>
          <CopyCommandBlock label="Gemini Root URL" :command="apiRootBaseUrl" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      title="默认配置流程"
      description="第一次使用时，优先按单工具分别创建 provider，会比一开始就做复杂合并配置更稳。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 下载并安装 CC Switch" boxed>
          <p>
            CC Switch 是一个桌面管理器，支持 Windows / macOS / Linux。推荐从上面的官方网站或 GitHub Releases 安装最新版。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 打开 CC Switch，新增 Provider" boxed>
          <p>
            进入 `Add Provider` 后，选择你要接入的工具类型。第一次配置不确定时，建议先分别给
            `Claude Code`、`Codex`、`Gemini CLI` 各加一个 provider，成功后再考虑做统一管理。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="3. Claude Code / Claude Desktop 推荐填写">
          <p class="docs-copy-dense mb-3">
            Claude 系列建议使用 Anthropic 风格基地址，也就是站点根地址本身。这里 `不要手动追加 /v1`。如果你看到的 provider
            是 `Claude Code`、`Claude Desktop`、`Anthropic` 相关预设，优先从这些预设开始。
          </p>
          <CopyCommandBlock label="Anthropic Base URL" :command="anthropicBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. Codex 推荐填写">
          <p class="docs-copy-dense mb-3">
            Codex 建议使用 OpenAI 风格地址，这里要保留 `/v1`。如果 CC Switch 有 `Codex`、`OpenAI` 或 `Responses`
            相关预设，优先选预设再把地址替换成下面这个。
          </p>
          <CopyCommandBlock label="OpenAI Base URL" :command="openAiBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="5. Gemini CLI 推荐填写">
          <p class="docs-copy-dense mb-3">
            Gemini CLI 这边通常直接填站点根地址即可，不需要像 Codex 那样手动补 `/v1`。如果你看到的是
            `Gemini` 或 `Google` 相关 provider 预设，也优先从预设开始。
          </p>
          <CopyCommandBlock label="Gemini Root URL" :command="apiRootBaseUrl" />
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

    <DocsSection>
      <DocsNoteBox title="怎么选：">
        如果你只用单一工具，比如只用 Codex 或只用 Claude Code，那么直接看对应教程会更简单。`CC Switch`
        更适合“多工具、多账号、多线路切换”的用户。更稳的做法是先按单工具各自接通一次，再回头整理成统一方案。
      </DocsNoteBox>
    </DocsSection>
  </div>
</template>

<script setup lang="ts">
import CopyCommandBlock from '../CopyCommandBlock.vue'
import DocsAccordion from './components/DocsAccordion.vue'
import DocsMethodBlock from './components/DocsMethodBlock.vue'
import DocsNoteBox from './components/DocsNoteBox.vue'
import DocsSection from './components/DocsSection.vue'
import { useDocsRuntime } from './useDocsRuntime'

const {
  siteName,
  hasConfiguredApiBaseUrl,
  apiRootBaseUrl,
  anthropicBaseUrl,
  openAiBaseUrl
} = useDocsRuntime()
</script>
