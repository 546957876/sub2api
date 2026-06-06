<template>
  <div class="relative min-h-screen text-slate-900 transition-colors duration-300 dark:text-white">
    <div class="absolute inset-0 bg-[radial-gradient(circle_at_0%_0%,rgba(15,23,42,0.06),transparent_24%),radial-gradient(circle_at_78%_18%,rgba(59,130,246,0.06),transparent_22%),linear-gradient(180deg,#f8fafc_0%,#f1f5f9_42%,#f8fafc_100%)] dark:bg-[radial-gradient(circle_at_0%_0%,rgba(45,212,191,0.16),transparent_26%),radial-gradient(circle_at_78%_18%,rgba(56,189,248,0.12),transparent_22%),linear-gradient(180deg,#07101d_0%,#081222_46%,#091426_100%)]"></div>
    <div class="absolute inset-0 opacity-[0.08] [background-image:linear-gradient(rgba(15,23,42,0.14)_1px,transparent_1px),linear-gradient(90deg,rgba(15,23,42,0.14)_1px,transparent_1px)] [background-size:44px_44px] dark:opacity-[0.07] dark:[background-image:linear-gradient(rgba(255,255,255,0.4)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.4)_1px,transparent_1px)]"></div>

    <div class="relative mx-auto max-w-[1480px] px-6 py-10 lg:px-8 lg:py-14">
      <div class="mb-8">
        <p class="mb-3 inline-flex items-center gap-2 rounded-full border border-cyan-500/18 bg-cyan-500/10 px-3 py-1 text-xs text-cyan-700 dark:border-cyan-300/20 dark:bg-cyan-400/8 dark:text-cyan-200/85">
          <Icon name="calculator" size="sm" class="text-cyan-600 dark:text-cyan-300" />
          {{ t('custom.pricingPage.kicker') }}
        </p>
        <h1 class="text-4xl font-semibold tracking-tight text-slate-950 md:text-5xl dark:text-white">
          {{ t('custom.pricingPage.title') }}
        </h1>
        <p class="mt-3 max-w-3xl text-base leading-7 text-slate-600 md:text-lg dark:text-white/65">
          {{ t('custom.pricingPage.description') }}
        </p>
      </div>

      <div class="mb-6 grid gap-4 lg:grid-cols-[minmax(0,1fr)_320px]">
        <div class="rounded-2xl border border-slate-200 bg-white/82 p-4 shadow-[0_18px_50px_rgba(15,23,42,0.07)] dark:border-[#243042] dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.25)]">
          <div class="flex flex-wrap items-center gap-3">
            <button
              v-for="tab in tabs"
              :key="tab.key"
              type="button"
              class="inline-flex items-center gap-2 rounded-xl border px-4 py-2.5 text-sm font-medium transition-all"
              :class="activeTab === tab.key
                ? 'border-cyan-500/30 bg-cyan-500/10 text-cyan-700 shadow-[0_0_0_1px_rgba(6,182,212,0.18)] dark:border-amber-400/70 dark:bg-amber-500/10 dark:text-amber-300 dark:shadow-[0_0_0_1px_rgba(251,191,36,0.25)]'
                : 'border-transparent bg-slate-100 text-slate-600 hover:border-slate-200 hover:bg-white hover:text-slate-900 dark:bg-white/5 dark:text-white/65 dark:hover:border-white/10 dark:hover:bg-white/10 dark:hover:text-white'"
              @click="activeTab = tab.key"
            >
              <Icon :name="tab.icon" size="sm" />
              {{ tab.label }}
            </button>
          </div>
        </div>

        <div class="rounded-2xl border border-slate-200 bg-white/82 p-4 shadow-[0_18px_50px_rgba(15,23,42,0.07)] dark:border-[#243042] dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.25)]">
          <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-white/75">
            {{ t('custom.pricingPage.multiplierLabel') }}
          </label>
          <div class="flex items-center gap-3">
            <input
              v-model.number="groupMultiplierInput"
              type="number"
              min="0"
              step="0.1"
              class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-lg font-semibold text-slate-900 outline-none ring-0 transition focus:border-cyan-400/70 dark:border-white/10 dark:bg-[#0d1420] dark:text-white dark:focus:border-amber-400/70"
            />
            <span class="shrink-0 rounded-lg bg-slate-100 px-3 py-2 text-sm text-slate-500 dark:bg-white/5 dark:text-white/60">
              x
            </span>
          </div>
          <div class="mt-3 flex flex-wrap gap-2">
            <button
              v-for="preset in multiplierPresets"
              :key="preset"
              type="button"
              class="rounded-full border border-slate-200 bg-slate-100 px-3 py-1.5 text-xs text-slate-600 transition hover:border-cyan-300 hover:text-cyan-700 dark:border-white/10 dark:bg-white/5 dark:text-white/70 dark:hover:border-amber-400/40 dark:hover:text-amber-200"
              @click="groupMultiplierInput = preset"
            >
              {{ preset.toFixed(1) }}x
            </button>
          </div>
          <p class="mt-3 text-xs leading-6 text-slate-500 dark:text-white/45">
            {{ t('custom.pricingPage.multiplierHint') }}
          </p>
        </div>
      </div>

      <div class="mb-6 rounded-2xl border border-slate-200 bg-white/82 p-4 text-sm shadow-[0_18px_50px_rgba(15,23,42,0.07)] dark:border-[#243042] dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.25)]">
        <div class="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <div class="space-y-1">
            <p class="font-medium text-slate-900 dark:text-white/90">{{ t('custom.pricingPage.rulesTitle') }}</p>
            <p class="text-slate-600 dark:text-white/60">
              {{ t('custom.pricingPage.rulesLine1') }}
            </p>
            <p class="text-slate-600 dark:text-white/60">
              {{ t('custom.pricingPage.rulesLine2') }}
            </p>
          </div>
          <div class="rounded-xl border border-cyan-500/16 bg-cyan-500/8 px-4 py-3 text-right dark:border-amber-400/20 dark:bg-amber-500/10">
            <p class="text-xs uppercase tracking-[0.18em] text-cyan-700/80 dark:text-amber-200/75">
              {{ t('custom.pricingPage.activeMultiplier') }}
            </p>
            <p class="mt-1 text-2xl font-bold text-cyan-700 dark:text-amber-300">
              {{ normalizedMultiplier.toFixed(2) }}x
            </p>
          </div>
        </div>
      </div>

      <div class="rounded-3xl border border-slate-200 bg-white/86 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-[#243042] dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
        <div class="border-b border-slate-200 px-5 py-5 lg:px-6 dark:border-white/8">
          <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">
            {{ currentCategory.title }}
          </h2>
          <p class="mt-1 text-sm text-slate-500 dark:text-white/55">
            {{ currentCategory.description }}
          </p>
        </div>

        <div class="px-4 py-4 lg:px-6 lg:py-6">
          <div class="space-y-4 lg:hidden">
            <article
              v-for="row in currentRows"
              :key="`${currentCategory.key}-mobile-${row.model}`"
              class="rounded-2xl border border-slate-200 bg-white p-4 shadow-[0_12px_32px_rgba(15,23,42,0.06)] dark:border-white/8 dark:bg-[#101826] dark:shadow-none"
            >
              <div class="mb-4">
                <p class="text-base font-semibold text-slate-900 dark:text-white">{{ row.model }}</p>
                <p v-if="row.displayName" class="mt-1 text-xs text-slate-400 dark:text-white/45">{{ row.displayName }}</p>
              </div>

              <div class="grid gap-3">
                <div v-if="row.official.input != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.inputPrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatRmb(multiplyPrice(row.official.input)) }}
                    <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    官方价格 {{ formatRmb(toOfficialRmb(row.official.input)) }}
                  </p>
                </div>

                <div v-if="row.official.output != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.outputPrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatRmb(multiplyPrice(row.official.output)) }}
                    <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    官方价格 {{ formatRmb(toOfficialRmb(row.official.output)) }}
                  </p>
                </div>

                <div v-if="row.official.cacheWrite != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.cacheWritePrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatRmb(multiplyPrice(row.official.cacheWrite)) }}
                    <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    官方价格 {{ formatRmb(toOfficialRmb(row.official.cacheWrite)) }}
                  </p>
                </div>

                <div v-if="row.official.cacheRead != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.cacheReadPrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatRmb(multiplyPrice(row.official.cacheRead)) }}
                    <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    官方价格 {{ formatRmb(toOfficialRmb(row.official.cacheRead)) }}
                  </p>
                </div>
              </div>

              <div class="mt-4 flex items-center justify-between rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                <div>
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.multiplier') }}</p>
                  <p class="mt-1 text-sm font-medium text-slate-700 dark:text-white/78">{{ normalizedMultiplier.toFixed(2) }}x</p>
                </div>
                <div class="text-right">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.discount') }}</p>
                  <span class="mt-1 inline-flex rounded-full bg-emerald-500/12 px-3 py-1 text-xs font-semibold text-emerald-600 dark:text-emerald-300">
                    {{ discountLabel }}
                  </span>
                </div>
              </div>
            </article>
          </div>

          <div class="hidden overflow-x-auto lg:block">
            <table class="min-w-[1220px] border-separate border-spacing-0 overflow-hidden rounded-2xl border border-slate-200 bg-white dark:border-white/8 dark:bg-[#101826]">
            <thead>
              <tr class="bg-slate-50 text-left text-sm text-slate-500 dark:bg-[#1a2435] dark:text-white/70">
                <th class="w-[250px] px-5 py-4 font-medium">{{ t('custom.pricingPage.columns.model') }}</th>
                <th v-if="showInputColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.inputPrice') }}</th>
                <th v-if="showOutputColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.outputPrice') }}</th>
                <th v-if="showCacheWriteColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.cacheWritePrice') }}</th>
                <th v-if="showCacheReadColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.cacheReadPrice') }}</th>
                <th class="w-[100px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.multiplier') }}</th>
                <th class="w-[110px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.discount') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="row in currentRows"
                :key="`${currentCategory.key}-${row.model}`"
                class="border-t border-slate-200 text-sm text-slate-700 dark:border-white/6 dark:text-white/85"
              >
                <td class="border-t border-slate-200 px-5 py-4 align-top dark:border-white/6">
                  <div class="flex items-start gap-3">
                    <div class="min-w-0">
                      <div class="flex items-center gap-2">
                        <span class="font-semibold text-slate-900 dark:text-white">{{ row.model }}</span>
                      </div>
                      <p v-if="row.displayName" class="mt-1 text-xs text-slate-400 dark:text-white/45">{{ row.displayName }}</p>
                    </div>
                  </div>
                </td>

                <td v-if="showInputColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                  <div>
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.input)) }}
                      <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.input)) }}
                    </div>
                  </div>
                </td>
                <td v-if="showOutputColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                  <div>
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.output)) }}
                      <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.output)) }}
                    </div>
                  </div>
                </td>
                <td v-if="showCacheWriteColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                  <div>
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.cacheWrite)) }}
                      <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.cacheWrite)) }}
                    </div>
                  </div>
                </td>
                <td v-if="showCacheReadColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                  <div>
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.cacheRead)) }}
                      <span class="font-normal text-slate-400 dark:text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.cacheRead)) }}
                    </div>
                  </div>
                </td>

                <td class="border-t border-slate-200 px-4 py-4 align-top text-slate-600 dark:border-white/6 dark:text-white/72">
                  {{ normalizedMultiplier.toFixed(2) }}x
                </td>
                <td class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                  <span class="inline-flex rounded-full bg-emerald-500/12 px-3 py-1 text-xs font-semibold text-emerald-600 dark:text-emerald-300">
                    {{ discountLabel }}
                  </span>
                </td>
              </tr>
            </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import Icon from '@/components/icons/Icon.vue'

