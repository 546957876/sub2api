<template>
  <PublicSiteLayout>
    <main class="relative isolate overflow-hidden">
      <div class="absolute inset-0 bg-[radial-gradient(circle_at_0%_0%,rgba(15,23,42,0.06),transparent_24%),radial-gradient(circle_at_78%_18%,rgba(59,130,246,0.06),transparent_22%),linear-gradient(180deg,#f8fafc_0%,#f1f5f9_42%,#f8fafc_100%)] dark:bg-[radial-gradient(circle_at_0%_0%,rgba(45,212,191,0.16),transparent_26%),radial-gradient(circle_at_78%_18%,rgba(56,189,248,0.12),transparent_22%),linear-gradient(180deg,#07101d_0%,#081222_46%,#091426_100%)]"></div>
      <div class="absolute inset-0 opacity-[0.08] [background-image:linear-gradient(rgba(15,23,42,0.14)_1px,transparent_1px),linear-gradient(90deg,rgba(15,23,42,0.14)_1px,transparent_1px)] [background-size:44px_44px] dark:opacity-[0.07] dark:[background-image:linear-gradient(rgba(255,255,255,0.4)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.4)_1px,transparent_1px)]"></div>

      <section class="relative z-10 mx-auto max-w-[1440px] px-5 py-10 lg:px-8 lg:py-16">
        <div class="grid gap-6 lg:grid-cols-[280px_minmax(0,1fr)]">
          <aside class="rounded-3xl border border-slate-200 bg-white/86 p-4 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
            <p class="px-2 text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">快速上手</p>
            <div class="mt-3 space-y-2">
              <button
                v-for="item in docsNav"
                :key="item.key"
                type="button"
                class="flex w-full items-center justify-between rounded-2xl px-4 py-3 text-left text-sm font-medium transition"
                :class="activeDoc === item.key
                  ? 'bg-amber-100 text-amber-900 shadow-[0_10px_24px_rgba(251,191,36,0.12)] dark:bg-[#3a2417] dark:text-white dark:shadow-none'
                  : 'bg-slate-50 text-slate-700 hover:bg-slate-100 dark:bg-white/5 dark:text-white/84 dark:hover:bg-white/8'"
                @click="activeDoc = item.key"
              >
                <span>{{ item.label }}</span>
                <span class="text-xs opacity-60">当前</span>
              </button>
            </div>
          </aside>

          <div class="space-y-6" v-if="activeDoc === 'nodejs'">
            <section class="rounded-3xl border border-slate-200 bg-white/86 p-5 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
              <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
                Node.js 环境安装教程
              </h1>
              <p class="mt-4 max-w-3xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/80">
                在 Windows、macOS、Linux 安装 Node.js LTS，并验证 `node` / `npm` 命令可用。
              </p>

              <div class="mt-5 rounded-2xl border border-cyan-500/22 bg-cyan-500/10 px-4 py-4 text-sm leading-7 text-slate-800 dark:border-cyan-400/28 dark:bg-cyan-400/14 dark:text-slate-50">
                <span class="font-semibold text-cyan-800 dark:text-cyan-200">提示：</span>
                <span class="text-slate-800 dark:text-slate-50">
                  后续的 Claude Code、Gemini CLI、Codex 等接入方式都依赖 Node.js 运行环境。建议先完成本页，再继续其他文档。
                </span>
              </div>
            </section>

            <section class="rounded-3xl border border-slate-200 bg-white/86 p-5 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
              <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">Windows</h2>
              <div class="mt-6 space-y-5">
                <div class="rounded-2xl border border-slate-200 bg-slate-50/80 p-4 dark:border-white/8 dark:bg-white/[0.025]">
                  <h3 class="text-xl font-semibold text-slate-900 dark:text-white">方法一：官方安装包（推荐）</h3>
                  <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
                    前往 <a class="text-cyan-700 underline underline-offset-4 dark:text-cyan-300" href="https://nodejs.org/" target="_blank" rel="noopener noreferrer">Node.js 官网</a> 下载 LTS 版本，双击安装包按提示完成安装。
                  </p>
                </div>

                <div>
                  <h3 class="text-xl font-semibold text-slate-900 dark:text-white">方法二：使用 Chocolatey</h3>
                  <CopyCommandBlock label="CMD / PowerShell" :command="windowsChocolateyCommand" />
                </div>

                <div>
                  <h3 class="text-xl font-semibold text-slate-900 dark:text-white">方法三：使用 Scoop</h3>
                  <CopyCommandBlock label="CMD / PowerShell" :command="windowsScoopCommand" />
                </div>
              </div>
            </section>

            <section class="rounded-3xl border border-slate-200 bg-white/86 p-5 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
              <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">macOS</h2>
              <div class="mt-6 space-y-5">
                <div>
                  <h3 class="text-xl font-semibold text-slate-900 dark:text-white">方法一：使用 Homebrew（推荐）</h3>
                  <CopyCommandBlock label="Bash / Zsh" :command="macosHomebrewCommand" />
                </div>

                <div class="rounded-2xl border border-slate-200 bg-slate-50/80 p-4 dark:border-white/8 dark:bg-white/[0.025]">
                  <h3 class="text-xl font-semibold text-slate-900 dark:text-white">方法二：官方安装包</h3>
                  <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
                    前往 <a class="text-cyan-700 underline underline-offset-4 dark:text-cyan-300" href="https://nodejs.org/" target="_blank" rel="noopener noreferrer">Node.js 官网</a> 下载 macOS 安装包，按提示完成安装。
                  </p>
                </div>
              </div>
            </section>

            <section class="rounded-3xl border border-slate-200 bg-white/86 p-5 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
              <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">Linux</h2>
              <div class="mt-6 space-y-5">
                <div>
                  <h3 class="text-xl font-semibold text-slate-900 dark:text-white">方法一：NodeSource（Ubuntu / Debian）</h3>
                  <CopyCommandBlock label="Bash" :command="linuxNodeSourceCommand" />
                </div>

                <div class="rounded-2xl border border-slate-200 bg-slate-50/80 p-4 dark:border-white/8 dark:bg-white/[0.025]">
                  <h3 class="text-xl font-semibold text-slate-900 dark:text-white">方法二：系统包管理器</h3>
                  <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
                    也可以根据你使用的发行版，通过官方软件源安装 Node.js，但通常建议优先使用 LTS 版本。
                  </p>
                </div>
              </div>
            </section>

            <section class="rounded-3xl border border-slate-200 bg-white/86 p-5 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-white/8 dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
              <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">验证安装</h2>
              <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/80">
                安装完成后，在终端执行下面命令，确认 `node` 和 `npm` 都已经可用。
              </p>
              <div class="mt-4">
                <CopyCommandBlock label="Verify Node" :command="verifyNodeCommand" />
              </div>
            </section>
          </div>
        </div>
      </section>
    </main>
  </PublicSiteLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CopyCommandBlock from './CopyCommandBlock.vue'
import PublicSiteLayout from './PublicSiteLayout.vue'

type DocsNavKey = 'nodejs'

const docsNav = [
  { key: 'nodejs', label: 'Node.js 环境安装教程' },
] as const

const activeDoc = ref<DocsNavKey>('nodejs')

const windowsChocolateyCommand = `choco install nodejs-lts`
const windowsScoopCommand = `scoop install nodejs-lts`
const macosHomebrewCommand = `brew install node`
const linuxNodeSourceCommand = `curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs`

const verifyNodeCommand = `node -v
npm -v`
</script>
