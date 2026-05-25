<template>
  <div class="min-h-screen bg-[#0d1117] text-white">
    <div class="mx-auto max-w-7xl px-6 py-10 lg:px-8">
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
          <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
            <div>
              <h2 class="text-2xl font-semibold text-white">
                {{ currentCategory.title }}
              </h2>
              <p class="mt-1 text-sm text-white/55">
                {{ currentCategory.description }}
              </p>
            </div>

            <div class="grid grid-cols-2 gap-3 lg:flex lg:items-center">
              <div class="rounded-2xl border border-white/8 bg-[#0d1420] px-4 py-3">
                <p class="text-xs uppercase tracking-[0.16em] text-white/40">
                  {{ t('pricingPage.summaryOfficial') }}
                </p>
                <p class="mt-1 text-lg font-semibold text-white">
                  {{ formatCompactPrice(currentCategorySummary.officialRmbTotal) }}
                </p>
              </div>
              <div class="rounded-2xl border border-amber-400/15 bg-amber-500/10 px-4 py-3">
                <p class="text-xs uppercase tracking-[0.16em] text-amber-200/70">
                  {{ t('pricingPage.summaryOur') }}
                </p>
                <p class="mt-1 text-lg font-semibold text-amber-300">
                  {{ formatCompactPrice(currentCategorySummary.ourRmbTotal) }}
                </p>
              </div>
            </div>
          </div>
        </div>

        <div class="overflow-x-auto px-4 py-4 lg:px-6 lg:py-6">
          <table class="min-w-full border-separate border-spacing-0 overflow-hidden rounded-2xl border border-white/8 bg-[#101826]">
            <thead>
              <tr class="bg-[#1a2435] text-left text-sm text-white/70">
                <th class="px-5 py-4 font-medium">{{ t('pricingPage.columns.model') }}</th>
                <th class="px-4 py-4 font-medium">{{ t('pricingPage.columns.item') }}</th>
                <th class="px-4 py-4 font-medium">{{ t('pricingPage.columns.officialUsd') }}</th>
                <th class="px-4 py-4 font-medium">{{ t('pricingPage.columns.officialRmb') }}</th>
                <th class="px-4 py-4 font-medium">{{ t('pricingPage.columns.multiplier') }}</th>
                <th class="px-4 py-4 font-medium">{{ t('pricingPage.columns.ourRmb') }}</th>
                <th class="px-4 py-4 font-medium">{{ t('pricingPage.columns.discount') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="row in currentRows"
                :key="`${currentCategory.key}-${row.model}-${row.itemKey}`"
                class="border-t border-white/6 text-sm text-white/85"
              >
                <td class="border-t border-white/6 px-5 py-4 align-top">
                  <div class="flex flex-col gap-1">
                    <span class="font-semibold text-white">{{ row.model }}</span>
                    <span v-if="row.modelAlias" class="text-xs text-white/40">{{ row.modelAlias }}</span>
                  </div>
                </td>
                <td class="border-t border-white/6 px-4 py-4 align-top text-white/65">
                  {{ row.itemLabel }}
                </td>
                <td class="border-t border-white/6 px-4 py-4 align-top font-mono text-white/80">
                  {{ formatUsd(row.officialUsd) }}
                </td>
                <td class="border-t border-white/6 px-4 py-4 align-top">
                  <div class="font-semibold text-white">{{ formatRmb(row.officialRmb) }}</div>
                  <div class="mt-1 text-xs text-white/35">{{ row.unitLabel }}</div>
                </td>
                <td class="border-t border-white/6 px-4 py-4 align-top text-white/65">
                  {{ normalizedMultiplier.toFixed(2) }}x
                </td>
                <td class="border-t border-white/6 px-4 py-4 align-top">
                  <div class="font-semibold text-amber-300">{{ formatRmb(row.ourRmb) }}</div>
                  <div class="mt-1 text-xs text-white/35">
                    {{ t('pricingPage.ourPriceHint') }}
                  </div>
                </td>
                <td class="border-t border-white/6 px-4 py-4 align-top">
                  <span
                    class="inline-flex rounded-full px-3 py-1 text-xs font-semibold"
                    :class="row.discountFold <= 3
                      ? 'bg-emerald-500/15 text-emerald-300'
                      : row.discountFold <= 5
                        ? 'bg-amber-500/15 text-amber-300'
                        : 'bg-white/8 text-white/75'"
                  >
                    {{ row.discountText }}
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
type PricingItemKey = 'input' | 'output' | 'cacheWrite5m' | 'cacheWrite1h' | 'cacheRead'

interface PricingRowSource {
  model: string
  modelAlias?: string
  prices: Partial<Record<PricingItemKey, number>>
}

interface PricingDisplayRow {
  model: string
  modelAlias?: string
  itemKey: PricingItemKey
  itemLabel: string
  officialUsd: number
  officialRmb: number
  ourRmb: number
  discountFold: number
  discountText: string
  unitLabel: string
}

const RMB_PER_USDT = 7
const multiplierPresets = [0.5, 1, 1.5, 2, 2.5, 3]

const { t } = useI18n()

const activeTab = ref<PricingTabKey>('claude')
const groupMultiplierInput = ref<number>(1)

const tabs = computed(() => [
  { key: 'claude' as const, label: t('pricingPage.tabs.claude'), icon: 'sparkles' as const },
  { key: 'codex' as const, label: t('pricingPage.tabs.codex'), icon: 'terminal' as const },
  { key: 'gemini' as const, label: t('pricingPage.tabs.gemini'), icon: 'cpu' as const },
])

const normalizedMultiplier = computed(() => {
  const value = Number(groupMultiplierInput.value)
  if (!Number.isFinite(value) || value < 0) return 0
  return value
})

const itemLabels: Record<PricingItemKey, string> = {
  input: '输入',
  output: '输出',
  cacheWrite5m: '缓存写入（5m）',
  cacheWrite1h: '缓存写入（1h）',
  cacheRead: '缓存读取',
}

const pricingSource: Record<PricingTabKey, { titleKey: string; descriptionKey: string; rows: PricingRowSource[] }> = {
  claude: {
    titleKey: 'pricingPage.categoryTitles.claude',
    descriptionKey: 'pricingPage.categoryDescriptions.claude',
    rows: [
      {
        model: 'claude-opus-4-7',
        modelAlias: 'Claude Opus 4.7',
        prices: { input: 5, output: 25, cacheWrite5m: 6.25, cacheWrite1h: 10, cacheRead: 0.5 },
      },
      {
        model: 'claude-opus-4-6',
        modelAlias: 'Claude Opus 4.6',
        prices: { input: 5, output: 25, cacheWrite5m: 6.25, cacheWrite1h: 10, cacheRead: 0.5 },
      },
      {
        model: 'claude-sonnet-4-6',
        modelAlias: 'Claude Sonnet 4.6',
        prices: { input: 3, output: 15, cacheWrite5m: 3.75, cacheWrite1h: 6, cacheRead: 0.3 },
      },
      {
        model: 'claude-haiku-4-5',
        modelAlias: 'Claude Haiku 4.5',
        prices: { input: 1, output: 5, cacheWrite5m: 1.25, cacheWrite1h: 2, cacheRead: 0.1 },
      },
    ],
  },
  codex: {
    titleKey: 'pricingPage.categoryTitles.codex',
    descriptionKey: 'pricingPage.categoryDescriptions.codex',
    rows: [
      {
        model: 'gpt-5.3-codex',
        modelAlias: 'Standard',
        prices: { input: 1.75, output: 14, cacheRead: 0.175 },
      },
      {
        model: 'gpt-5.3-codex-priority',
        modelAlias: 'Priority',
        prices: { input: 3.5, output: 28, cacheRead: 0.35 },
      },
    ],
  },
  gemini: {
    titleKey: 'pricingPage.categoryTitles.gemini',
    descriptionKey: 'pricingPage.categoryDescriptions.gemini',
    rows: [
      {
        model: 'gemini-2.5-pro',
        modelAlias: 'Google Gemini 2.5 Pro',
        prices: { input: 1.25, output: 10, cacheRead: 0.31 },
      },
      {
        model: 'gemini-2.5-flash',
        modelAlias: 'Google Gemini 2.5 Flash',
        prices: { input: 0.3, output: 2.5, cacheRead: 0.075 },
      },
      {
        model: 'gemini-2.5-flash-lite',
        modelAlias: 'Google Gemini 2.5 Flash Lite',
        prices: { input: 0.1, output: 0.4, cacheRead: 0.025 },
      },
    ],
  },
}

const currentCategory = computed(() => {
  const current = pricingSource[activeTab.value]
  return {
    key: activeTab.value,
    title: t(current.titleKey),
    description: t(current.descriptionKey),
  }
})

function buildRows(rows: PricingRowSource[]): PricingDisplayRow[] {
  return rows.flatMap((row) =>
    (Object.entries(row.prices) as Array<[PricingItemKey, number | undefined]>)
      .flatMap(([itemKey, value]) => {
        if (typeof value !== 'number' || value <= 0) {
          return []
        }

        const officialUsd = value
        const officialRmb = officialUsd * RMB_PER_USDT
        const ourRmb = officialUsd * normalizedMultiplier.value
        const discountFold = officialRmb > 0 ? (ourRmb / officialRmb) * 10 : 0

        return [{
          model: row.model,
          modelAlias: row.modelAlias,
          itemKey,
          itemLabel: itemLabels[itemKey],
          officialUsd,
          officialRmb,
          ourRmb,
          discountFold,
          discountText: `${discountFold.toFixed(1)}折`,
          unitLabel: itemKey === 'input' || itemKey === 'output' || itemKey.startsWith('cache')
            ? '/ 1M tokens'
            : '',
        }]
      }),
  )
}

const currentRows = computed(() => buildRows(pricingSource[activeTab.value].rows))

const currentCategorySummary = computed(() => {
  const officialRmbTotal = currentRows.value.reduce((sum, row) => sum + row.officialRmb, 0)
  const ourRmbTotal = currentRows.value.reduce((sum, row) => sum + row.ourRmb, 0)
  return { officialRmbTotal, ourRmbTotal }
})

function formatUsd(value: number): string {
  return `$${value.toFixed(value >= 10 ? 2 : 3).replace(/\.?0+$/, '')}`
}

function formatRmb(value: number): string {
  return `¥${value.toFixed(2)}`
}

function formatCompactPrice(value: number): string {
  return `¥${value.toFixed(2)}`
}
</script>