type PricingTabKey = 'claude' | 'codex' | 'gemini'

interface PricingRow {
  model: string
  displayName?: string
  official: {
    input?: number
    output?: number
    cacheWrite?: number
    cacheRead?: number
  }
}

interface PricingCategory {
  key: PricingTabKey
  title: string
  description: string
  icon: string
  rows: PricingRow[]
}

const RMB_PER_USDT = 7

const { t } = useI18n()

const activeTab = ref<PricingTabKey>('claude')
const groupMultiplierInput = ref(1)

const multiplierPresets = [1, 1.4, 2, 2.5]

const normalizedMultiplier = computed(() => {
  const raw = Number(groupMultiplierInput.value)
  if (!Number.isFinite(raw) || raw < 0) return 0
  return raw
})

const discountLabel = computed(() => {
  const discount = normalizedMultiplier.value / RMB_PER_USDT
  if (!Number.isFinite(discount) || discount <= 0) return '0折'
  return `${discount.toFixed(1)}折`
})

function multiplyPrice(officialPriceUsd?: number) {
  if (officialPriceUsd == null) return undefined
  return officialPriceUsd * normalizedMultiplier.value * RMB_PER_USDT
}

function toOfficialRmb(officialPriceUsd?: number) {
  if (officialPriceUsd == null) return undefined
  return officialPriceUsd * RMB_PER_USDT
}

