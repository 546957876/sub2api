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

      <div class="mb-6 grid gap-4 lg:grid-cols-[minmax(0,1fr)_320px_320px]">
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
            {{ t('custom.pricingPage.exchangeRateLabel') }}
          </label>
          <div class="flex items-center gap-3">
            <input
              v-model.number="exchangeRateInput"
              type="number"
              min="0"
              step="0.1"
              class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-lg font-semibold text-slate-900 outline-none ring-0 transition focus:border-cyan-400/70 dark:border-white/10 dark:bg-[#0d1420] dark:text-white dark:focus:border-amber-400/70"
            />
            <span class="shrink-0 rounded-lg bg-slate-100 px-3 py-2 text-sm text-slate-500 dark:bg-white/5 dark:text-white/60">
              RMB
            </span>
          </div>
          <p class="mt-3 text-xs leading-6 text-slate-500 dark:text-white/45">
            {{ t('custom.pricingPage.exchangeRateHint') }}
          </p>
        </div>

        <div class="rounded-2xl border border-slate-200 bg-white/82 p-4 shadow-[0_18px_50px_rgba(15,23,42,0.07)] dark:border-[#243042] dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.25)]">
          <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-white/75">
            {{ t('custom.pricingPage.multiplierLabel') }}
          </label>
          <div class="flex items-center gap-3">
            <input
              v-model.number="multiplierInput"
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
              @click="multiplierInput = preset"
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
              {{ t('custom.pricingPage.rulesLine1', { rate: pricingConfig.fxRmbPerUsd }) }}
            </p>
            <p class="text-slate-600 dark:text-white/60">
              {{ t('custom.pricingPage.rulesLine2', { rate: pricingConfig.rechargeUsdPerCny.toFixed(2) }) }}
            </p>
            <p class="text-slate-600 dark:text-white/60">
              {{ t('custom.pricingPage.rulesLine3') }}
            </p>
          </div>
          <div class="rounded-xl border border-cyan-500/16 bg-cyan-500/8 px-4 py-3 text-right dark:border-amber-400/20 dark:bg-amber-500/10">
            <p class="text-xs uppercase tracking-[0.18em] text-cyan-700/80 dark:text-amber-200/75">
              {{ t('custom.pricingPage.activeMultiplier') }}
            </p>
            <p class="mt-1 text-2xl font-bold text-cyan-700 dark:text-amber-300">
              {{ multiplier.toFixed(2) }}x
            </p>
            <p class="mt-1 text-xs text-cyan-700/75 dark:text-amber-200/75">
              {{ activeDiscountLabel }}
            </p>
          </div>
        </div>
      </div>

      <div class="rounded-3xl border border-slate-200 bg-white/86 shadow-[0_20px_60px_rgba(15,23,42,0.08)] dark:border-[#243042] dark:bg-[#131c2a] dark:shadow-[0_8px_30px_rgba(0,0,0,0.28)]">
        <div class="border-b border-slate-200 px-5 py-5 lg:px-6 dark:border-white/8">
          <h2 class="text-2xl font-semibold text-slate-900 dark:text-white">
            {{ currentCategoryTitle }}
          </h2>
          <p class="mt-1 text-sm text-slate-500 dark:text-white/55">
            {{ currentCategoryDescription }}
          </p>
        </div>

        <div class="px-4 py-4 lg:px-6 lg:py-6">
          <div class="space-y-4 lg:hidden">
            <article
              v-for="row in currentTokenRows"
              :key="`${activeTab}-mobile-${row.model}`"
              class="rounded-2xl border border-slate-200 bg-white p-4 shadow-[0_12px_32px_rgba(15,23,42,0.06)] dark:border-white/8 dark:bg-[#101826] dark:shadow-none"
            >
              <div class="mb-4">
                <p class="text-base font-semibold text-slate-900 dark:text-white">{{ row.model }}</p>
                <p v-if="row.displayName" class="mt-1 text-xs text-slate-400 dark:text-white/45">{{ row.displayName }}</p>
              </div>

              <div class="grid gap-3">
                <div v-if="row.officialRmb.input != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.inputPrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatTokenPrice(row.ourRmb.input) }}
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    {{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.input) }}
                  </p>
                </div>

                <div v-if="row.officialRmb.output != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.outputPrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatTokenPrice(row.ourRmb.output) }}
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    {{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.output) }}
                  </p>
                </div>

                <div v-if="row.officialRmb.cacheWrite != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.cacheWritePrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatTokenPrice(row.ourRmb.cacheWrite) }}
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    {{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.cacheWrite) }}
                  </p>
                </div>

                <div v-if="row.officialRmb.cacheRead != null" class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.cacheReadPrice') }}</p>
                  <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                    {{ formatTokenPrice(row.ourRmb.cacheRead) }}
                  </div>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/38">
                    {{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.cacheRead) }}
                  </p>
                </div>
              </div>

              <div class="mt-4 flex items-center justify-between rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                <div>
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.multiplier') }}</p>
                  <p class="mt-1 text-sm font-medium text-slate-700 dark:text-white/78">{{ multiplier.toFixed(2) }}x</p>
                </div>
                <div class="text-right">
                  <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.discount') }}</p>
                  <span class="mt-1 inline-flex rounded-full bg-emerald-500/12 px-3 py-1 text-xs font-semibold text-emerald-600 dark:text-emerald-300">
                    {{ activeDiscountLabel }}
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
                  <th class="w-[110px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.discount') }}</th>
                  <th class="w-[130px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.savings') }}</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="row in currentTokenRows"
                  :key="`${activeTab}-${row.model}`"
                  class="border-t border-slate-200 text-sm text-slate-700 dark:border-white/6 dark:text-white/85"
                >
                  <td class="border-t border-slate-200 px-5 py-4 align-top dark:border-white/6">
                    <span class="font-semibold text-slate-900 dark:text-white">{{ row.model }}</span>
                    <p v-if="row.displayName" class="mt-1 text-xs text-slate-400 dark:text-white/45">{{ row.displayName }}</p>
                  </td>
                  <td v-if="showInputColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">{{ formatTokenPrice(row.ourRmb.input) }}</div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">{{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.input) }}</div>
                  </td>
                  <td v-if="showOutputColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">{{ formatTokenPrice(row.ourRmb.output) }}</div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">{{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.output) }}</div>
                  </td>
                  <td v-if="showCacheWriteColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">{{ formatTokenPrice(row.ourRmb.cacheWrite) }}</div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">{{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.cacheWrite) }}</div>
                  </td>
                  <td v-if="showCacheReadColumn" class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                    <div class="text-[13px] font-semibold text-cyan-700 dark:text-amber-300">{{ formatTokenPrice(row.ourRmb.cacheRead) }}</div>
                    <div class="mt-1 text-xs text-slate-400 dark:text-white/38">{{ t('custom.pricingPage.officialPricePrefix') }} {{ formatTokenPrice(row.officialRmb.cacheRead) }}</div>
                  </td>
                  <td class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                    <span class="inline-flex rounded-full bg-emerald-500/12 px-3 py-1 text-xs font-semibold text-emerald-600 dark:text-emerald-300">
                      {{ activeDiscountLabel }}
                    </span>
                  </td>
                  <td class="border-t border-slate-200 px-4 py-4 align-top text-slate-600 dark:border-white/6 dark:text-white/72">
                    {{ activeSavingsLabel }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div v-if="currentImageRows.length" class="mt-8 border-t border-slate-200 pt-6 dark:border-white/8">
            <div class="mb-4">
              <h3 class="text-lg font-semibold text-slate-900 dark:text-white">
                {{ t('custom.pricingPage.imageTableTitle') }}
              </h3>
            </div>

            <div class="space-y-4 lg:hidden">
              <article
                v-for="row in currentImageRows"
                :key="`image-mobile-${row.model}-${row.size}`"
                class="rounded-2xl border border-slate-200 bg-white p-4 shadow-[0_12px_32px_rgba(15,23,42,0.06)] dark:border-white/8 dark:bg-[#101826] dark:shadow-none"
              >
                <div class="mb-4">
                  <p class="text-base font-semibold text-slate-900 dark:text-white">{{ row.model }}</p>
                  <p class="mt-1 text-xs text-slate-400 dark:text-white/45">{{ row.size }}</p>
                </div>

                <div class="grid gap-3">
                  <div class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 dark:border-white/8 dark:bg-white/[0.035]">
                    <p class="text-[11px] uppercase tracking-[0.18em] text-slate-400 dark:text-white/35">{{ t('custom.pricingPage.columns.ourPrice') }}</p>
                    <div class="mt-2 text-sm font-semibold text-cyan-700 dark:text-amber-300">
                      {{ formatPerImagePrice(row.ourPriceRmb) }}
                    </div>
                  </div>
                </div>
              </article>
            </div>

            <div class="hidden overflow-x-auto lg:block">
              <table class="min-w-[860px] border-separate border-spacing-0 overflow-hidden rounded-2xl border border-slate-200 bg-white dark:border-white/8 dark:bg-[#101826]">
                <thead>
                  <tr class="bg-slate-50 text-left text-sm text-slate-500 dark:bg-[#1a2435] dark:text-white/70">
                    <th class="w-[280px] px-5 py-4 font-medium">{{ t('custom.pricingPage.columns.imageModel') }}</th>
                    <th class="w-[180px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.imageSize') }}</th>
                    <th class="w-[200px] px-4 py-4 font-medium">{{ t('custom.pricingPage.columns.ourPrice') }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="row in currentImageRows"
                    :key="`image-${row.model}-${row.size}`"
                    class="border-t border-slate-200 text-sm text-slate-700 dark:border-white/6 dark:text-white/85"
                  >
                    <td class="border-t border-slate-200 px-5 py-4 align-top font-semibold text-slate-900 dark:border-white/6 dark:text-white">
                      {{ row.model }}
                    </td>
                    <td class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                      {{ row.size }}
                    </td>
                    <td class="border-t border-slate-200 px-4 py-4 align-top dark:border-white/6">
                      <span class="font-semibold text-cyan-700 dark:text-amber-300">{{ formatPerImagePrice(row.ourPriceRmb) }}</span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
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
import {
  getPricingCategoryCatalog,
  type PricingProductKey,
} from '@/custom/packs/override/pricing/catalog'
import {
  computeDiscountRatio,
  computeTokenOurUsd,
  formatDiscountLabel,
  formatSavingsLabel,
  normalizePricingDisplayConfig,
  officialUsdToRmb,
  ourUsdToRmb,
} from '@/custom/packs/override/pricing/formulas'

type DisplayTokenRow = ReturnType<typeof buildDisplayTokenRow>
type DisplayImageRow = ReturnType<typeof buildDisplayImageRow>

const { t, locale } = useI18n()

const activeTab = ref<PricingProductKey>('claude')
const exchangeRateInput = ref(7)
const multiplierInput = ref(1)

const multiplierPresets = [0.6, 0.7, 1, 1.4, 2]

const pricingConfig = computed(() => normalizePricingDisplayConfig({
  fxRmbPerUsd: exchangeRateInput.value,
  rechargeUsdPerCny: 1,
}))

const multiplier = computed(() => {
  const raw = Number(multiplierInput.value)
  if (!Number.isFinite(raw) || raw < 0) return 0
  return raw
})

const tabs = computed((): Array<{ key: PricingProductKey; label: string; icon: 'brain' | 'terminal' | 'sparkles' }> => [
  { key: 'claude', label: t('custom.pricingPage.tabs.claude'), icon: 'brain' },
  { key: 'codex', label: t('custom.pricingPage.tabs.codex'), icon: 'terminal' },
  { key: 'gemini', label: t('custom.pricingPage.tabs.gemini'), icon: 'sparkles' },
])

const currentCatalog = computed(() => getPricingCategoryCatalog(activeTab.value))
const currentCategoryTitle = computed(() => t(`custom.pricingPage.categoryTitles.${activeTab.value}`))
const currentCategoryDescription = computed(() => t(`custom.pricingPage.categoryDescriptions.${activeTab.value}`))

const activeDiscountLabel = computed(() => {
  const officialUsd = currentCatalog.value?.rows[0]?.official.input
  const officialRmb = officialUsdToRmb(officialUsd, pricingConfig.value)
  const ourUsd = computeTokenOurUsd(officialUsd, multiplier.value)
  const ourRmb = ourUsdToRmb(ourUsd, pricingConfig.value)
  return formatDiscountLabel(computeDiscountRatio(ourRmb, officialRmb), locale.value)
})

const activeSavingsLabel = computed(() => {
  const officialUsd = currentCatalog.value?.rows[0]?.official.input
  const officialRmb = officialUsdToRmb(officialUsd, pricingConfig.value)
  const ourUsd = computeTokenOurUsd(officialUsd, multiplier.value)
  const ourRmb = ourUsdToRmb(ourUsd, pricingConfig.value)
  return formatSavingsLabel(computeDiscountRatio(ourRmb, officialRmb), locale.value)
})

const currentTokenRows = computed<DisplayTokenRow[]>(() => {
  return (currentCatalog.value?.rows ?? []).map((row) => buildDisplayTokenRow(row.model, row.displayName, row.official, multiplier.value))
})

const currentImageRows = computed<DisplayImageRow[]>(() => {
  return (currentCatalog.value?.imageRows ?? []).map((row) => buildDisplayImageRow(row.model, row.size, row.ourPriceRmb))
})

const showInputColumn = computed(() => currentTokenRows.value.some((row) => row.officialRmb.input != null))
const showOutputColumn = computed(() => currentTokenRows.value.some((row) => row.officialRmb.output != null))
const showCacheWriteColumn = computed(() => currentTokenRows.value.some((row) => row.officialRmb.cacheWrite != null))
const showCacheReadColumn = computed(() => currentTokenRows.value.some((row) => row.officialRmb.cacheRead != null))

function buildDisplayTokenRow(
  model: string,
  displayName: string | undefined,
  official: { input?: number; output?: number; cacheWrite?: number; cacheRead?: number },
  currentMultiplier: number,
) {
  const officialRmb = {
    input: officialUsdToRmb(official.input, pricingConfig.value),
    output: officialUsdToRmb(official.output, pricingConfig.value),
    cacheWrite: officialUsdToRmb(official.cacheWrite, pricingConfig.value),
    cacheRead: officialUsdToRmb(official.cacheRead, pricingConfig.value),
  }
  const ourRmb = {
    input: ourUsdToRmb(computeTokenOurUsd(official.input, currentMultiplier), pricingConfig.value),
    output: ourUsdToRmb(computeTokenOurUsd(official.output, currentMultiplier), pricingConfig.value),
    cacheWrite: ourUsdToRmb(computeTokenOurUsd(official.cacheWrite, currentMultiplier), pricingConfig.value),
    cacheRead: ourUsdToRmb(computeTokenOurUsd(official.cacheRead, currentMultiplier), pricingConfig.value),
  }
  return {
    model,
    displayName,
    officialRmb,
    ourRmb,
  }
}

function buildDisplayImageRow(
  model: string,
  size: '1K' | '2K' | '4K',
  ourPriceRmb: number,
) {
  return {
    model,
    size,
    ourPriceRmb,
  }
}

function formatRmb(price?: number) {
  if (price == null || !Number.isFinite(price)) return '--'
  return `¥${price.toFixed(price >= 1 ? 2 : 3)}`
}

function formatTokenPrice(price?: number) {
  if (price == null || !Number.isFinite(price)) return '--'
  return `${formatRmb(price)} / 1M tokens`
}

function formatPerImagePrice(price?: number) {
  if (price == null || !Number.isFinite(price)) return '--'
  return `${formatRmb(price)}/${t('custom.pricingPage.perImageUnit')}`
}
</script>
