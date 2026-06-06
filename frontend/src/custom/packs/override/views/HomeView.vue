<template>
  <PublicSiteLayout>
    <main class="relative isolate overflow-hidden">
      <div class="absolute inset-0 bg-[radial-gradient(circle_at_0%_0%,rgba(15,23,42,0.06),transparent_24%),radial-gradient(circle_at_78%_18%,rgba(59,130,246,0.06),transparent_22%),linear-gradient(180deg,#f8fafc_0%,#f1f5f9_42%,#f8fafc_100%)] dark:bg-[radial-gradient(circle_at_0%_0%,rgba(45,212,191,0.16),transparent_26%),radial-gradient(circle_at_78%_18%,rgba(56,189,248,0.12),transparent_22%),linear-gradient(180deg,#07101d_0%,#081222_46%,#091426_100%)]"></div>
      <div class="absolute inset-0 opacity-[0.08] [background-image:linear-gradient(rgba(15,23,42,0.14)_1px,transparent_1px),linear-gradient(90deg,rgba(15,23,42,0.14)_1px,transparent_1px)] [background-size:44px_44px] dark:opacity-[0.07] dark:[background-image:linear-gradient(rgba(255,255,255,0.4)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.4)_1px,transparent_1px)]"></div>

      <section class="relative z-10 mx-auto grid max-w-[1440px] gap-16 px-6 py-16 lg:grid-cols-[minmax(0,0.98fr)_580px] lg:px-8 lg:py-24">
        <div class="max-w-2xl">
          <p class="inline-flex items-center gap-2 rounded-full border border-cyan-500/18 bg-cyan-500/10 px-3 py-1 text-[11px] font-medium uppercase tracking-[0.24em] text-cyan-700 dark:border-cyan-300/20 dark:bg-cyan-400/8 dark:text-cyan-200/85">
            <span class="h-1.5 w-1.5 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
            Unified AI Access
          </p>

          <h1 class="mt-6 max-w-4xl text-5xl font-semibold tracking-tight text-slate-950 md:text-6xl lg:text-[68px] lg:leading-[1.03] dark:text-white">
            一个首页，先把真正会高频使用的入口做清楚。
          </h1>

          <p class="mt-6 max-w-xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/92">
            开始使用、查看模型价格、进入控制台。首页先只做这三件事，不把你带进一堆无关路径。
          </p>

          <div class="mt-8 flex flex-col gap-3 sm:flex-row">
            <router-link
              :to="isAuthenticated ? dashboardPath : '/login'"
              class="inline-flex items-center justify-center rounded-full bg-cyan-500 px-6 py-3 text-sm font-semibold text-white transition hover:bg-cyan-400 dark:bg-cyan-400 dark:text-slate-950 dark:hover:bg-cyan-300"
            >
              {{ isAuthenticated ? t('home.goToDashboard') : t('home.getStarted') }}
            </router-link>
            <router-link
              to="/pricing"
              class="inline-flex items-center justify-center rounded-full border border-slate-300 bg-white/75 px-6 py-3 text-sm font-medium text-slate-700 transition hover:border-cyan-300 hover:text-cyan-700 dark:border-white/14 dark:bg-white/[0.06] dark:text-white dark:hover:border-white/28 dark:hover:bg-white/[0.10]"
            >
              {{ t('custom.home.viewPricing') }}
            </router-link>
          </div>

          <div class="mt-10 flex flex-wrap gap-3">
            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/80 px-4 py-2 text-sm text-slate-700 shadow-[0_10px_24px_rgba(15,23,42,0.04)] dark:border-white/18 dark:bg-white/[0.08] dark:text-white dark:shadow-none">
              <span class="h-2 w-2 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
              Claude / GPT / Gemini
            </span>
            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/80 px-4 py-2 text-sm text-slate-700 shadow-[0_10px_24px_rgba(15,23,42,0.04)] dark:border-white/18 dark:bg-white/[0.08] dark:text-white dark:shadow-none">
              <span class="h-2 w-2 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
              模型价格对比
            </span>
            <span class="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/80 px-4 py-2 text-sm text-slate-700 shadow-[0_10px_24px_rgba(15,23,42,0.04)] dark:border-white/18 dark:bg-white/[0.08] dark:text-white dark:shadow-none">
              <span class="h-2 w-2 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
              控制台与密钥管理
            </span>
          </div>
        </div>

        <div class="relative">
          <div class="absolute inset-0 rounded-[32px] bg-cyan-400/10 blur-3xl dark:bg-cyan-400/10"></div>
          <div class="relative overflow-hidden rounded-[32px] border border-slate-200 bg-white/82 shadow-[0_36px_120px_rgba(15,23,42,0.14)] dark:border-white/8 dark:bg-[#0c172a] dark:shadow-[0_36px_120px_rgba(0,0,0,0.42)]">
            <div class="border-b border-slate-200 bg-slate-50 px-5 py-4 dark:border-white/6 dark:bg-[#0a1324]">
              <div class="flex items-center gap-2">
                <span class="h-2.5 w-2.5 rounded-full bg-rose-400/90"></span>
                <span class="h-2.5 w-2.5 rounded-full bg-amber-300/90"></span>
                <span class="h-2.5 w-2.5 rounded-full bg-emerald-400/90"></span>
                <span class="ml-3 text-xs uppercase tracking-[0.2em] text-slate-400 dark:text-white/72">Control Surface</span>
              </div>
            </div>

            <div class="grid gap-4 p-5">
              <section class="rounded-2xl border border-slate-200 bg-white p-5 dark:border-white/7 dark:bg-white/[0.035]">
                <div class="mb-5 flex items-start justify-between gap-4">
                  <div>
                    <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/72">Models</p>
                    <h2 class="mt-2 text-lg font-semibold text-slate-900 dark:text-white">当前最常用的入口</h2>
                    <p class="mt-2 max-w-md text-sm leading-7 text-slate-500 dark:text-white/88">
                      不把所有功能塞进第一屏，只展示最常会点开的东西。
                    </p>
                  </div>
                  <span class="rounded-full bg-emerald-500/10 px-3 py-1 text-xs font-medium text-emerald-600 dark:bg-emerald-400/10 dark:text-emerald-300">
                    Online
                  </span>
                </div>

                <div class="space-y-3">
                  <div
                    v-for="item in modelPreview"
                    :key="item.name"
                    class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 dark:border-white/6 dark:bg-[#091223]"
                  >
                    <div class="flex items-center justify-between gap-4">
                      <div>
                        <p class="text-sm font-medium text-slate-900 dark:text-white">{{ item.name }}</p>
                        <p class="mt-1 text-xs text-slate-500 dark:text-white/84">{{ item.desc }}</p>
                      </div>
                      <div class="text-right">
                        <p class="text-sm font-semibold text-cyan-600 dark:text-cyan-300">{{ item.state }}</p>
                        <p class="mt-1 text-xs text-slate-400 dark:text-white/76">{{ item.meta }}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </section>

              <section class="rounded-2xl border border-slate-200 bg-slate-50/90 p-4 dark:border-white/7 dark:bg-[#091223]/70">
                <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                  <div>
                    <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/72">Next Step</p>
                    <h3 class="mt-2 text-lg font-semibold text-slate-900 dark:text-white">先看价格，再进入实际调用</h3>
                    <p class="mt-2 max-w-md text-sm leading-7 text-slate-600 dark:text-white/90">
                      对大多数用户来说，首页不需要解释全部能力，最重要的是把下一步动作变得清楚。
                    </p>
                  </div>
                  <div class="flex flex-col gap-3 sm:flex-row">
                    <router-link
                      to="/pricing"
                      class="inline-flex items-center justify-center rounded-full border border-cyan-500/18 bg-cyan-500/8 px-4 py-2 text-sm font-medium text-cyan-700 transition hover:bg-cyan-500/12 dark:border-cyan-400/24 dark:bg-cyan-400/10 dark:text-cyan-200 dark:hover:bg-cyan-400/14"
                    >
                      查看模型价格
                    </router-link>
                    <router-link
                      :to="isAuthenticated ? dashboardPath : '/login'"
                      class="inline-flex items-center justify-center rounded-full border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:border-slate-400 dark:border-white/14 dark:bg-white/[0.08] dark:text-white dark:hover:bg-white/[0.12]"
                    >
                      {{ isAuthenticated ? t('home.goToDashboard') : t('home.getStarted') }}
                    </router-link>
                  </div>
                </div>
              </section>
            </div>
          </div>
        </div>
      </section>
    </main>
  </PublicSiteLayout>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAuthStore } from '@/stores'
import PublicSiteLayout from './PublicSiteLayout.vue'

const { t } = useI18n()
const authStore = useAuthStore()
const isAuthenticated = computed(() => authStore.isAuthenticated)
const isAdmin = computed(() => authStore.isAdmin)
const dashboardPath = computed(() => (isAdmin.value ? '/admin/dashboard' : '/dashboard'))

const modelPreview = [
  {
    name: 'Claude / Claude Code',
    desc: '适合复杂写作、编码与长上下文处理',
    state: 'Ready',
    meta: '高频主力模型'
  },
  {
    name: 'GPT / Codex',
    desc: '适合通用对话、自动化和工具调用',
    state: 'Stable',
    meta: '多协议兼容'
  },
  {
    name: 'Gemini',
    desc: '适合轻量高频调用与多模型分流',
    state: 'Online',
    meta: '高吞吐场景'
  }
] as const
</script>
