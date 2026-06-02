<template>
  <div class="min-h-screen bg-[#0d1117] text-white">
    <div class="mx-auto max-w-[1480px] px-6 py-10 lg:px-8">
      <div class="mb-8">
        <p class="mb-3 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs text-white/70">
          <Icon name="calculator" size="sm" class="text-amber-400" />
          {{ t('pricingPage.kicker') }}
        </p>
        <h1 class="text-4xl font-bold tracking-tight text-white md:text-5xl">
          {{ t('pricingPage.title') }}
        </h1>
        <p class="mt-3 max-w-3xl text-base leading-7 text-white/65 md:text-lg">
          {{ t('pricingPage.description') }}
        </p>
      </div>

      <div class="mb-6 grid gap-4 lg:grid-cols-[minmax(0,1fr)_320px]">
        <div class="rounded-2xl border border-[#243042] bg-[#131c2a] p-4 shadow-[0_8px_30px_rgba(0,0,0,0.25)]">
          <div class="flex flex-wrap items-center gap-3">
            <button
              v-for="tab in tabs"
              :key="tab.key"
              type="button"
              class="inline-flex items-center gap-2 rounded-xl border px-4 py-2.5 text-sm font-medium transition-all"
              :class="activeTab === tab.key
                ? 'border-amber-400/70 bg-amber-500/10 text-amber-300 shadow-[0_0_0_1px_rgba(251,191,36,0.25)]'
                : 'border-transparent bg-white/5 text-white/65 hover:border-white/10 hover:bg-white/10 hover:text-white'"
              @click="activeTab = tab.key"
            >
              <Icon :name="tab.icon" size="sm" />
              {{ tab.label }}
            </button>
          </div>
        </div>

        <div class="rounded-2xl border border-[#243042] bg-[#131c2a] p-4 shadow-[0_8px_30px_rgba(0,0,0,0.25)]">
          <label class="mb-2 block text-sm font-medium text-white/75">
            {{ t('pricingPage.multiplierLabel') }}
          </label>
          <div class="flex items-center gap-3">
            <input
              v-model.number="groupMultiplierInput"
              type="number"
              min="0"
              step="0.1"
              class="w-full rounded-xl border border-white/10 bg-[#0d1420] px-4 py-3 text-lg font-semibold text-white outline-none ring-0 transition focus:border-amber-400/70"
            />
            <span class="shrink-0 rounded-lg bg-white/5 px-3 py-2 text-sm text-white/60">
              x
            </span>
          </div>
          <div class="mt-3 flex flex-wrap gap-2">
            <button
              v-for="preset in multiplierPresets"
              :key="preset"
              type="button"
              class="rounded-full border border-white/10 bg-white/5 px-3 py-1.5 text-xs text-white/70 transition hover:border-amber-400/40 hover:text-amber-200"
              @click="groupMultiplierInput = preset"
            >
              {{ preset.toFixed(1) }}x
            </button>
          </div>
          <p class="mt-3 text-xs leading-6 text-white/45">
            {{ t('pricingPage.multiplierHint') }}
          </p>
        </div>
      </div>

      <div class="mb-6 rounded-2xl border border-[#243042] bg-[#131c2a] p-4 text-sm shadow-[0_8px_30px_rgba(0,0,0,0.25)]">
        <div class="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <div class="space-y-1">
            <p class="font-medium text-white/90">{{ t('pricingPage.rulesTitle') }}</p>
            <p class="text-white/60">
              {{ t('pricingPage.rulesLine1') }}
            </p>
            <p class="text-white/60">
              {{ t('pricingPage.rulesLine2') }}
            </p>
          </div>
          <div class="rounded-xl border border-amber-400/20 bg-amber-500/10 px-4 py-3 text-right">
            <p class="text-xs uppercase tracking-[0.18em] text-amber-200/75">
              {{ t('pricingPage.activeMultiplier') }}
            </p>
            <p class="mt-1 text-2xl font-bold text-amber-300">
              {{ normalizedMultiplier.toFixed(2) }}x
            </p>
          </div>
        </div>
      </div>

      <div class="rounded-3xl border border-[#243042] bg-[#131c2a] shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
        <div class="border-b border-white/8 px-5 py-5 lg:px-6">
          <h2 class="text-2xl font-semibold text-white">
            {{ currentCategory.title }}
          </h2>
          <p class="mt-1 text-sm text-white/55">
            {{ currentCategory.description }}
          </p>
        </div>

        <div class="overflow-x-auto px-4 py-4 lg:px-6 lg:py-6">
          <table class="min-w-[1220px] border-separate border-spacing-0 overflow-hidden rounded-2xl border border-white/8 bg-[#101826]">
            <thead>
              <tr class="bg-[#1a2435] text-left text-sm text-white/70">
                <th class="w-[250px] px-5 py-4 font-medium">{{ t('pricingPage.columns.model') }}</th>
                <th v-if="showInputColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('pricingPage.columns.inputPrice') }}</th>
                <th v-if="showOutputColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('pricingPage.columns.outputPrice') }}</th>
                <th v-if="showCacheWriteColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('pricingPage.columns.cacheWritePrice') }}</th>
                <th v-if="showCacheReadColumn" class="w-[190px] px-4 py-4 font-medium">{{ t('pricingPage.columns.cacheReadPrice') }}</th>
                <th class="w-[100px] px-4 py-4 font-medium">{{ t('pricingPage.columns.multiplier') }}</th>
                <th class="w-[110px] px-4 py-4 font-medium">{{ t('pricingPage.columns.discount') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="row in currentRows"
                :key="`${currentCategory.key}-${row.model}`"
                class="border-t border-white/6 text-sm text-white/85"
              >
                <td class="border-t border-white/6 px-5 py-4 align-top">
                  <div class="flex items-start gap-3">
                    <div class="min-w-0">
                      <div class="flex items-center gap-2">
                        <span class="font-semibold text-white">{{ row.model }}</span>
                      </div>
                      <p v-if="row.displayName" class="mt-1 text-xs text-white/45">{{ row.displayName }}</p>
                    </div>
                  </div>
                </td>

                <td v-if="showInputColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <div>
                    <div class="text-[13px] font-semibold text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.input)) }}
                      <span class="font-normal text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.input)) }}
                    </div>
                  </div>
                </td>
                <td v-if="showOutputColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <div>
                    <div class="text-[13px] font-semibold text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.output)) }}
                      <span class="font-normal text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.output)) }}
                    </div>
                  </div>
                </td>
                <td v-if="showCacheWriteColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <div>
                    <div class="text-[13px] font-semibold text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.cacheWrite)) }}
                      <span class="font-normal text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.cacheWrite)) }}
                    </div>
                  </div>
                </td>
                <td v-if="showCacheReadColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <div>
                    <div class="text-[13px] font-semibold text-amber-300">
                      {{ formatRmb(multiplyPrice(row.official.cacheRead)) }}
                      <span class="font-normal text-white/45">/ 1M tokens</span>
                    </div>
                    <div class="mt-1 text-xs text-white/38">
                      官方价格 {{ formatRmb(toOfficialRmb(row.official.cacheRead)) }}
                    </div>
                  </div>
                </td>

                <td class="border-t border-white/6 px-4 py-4 align-top text-white/72">
                  {{ normalizedMultiplier.toFixed(2) }}x
                </td>
                <td class="border-t border-white/6 px-4 py-4 align-top">
                  <span class="inline-flex rounded-full bg-emerald-500/12 px-3 py-1 text-xs font-semibold text-emerald-300">
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
  { key: 'claude', label: 'Claude Code', icon: 'brain' },
  { key: 'codex', label: 'Codex', icon: 'terminal' },
  { key: 'gemini', label: 'Gemini', icon: 'sparkles' },
])

const categories = computed<PricingCategory[]>(() => [
  {
    key: 'claude',
    title: 'Claude Code 价格列表',
    description: '展示 Claude 编程相关模型的官方价格，并按当前倍率实时换算平台价格。',
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
    title: 'Codex 价格列表',
    description: '展示 Codex 系列模型的官方价格，适合用于对比不同倍率下的实际消耗。',
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
    title: 'Gemini 价格列表',
    description: '展示 Gemini 系列模型的官方价格，便于统一按人民币口径比较。',
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
