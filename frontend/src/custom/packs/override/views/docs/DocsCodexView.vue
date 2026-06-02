<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
        Codex (OpenAI) 配置教程
      </h1>
      <p class="mt-4 max-w-3xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/80">
        在完成 Node.js 环境安装后，继续安装 Codex CLI，并完成首次启动与认证。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="提示：">
          这里讲的是 OpenAI 官方 Codex CLI 的安装和配置，不是 OpenAI SDK 的普通接口调用文档。
        </DocsNoteBox>
      </div>
    </DocsSection>

    <DocsSection>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">准备条件</h2>
      <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-600 dark:text-white/80">
        <li>1. 已完成 Node.js 安装，并确认 `node -v` / `npm -v` 可用。</li>
        <li>2. 建议使用最新可用的 Node.js LTS 版本。</li>
        <li>3. 如果还没有安装 Node，请先回到 `Node.js 环境安装教程`。</li>
      </ul>
    </DocsSection>

    <DocsSection>
      <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">安装与运行</h2>
          <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            先根据当前系统安装 Codex CLI，再完成第一次启动。
          </p>
        </div>

        <div class="flex flex-wrap gap-2">
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

    <DocsSection v-if="activePlatform === 'windows'">
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">Windows</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="方法一：通过 npm 安装（推荐）">
          <CopyCommandBlock label="PowerShell" :command="npmInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="方法二：使用 API Key 直接启动">
          <CopyCommandBlock label="PowerShell" :command="windowsApiKeyCommand" />
        </DocsMethodBlock>
      </div>
    </DocsSection>

    <DocsSection v-else-if="activePlatform === 'macos'">
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">macOS</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="方法一：通过 npm 安装">
          <CopyCommandBlock label="Bash / Zsh" :command="npmInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="方法二：官方安装脚本">
          <CopyCommandBlock label="Bash / Zsh" :command="shellInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="使用 API Key 启动">
          <CopyCommandBlock label="Bash / Zsh" :command="unixApiKeyCommand" />
        </DocsMethodBlock>
      </div>
    </DocsSection>

    <DocsSection v-else>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">Linux</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="方法一：通过 npm 安装">
          <CopyCommandBlock label="Bash" :command="npmInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="方法二：官方安装脚本">
          <CopyCommandBlock label="Bash" :command="shellInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="使用 API Key 启动">
          <CopyCommandBlock label="Bash" :command="unixApiKeyCommand" />
        </DocsMethodBlock>
      </div>
    </DocsSection>

    <DocsSection>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">首次运行</h2>
      <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
        安装完成后，直接执行 `codex`。根据 OpenAI 官方文档，第一次运行时会提示登录或进入认证流程。
      </p>
      <div class="mt-4">
        <CopyCommandBlock label="Run Codex" :command="runCodexCommand" />
      </div>
    </DocsSection>

    <DocsSection>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">升级 Codex CLI</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="通过 npm 升级">
          <CopyCommandBlock label="npm" :command="npmUpgradeCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="重新运行官方安装脚本（macOS / Linux）">
          <CopyCommandBlock label="Bash" :command="shellUpgradeCommand" />
        </DocsMethodBlock>
      </div>
    </DocsSection>

    <DocsSection>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">说明</h2>
      <ul class="mt-4 space-y-3 text-sm leading-7 text-slate-600 dark:text-white/80">
        <li>1. 本页主要覆盖 Codex CLI 的安装、启动与认证流程。</li>
        <li>2. 如果后续要补“通过平台脚本一键接入”的方式，可以在此基础上再扩展，不建议和 CLI 基础安装说明混在一起。</li>
        <li>3. 本页默认按 OpenAI 官方 Codex CLI 的安装逻辑组织步骤。</li>
      </ul>
    </DocsSection>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CopyCommandBlock from '../CopyCommandBlock.vue'
import DocsMethodBlock from './components/DocsMethodBlock.vue'
import DocsNoteBox from './components/DocsNoteBox.vue'
import DocsSection from './components/DocsSection.vue'

type PlatformKey = 'windows' | 'macos' | 'linux'

const platforms = [
  { key: 'windows', label: 'Windows' },
  { key: 'macos', label: 'macOS' },
  { key: 'linux', label: 'Linux' },
] as const

const activePlatform = ref<PlatformKey>('windows')

const npmInstallCommand = `npm install -g @openai/codex`
const shellInstallCommand = `curl -fsSL https://chatgpt.com/codex/install.sh | sh`
const runCodexCommand = `codex`
const windowsApiKeyCommand = `$env:OPENAI_API_KEY="your_openai_api_key"
codex`
const unixApiKeyCommand = `export OPENAI_API_KEY="your_openai_api_key"
codex`
const npmUpgradeCommand = `npm install -g @openai/codex@latest`
const shellUpgradeCommand = `curl -fsSL https://chatgpt.com/codex/install.sh | sh`
</script>