function formatRmb(price?: number) {
  if (price == null || !Number.isFinite(price)) return '--'
  return `¥${price.toFixed(price >= 1 ? 2 : 2)}`
}

const tabs = computed((): Array<{ key: PricingTabKey; label: string; icon: 'brain' | 'terminal' | 'sparkles' }> => [
  { key: 'claude', label: t('custom.pricingPage.tabs.claude'), icon: 'brain' },
  { key: 'codex', label: t('custom.pricingPage.tabs.codex'), icon: 'terminal' },
  { key: 'gemini', label: t('custom.pricingPage.tabs.gemini'), icon: 'sparkles' },
])

const categories = computed<PricingCategory[]>(() => [
  {
    key: 'claude',
    title: t('custom.pricingPage.categoryTitles.claude'),
    description: t('custom.pricingPage.categoryDescriptions.claude'),
    icon: 'sparkles',
    rows: [
      {
        model: 'claude-opus-4-7',
        displayName: 'Claude Opus 4.7',
        official: { input: 5, output: 25, cacheWrite: 6.25, cacheRead: 0.5 }
      },
      {
        model: 'claude-opus-4-6',
        displayName: 'Claude Opus 4.6',
        official: { input: 5, output: 25, cacheWrite: 6.25, cacheRead: 0.5 }
      },
      {
        model: 'claude-sonnet-4-6',
        displayName: 'Claude Sonnet 4.6',
        official: { input: 3, output: 15, cacheWrite: 3.75, cacheRead: 0.3 }
      },
      {
        model: 'claude-haiku-4-5',
        displayName: 'Claude Haiku 4.5',
        official: { input: 1, output: 5, cacheWrite: 1.25, cacheRead: 0.1 }
      }
    ]
  },
  {
    key: 'codex',
    title: t('custom.pricingPage.categoryTitles.codex'),
    description: t('custom.pricingPage.categoryDescriptions.codex'),
    icon: 'terminal',
    rows: [
      {
        model: 'gpt-5.3-codex',
        displayName: 'Standard',
        official: { input: 1.75, output: 14, cacheRead: 0.175 }
      },
      {
        model: 'gpt-5.3-codex-priority',
        displayName: 'Priority',
        official: { input: 3.5, output: 28, cacheRead: 0.35 }
      }
    ]
  },
  {
    key: 'gemini',
    title: t('custom.pricingPage.categoryTitles.gemini'),
    description: t('custom.pricingPage.categoryDescriptions.gemini'),
    icon: 'star',
    rows: [
      {
        model: 'gemini-2.5-pro',
        displayName: 'Google Gemini 2.5 Pro',
        official: { input: 1.25, output: 10, cacheRead: 0.31 }
      },
      {
        model: 'gemini-2.5-flash',
        displayName: 'Google Gemini 2.5 Flash',
        official: { input: 0.3, output: 2.5, cacheRead: 0.07 }
      },
      {
        model: 'gemini-2.5-flash-lite',
        displayName: 'Google Gemini 2.5 Flash Lite',
        official: { input: 0.1, output: 0.4, cacheRead: 0.03 }
      }
    ]
  }
])

const currentCategory = computed(() => categories.value.find((item) => item.key === activeTab.value) ?? categories.value[0])
const currentRows = computed(() => currentCategory.value.rows)

const showInputColumn = computed(() => currentRows.value.some((row) => row.official.input != null))
const showOutputColumn = computed(() => currentRows.value.some((row) => row.official.output != null))
const showCacheWriteColumn = computed(() => currentRows.value.some((row) => row.official.cacheWrite != null))
const showCacheReadColumn = computed(() => currentRows.value.some((row) => row.official.cacheRead != null))
</script>
