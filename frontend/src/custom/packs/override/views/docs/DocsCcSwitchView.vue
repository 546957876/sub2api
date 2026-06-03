<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
        CC Switch 使用教程
      </h1>
      <p class="mt-4 max-w-3xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/80">
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

      <div class="mt-6 rounded-2xl border border-slate-200 bg-slate-50/80 p-5 dark:border-white/8 dark:bg-white/[0.025]">
        <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
          <div>
            <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">快速开始</h2>
            <p class="mt-2 text-sm leading-7 text-slate-600 dark:text-white/80">
              1. 先安装 CC Switch。2. 新增 provider。3. 按工具填写基地址和 API Key。4. 启用后再打开对应工具。
            </p>
          </div>

          <div class="text-sm leading-7 text-slate-600 dark:text-white/80">
            <div>当前站点：`{{ siteName }}`</div>
            <div>根地址：`{{ apiRootBaseUrl }}`</div>
          </div>
        </div>

        <div class="mt-4 grid gap-3 md:grid-cols-2">
          <a
            href="https://ccswitch.io"
            target="_blank"
            rel="noreferrer"
            class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-medium text-slate-700 transition hover:border-slate-300 hover:text-slate-950 dark:border-white/12 dark:bg-white/[0.08] dark:text-white dark:hover:border-white/20 dark:hover:bg-white/[0.12]"
          >
            官方网站：ccswitch.io
          </a>
          <a
            href="https://github.com/farion1231/cc-switch/releases"
            target="_blank"
            rel="noreferrer"
            class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-medium text-slate-700 transition hover:border-slate-300 hover:text-slate-950 dark:border-white/12 dark:bg-white/[0.08] dark:text-white dark:hover:border-white/20 dark:hover:bg-white/[0.12]"
          >
            GitHub Releases 下载页
          </a>
        </div>
      </div>
    </DocsSection>

    <DocsAccordion
      title="推荐流程：先装 CC Switch，再接入本站"
      description="下面按最少出错的顺序来配置。第一次使用时，优先按单工具分别创建 provider，会比一开始就做复杂合并配置更稳。"
      default-open
    >
      <div class="space-y-5">
        <DocsMethodBlock title="1. 下载并安装 CC Switch" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            CC Switch 是一个桌面管理器，支持 Windows / macOS / Linux。推荐从上面的官方网站或 GitHub Releases 安装最新版。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="2. 打开 CC Switch，新增 Provider" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            进入 `Add Provider` 后，选择你要接入的工具类型。第一次配置不确定时，建议先分别给
            `Claude Code`、`Codex`、`Gemini CLI` 各加一个 provider，成功后再考虑做统一管理。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="3. Claude Code / Claude Desktop 推荐填写">
          <p class="mb-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            Claude 系列建议使用 Anthropic 风格基地址，也就是站点根地址本身。这里 `不要手动追加 /v1`。
          </p>
          <CopyCommandBlock label="Anthropic Base URL" :command="anthropicBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="4. Codex 推荐填写">
          <p class="mb-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            Codex 建议使用 OpenAI 风格地址，这里要保留 `/v1`。如果 CC Switch 有 `Codex` 或 `OpenAI / Responses`
            相关预设，优先选预设再把地址替换成下面这个。
          </p>
          <CopyCommandBlock label="OpenAI Base URL" :command="openAiBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="5. Gemini CLI 推荐填写">
          <p class="mb-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            Gemini CLI 这边通常直接填站点根地址即可，不需要像 Codex 那样手动补 `/v1`。如果你看到的是
            `Gemini` 或 `Google` 相关 provider 预设，也优先从预设开始。
          </p>
          <CopyCommandBlock label="Gemini Root URL" :command="apiRootBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="6. API Key 填写建议" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            上面三个工具都填写你在本站创建的 API Key 即可。只要这个 Key 对应分组允许使用目标模型，CC Switch
            里切过去后就能直接调用。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="7. 启用 Provider 并重新打开工具" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            大多数工具切换 provider 后，重新打开终端或重启对应 CLI 会更稳。Claude Code 对热切换支持会更好一些，
            但第一次接入本站时，仍然建议重新开一次工具确认配置生效。
          </p>
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      title="如果你想一套配置同时管理多个工具"
      description="CC Switch 支持把 Claude Code、Codex、Gemini CLI 放进统一管理流程里，但第一次配置时不一定非要一步到位。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="什么时候适合做统一管理" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            如果你经常在 `Claude Code / Codex / Gemini CLI` 之间切换，并且希望一起管理 provider、MCP、Skills，
            那么可以优先尝试 CC Switch 的统一 provider / Universal Provider 思路。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="更稳的上手方式" boxed>
          <p class="text-sm leading-7 text-slate-600 dark:text-white/80">
            更推荐的顺序是：先按单工具各自接通一次，确认 `Claude`、`Codex`、`Gemini` 都能正常走本站；再回头整理成你习惯的统一方案。
            这样出问题时也更容易判断到底是 provider 类型不对，还是地址填错了。
          </p>
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsAccordion
      title="地址速查"
      description="这三个地址最容易混。你可以直接复制下面对应的值到 CC Switch。"
    >
      <div class="space-y-5">
        <DocsMethodBlock title="Claude / Anthropic 风格">
          <CopyCommandBlock label="Anthropic Base URL" :command="anthropicBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="Codex / OpenAI 风格">
          <CopyCommandBlock label="OpenAI Base URL" :command="openAiBaseUrl" />
        </DocsMethodBlock>

        <DocsMethodBlock title="Gemini CLI 风格">
          <CopyCommandBlock label="Gemini Root URL" :command="apiRootBaseUrl" />
        </DocsMethodBlock>
      </div>
    </DocsAccordion>

    <DocsSection>
      <DocsNoteBox title="怎么选：">
        如果你只用单一工具，比如只用 Codex 或只用 Claude Code，那么直接看对应教程会更简单。
        `CC Switch` 更适合“多工具、多账号、多线路切换”的用户。
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
