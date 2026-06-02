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
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">安装 Codex CLI</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="方法一：使用 npm（通用）">
          <CopyCommandBlock label="npm" :command="npmInstallCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="方法二：使用官方安装脚本（macOS / Linux）">
          <CopyCommandBlock label="Bash" :command="shellInstallCommand" />
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
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">API Key 方式（可选）</h2>
      <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
        如果你打算使用 API Key 方式启动 Codex，可以先设置 `OPENAI_API_KEY`，再执行 `codex`。
      </p>
      <div class="mt-4 space-y-4">
        <CopyCommandBlock label="Windows PowerShell" :command="windowsApiKeyCommand" />
        <CopyCommandBlock label="macOS / Linux Bash" :command="unixApiKeyCommand" />
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
        <li>2. 后续如果要补“通过本平台地址和密钥接入”的专用脚本或配置方式，可以再单独扩展，不建议和 CLI 基础安装说明混在一起。</li>
        <li>3. Windows 用户如果要更完整地使用类 Linux 命令行体验，可后续再根据需求考虑 WSL2；本页先只提供最直接的安装方式。</li>
      </ul>
    </DocsSection>
  </div>
</template>

<script setup lang="ts">
import CopyCommandBlock from '../CopyCommandBlock.vue'
import DocsMethodBlock from './components/DocsMethodBlock.vue'
import DocsNoteBox from './components/DocsNoteBox.vue'
import DocsSection from './components/DocsSection.vue'

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
