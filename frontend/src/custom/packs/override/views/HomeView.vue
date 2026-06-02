<template>
  <div class="min-h-screen bg-slate-50 text-slate-900 transition-colors duration-300 dark:bg-[#060d18] dark:text-white">
    <header class="relative z-30 border-b border-slate-200/70 bg-white/92 backdrop-blur-xl transition-colors duration-300 dark:border-white/6 dark:bg-[#07101d]/96">
      <nav class="mx-auto flex max-w-[1440px] items-center justify-between px-6 py-4 lg:px-8">
        <div class="flex items-center">
          <div class="flex h-11 w-11 items-center justify-center overflow-hidden rounded-xl bg-slate-100 shadow-[0_0_0_1px_rgba(15,23,42,0.06)] transition-colors duration-300 dark:bg-[#0d1830] dark:shadow-[0_0_0_1px_rgba(255,255,255,0.05)]">
            <img :src="siteLogo || '/logo.png'" alt="Logo" class="h-full w-full object-contain" />
          </div>
        </div>

        <div class="flex items-center gap-3">
          <LocaleSwitcher />
          <button
            type="button"
            class="rounded-lg p-2 text-slate-500 transition hover:bg-slate-100 hover:text-slate-900 dark:text-white/55 dark:hover:bg-white/5 dark:hover:text-white"
            :title="isDark ? t('home.switchToLight') : t('home.switchToDark')"
            @click="toggleTheme"
          >
            <Icon v-if="isDark" name="sun" size="md" />
            <Icon v-else name="moon" size="md" />
          </button>
          <router-link
            :to="isAuthenticated ? dashboardPath : '/login'"
            class="inline-flex items-center gap-1.5 rounded-full bg-slate-900 py-1 pl-1 pr-2.5 text-sm font-medium text-white transition hover:bg-slate-800 dark:bg-white/7 dark:hover:bg-white/10"
          >
            <span
              v-if="isAuthenticated"
              class="flex h-5 w-5 items-center justify-center rounded-full bg-gradient-to-br from-cyan-400 to-teal-500 text-[10px] font-semibold text-white"
            >
              {{ userInitial }}
            </span>
            <span>{{ isAuthenticated ? t('home.dashboard') : t('home.login') }}</span>
            <svg
              class="h-3.5 w-3.5 text-white/45"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M4.5 19.5l15-15m0 0H8.25m11.25 0v11.25"
              />
            </svg>
          </router-link>
        </div>
      </nav>
    </header>

    <main class="relative isolate overflow-hidden">
      <div class="absolute inset-0 bg-[radial-gradient(circle_at_0%_0%,rgba(15,23,42,0.08),transparent_24%),radial-gradient(circle_at_78%_18%,rgba(59,130,246,0.08),transparent_22%),linear-gradient(180deg,#f8fafc_0%,#eef4fb_42%,#f8fafc_100%)] dark:bg-[radial-gradient(circle_at_0%_0%,rgba(45,212,191,0.16),transparent_26%),radial-gradient(circle_at_78%_18%,rgba(56,189,248,0.12),transparent_22%),linear-gradient(180deg,#07101d_0%,#081222_46%,#091426_100%)]"></div>
      <div class="absolute inset-0 opacity-[0.08] [background-image:linear-gradient(rgba(15,23,42,0.14)_1px,transparent_1px),linear-gradient(90deg,rgba(15,23,42,0.14)_1px,transparent_1px)] [background-size:44px_44px] dark:opacity-[0.07] dark:[background-image:linear-gradient(rgba(255,255,255,0.4)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.4)_1px,transparent_1px)]"></div>

      <section class="relative z-10 mx-auto grid max-w-[1440px] gap-14 px-6 py-16 lg:grid-cols-[minmax(0,1.02fr)_560px] lg:px-8 lg:py-24">
        <div class="max-w-3xl">
          <p class="inline-flex items-center gap-2 rounded-full border border-cyan-500/18 bg-cyan-500/10 px-3 py-1 text-[11px] font-medium uppercase tracking-[0.24em] text-cyan-700 dark:border-cyan-300/20 dark:bg-cyan-400/8 dark:text-cyan-200/85">
            <span class="h-1.5 w-1.5 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
            Unified AI Access
          </p>

          <h1 class="mt-6 max-w-4xl text-5xl font-semibold tracking-tight text-slate-950 md:text-6xl lg:text-[72px] lg:leading-[1.02] dark:text-white">
            一个入口，完成模型接入、调用、对比和管理。
          </h1>

          <p class="mt-6 max-w-2xl text-base leading-8 text-slate-600 md:text-lg dark:text-white/62">
            你不需要再在多个订阅、多个站点和多个规则之间来回切换。首页先把最关键的路径收敛清楚：开始使用、查看模型价格、进入控制台。
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
              class="inline-flex items-center justify-center rounded-full border border-slate-300 bg-white/75 px-6 py-3 text-sm font-medium text-slate-700 transition hover:border-cyan-300 hover:text-cyan-700 dark:border-white/12 dark:bg-white/4 dark:text-white/88 dark:hover:border-white/22 dark:hover:bg-white/8"
            >
              {{ t('home.viewPricing') }}
            </router-link>
          </div>

          <div class="mt-10 grid gap-4 md:grid-cols-3">
            <article class="rounded-2xl border border-slate-200 bg-white/72 p-4 shadow-[0_16px_40px_rgba(15,23,42,0.05)] dark:border-white/8 dark:bg-white/[0.035] dark:shadow-none">
              <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">Access</p>
              <p class="mt-3 text-sm leading-7 text-slate-700 dark:text-white/82">
                统一接入 Claude、GPT、Gemini 等常见模型能力。
              </p>
            </article>
            <article class="rounded-2xl border border-slate-200 bg-white/72 p-4 shadow-[0_16px_40px_rgba(15,23,42,0.05)] dark:border-white/8 dark:bg-white/[0.035] dark:shadow-none">
              <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">Compare</p>
              <p class="mt-3 text-sm leading-7 text-slate-700 dark:text-white/82">
                先看模型价格与倍率，再决定实际使用方式。
              </p>
            </article>
            <article class="rounded-2xl border border-slate-200 bg-white/72 p-4 shadow-[0_16px_40px_rgba(15,23,42,0.05)] dark:border-white/8 dark:bg-white/[0.035] dark:shadow-none">
              <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">Operate</p>
              <p class="mt-3 text-sm leading-7 text-slate-700 dark:text-white/82">
                登录后直接进入控制台、密钥和用量管理，不绕路。
              </p>
            </article>
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
                <span class="ml-3 text-xs uppercase tracking-[0.2em] text-slate-400 dark:text-white/35">Control Surface</span>
              </div>
            </div>

            <div class="grid gap-4 p-5">
              <section class="rounded-2xl border border-slate-200 bg-white p-4 dark:border-white/7 dark:bg-white/[0.035]">
                <div class="mb-5 flex items-start justify-between gap-4">
                  <div>
                    <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">Models</p>
                    <h2 class="mt-2 text-lg font-semibold text-slate-900 dark:text-white">常用模型能力预览</h2>
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
                        <p class="mt-1 text-xs text-slate-500 dark:text-white/42">{{ item.desc }}</p>
                      </div>
                      <div class="text-right">
                        <p class="text-sm font-semibold text-cyan-600 dark:text-cyan-300">{{ item.state }}</p>
                        <p class="mt-1 text-xs text-slate-400 dark:text-white/36">{{ item.meta }}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </section>

              <div class="grid gap-4 md:grid-cols-2">
                <section class="rounded-2xl border border-slate-200 bg-white p-4 dark:border-white/7 dark:bg-white/[0.035]">
                  <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">Pricing</p>
                  <h3 class="mt-2 text-lg font-semibold text-slate-900 dark:text-white">模型价格页</h3>
                  <p class="mt-3 text-sm leading-7 text-slate-600 dark:text-white/58">
                    统一查看官方价格、平台价格和倍率，不需要自己另外计算。
                  </p>
                  <router-link
                    to="/pricing"
                    class="mt-5 inline-flex items-center rounded-full border border-cyan-500/18 bg-cyan-500/8 px-4 py-2 text-sm font-medium text-cyan-700 transition hover:bg-cyan-500/12 dark:border-cyan-400/24 dark:bg-cyan-400/10 dark:text-cyan-200 dark:hover:bg-cyan-400/14"
                  >
                    查看模型价格
                  </router-link>
                </section>

                <section class="rounded-2xl border border-slate-200 bg-white p-4 dark:border-white/7 dark:bg-white/[0.035]">
                  <p class="text-xs uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">Workflow</p>
                  <ul class="mt-3 space-y-3 text-sm text-slate-700 dark:text-white/76">
                    <li class="flex items-start gap-3">
                      <span class="mt-1 h-2 w-2 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
                      先理解价格，再生成密钥，最后进入实际调用
                    </li>
                    <li class="flex items-start gap-3">
                      <span class="mt-1 h-2 w-2 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
                      管理后台和用户侧路径清晰分离，减少误操作
                    </li>
                    <li class="flex items-start gap-3">
                      <span class="mt-1 h-2 w-2 rounded-full bg-cyan-500 dark:bg-cyan-300"></span>
                      首页未来可以继续独立迭代，不和上游首页绑死
                    </li>
                  </ul>
                </section>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAuthStore, useAppStore } from '@/stores'
import LocaleSwitcher from '@/components/common/LocaleSwitcher.vue'
import Icon from '@/components/icons/Icon.vue'

const { t } = useI18n()
const authStore = useAuthStore()
const appStore = useAppStore()

const isDark = ref(document.documentElement.classList.contains('dark'))

const siteLogo = computed(() => appStore.cachedPublicSettings?.site_logo || appStore.siteLogo || '')
const isAuthenticated = computed(() => authStore.isAuthenticated)
const isAdmin = computed(() => authStore.isAdmin)
const dashboardPath = computed(() => (isAdmin.value ? '/admin/dashboard' : '/dashboard'))
const userInitial = computed(() => {
  const user = authStore.user
  if (!user?.email) return ''
  return user.email.charAt(0).toUpperCase()
})

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

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark', isDark.value)
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}
</script>
