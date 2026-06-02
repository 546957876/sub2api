<template>
  <div class="space-y-6">
    <DocsSection>
      <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
        Node.js 环境安装教程
      </h1>
      <p class="mt-4 max-w-3xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/80">
        在 Windows、macOS、Linux 安装 Node.js LTS，并验证 `node` / `npm` 命令可用。
      </p>

      <div class="mt-5">
        <DocsNoteBox title="提示：">
          后续的 Claude Code、Gemini CLI、Codex 等接入方式都依赖 Node.js 运行环境。建议先完成本页，再继续其他文档。
        </DocsNoteBox>
      </div>
    </DocsSection>

    <DocsSection>
      <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">安装方式</h2>
          <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            根据你当前使用的系统，切换到对应的安装说明和命令。
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
        <DocsMethodBlock title="方法一：官方安装包（推荐）" boxed>
          <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            前往 <a class="text-cyan-700 underline underline-offset-4 dark:text-cyan-300" href="https://nodejs.org/" target="_blank" rel="noopener noreferrer">Node.js 官网</a> 下载 LTS 版本，双击安装包按提示完成安装。
          </p>
        </DocsMethodBlock>

        <DocsMethodBlock title="方法二：使用 Chocolatey">
          <CopyCommandBlock label="CMD / PowerShell" :command="windowsChocolateyCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="方法三：使用 Scoop">
          <CopyCommandBlock label="CMD / PowerShell" :command="windowsScoopCommand" />
        </DocsMethodBlock>
      </div>
    </DocsSection>

    <DocsSection v-else-if="activePlatform === 'macos'">
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">macOS</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="方法一：使用 Homebrew（推荐）">
          <CopyCommandBlock label="Bash / Zsh" :command="macosHomebrewCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="方法二：官方安装包" boxed>
          <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            前往 <a class="text-cyan-700 underline underline-offset-4 dark:text-cyan-300" href="https://nodejs.org/" target="_blank" rel="noopener noreferrer">Node.js 官网</a> 下载 macOS 安装包，按提示完成安装。
          </p>
        </DocsMethodBlock>
      </div>
    </DocsSection>

    <DocsSection v-else>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">Linux</h2>
      <div class="mt-6 space-y-5">
        <DocsMethodBlock title="方法一：NodeSource（Ubuntu / Debian）">
          <CopyCommandBlock label="Bash" :command="linuxNodeSourceCommand" />
        </DocsMethodBlock>

        <DocsMethodBlock title="方法二：系统包管理器" boxed>
          <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
            也可以根据你使用的发行版，通过官方软件源安装 Node.js，但通常建议优先使用 LTS 版本。
          </p>
        </DocsMethodBlock>
      </div>
    </DocsSection>

    <DocsSection>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">验证安装</h2>
      <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
        安装完成后，在终端执行下面命令，确认 `node` 和 `npm` 都已经可用。
      </p>
      <div class="mt-4">
        <CopyCommandBlock label="Verify Node" :command="verifyNodeCommand" />
      </div>
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

const windowsChocolateyCommand = `choco install nodejs-lts`
const windowsScoopCommand = `scoop install nodejs-lts`
const macosHomebrewCommand = `brew install node`
const linuxNodeSourceCommand = `curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs`

const verifyNodeCommand = `node -v
npm -v`
</script>
