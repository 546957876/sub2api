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
                  <div class="flex flex-col gap-1">
                    <span class="text-[1.05rem] font-semibold leading-6 text-white [word-break:break-word]">{{ row.model }}</span>
                    <span v-if="row.modelAlias" class="text-xs text-white/40">{{ row.modelAlias }}</span>
                  </div>
                </td>

                <td v-if="showInputColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <PriceStack :metric="row.input" />
                </td>

                <td v-if="showOutputColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <PriceStack :metric="row.output" />
                </td>

                <td v-if="showCacheWriteColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <PriceStack :metric="row.cacheWrite" />
                </td>

                <td v-if="showCacheReadColumn" class="border-t border-white/6 px-4 py-4 align-top">
                  <PriceStack :metric="row.cacheRead" />
                </td>

                <td class="border-t border-white/6 px-4 py-4 align-top text-white/65">
                  {{ normalizedMultiplier.toFixed(2) }}x
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
import { computed, defineComponent, h, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import Icon from '@/components/icons/Icon.vue'

type PricingTabKey = 'claude' | 'codex' | 'gemini'

interface PriceMetricInput {
  officialUsd: number | null
}

interface PricingRowSource {
  model: string
  modelAlias?: string
  input?: PriceMetricInput
  output?: PriceMetricInput
  cacheWrite?: PriceMetricInput
  cacheRead?: PriceMetricInput
}

interface DisplayMetric {
  officialUsd: number | null
  officialRmb: number | null
  ourRmb: number | null
}

interface PricingDisplayRow {
  model: string
  modelAlias?: string
  input: DisplayMetric
  output: DisplayMetric
  cacheWrite: DisplayMetric
  cacheRead: DisplayMetric
  discountFold: number
  discountText: string
}

const PriceStack = defineComponent({
  name: 'PriceStack',
  props: {
    metric: {
      type: Object as () => DisplayMetric,
      required: true,
    },
  },
  setup(props) {
    return () => {
      if (props.metric.officialUsd == null || props.metric.officialRmb == null || props.metric.ourRmb == null) {
        return h('div', { class: 'text-sm text-white/30' }, '—')
      }

      return h('div', { class: 'min-w-[170px]' }, [
        h('div', { class: 'flex items-baseline gap-1.5 whitespace-nowrap' }, [
          h('span', { class: 'text-[1.95rem] font-bold leading-none text-amber-400' }, `¥${props.metric.ourRmb.toFixed(2)}`),
          h('span', { class: 'whitespace-nowrap text-sm text-white/45' }, '/ 1M tokens'),
        ]),
        h('div', { class: 'mt-1 whitespace-nowrap text-xs text-white/35' }, `官方价格 ¥${props.metric.officialRmb.toFixed(2)}`),
      ])
    }
  },
})

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

const pricingSource: Record<PricingTabKey, { titleKey: string; descriptionKey: string; rows: PricingRowSource[] }> = {
  claude: {
    titleKey: 'pricingPage.categoryTitles.claude',
    descriptionKey: 'pricingPage.categoryDescriptions.claude',
    rows: [
      {
        model: 'claude-opus-4-7',
        modelAlias: 'Claude Opus 4.7',
        input: { officialUsd: 5 },
        output: { officialUsd: 25 },
        cacheWrite: { officialUsd: 6.25 },
        cacheRead: { officialUsd: 0.5 },
      },
      {
        model: 'claude-opus-4-6',
        modelAlias: 'Claude Opus 4.6',
        input: { officialUsd: 5 },
        output: { officialUsd: 25 },
        cacheWrite: { officialUsd: 6.25 },
        cacheRead: { officialUsd: 0.5 },
      },
      {
        model: 'claude-sonnet-4-6',
        modelAlias: 'Claude Sonnet 4.6',
        input: { officialUsd: 3 },
        output: { officialUsd: 15 },
        cacheWrite: { officialUsd: 3.75 },
        cacheRead: { officialUsd: 0.3 },
      },
      {
        model: 'claude-haiku-4-5',
        modelAlias: 'Claude Haiku 4.5',
        input: { officialUsd: 1 },
        output: { officialUsd: 5 },
        cacheWrite: { officialUsd: 1.25 },
        cacheRead: { officialUsd: 0.1 },
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
        input: { officialUsd: 1.75 },
        output: { officialUsd: 14 },
        cacheRead: { officialUsd: 0.175 },
      },
      {
        model: 'gpt-5.3-codex-priority',
        modelAlias: 'Priority',
        input: { officialUsd: 3.5 },
        output: { officialUsd: 28 },
        cacheRead: { officialUsd: 0.35 },
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
        input: { officialUsd: 1.25 },
        output: { officialUsd: 10 },
        cacheRead: { officialUsd: 0.31 },
      },
      {
        model: 'gemini-2.5-flash',
        modelAlias: 'Google Gemini 2.5 Flash',
        input: { officialUsd: 0.3 },
        output: { officialUsd: 2.5 },
        cacheRead: { officialUsd: 0.075 },
      },
      {
        model: 'gemini-2.5-flash-lite',
        modelAlias: 'Google Gemini 2.5 Flash Lite',
        input: { officialUsd: 0.1 },
        output: { officialUsd: 0.4 },
        cacheRead: { officialUsd: 0.025 },
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

function metricToDisplay(metric?: PriceMetricInput): DisplayMetric {
  if (!metric || metric.officialUsd == null) {
    return { officialUsd: null, officialRmb: null, ourRmb: null }
  }

  return {
    officialUsd: metric.officialUsd,
    officialRmb: metric.officialUsd * RMB_PER_USDT,
    ourRmb: metric.officialUsd * normalizedMultiplier.value,
  }
}

const currentRows = computed<PricingDisplayRow[]>(() =>
  pricingSource[activeTab.value].rows.map((row) => {
    const input = metricToDisplay(row.input)
    const discountFold =
      input.officialRmb && input.ourRmb != null && input.officialRmb > 0
        ? (input.ourRmb / input.officialRmb) * 10
        : 0

    return {
      model: row.model,
      modelAlias: row.modelAlias,
      input,
      output: metricToDisplay(row.output),
      cacheWrite: metricToDisplay(row.cacheWrite),
      cacheRead: metricToDisplay(row.cacheRead),
      discountFold,
      discountText: `${discountFold.toFixed(1)}折`,
    }
  }),
)

const showInputColumn = computed(() => currentRows.value.some((row) => row.input.officialUsd != null))
const showOutputColumn = computed(() => currentRows.value.some((row) => row.output.officialUsd != null))
const showCacheWriteColumn = computed(() => currentRows.value.some((row) => row.cacheWrite.officialUsd != null))
const showCacheReadColumn = computed(() => currentRows.value.some((row) => row.cacheRead.officialUsd != null))
</script>
