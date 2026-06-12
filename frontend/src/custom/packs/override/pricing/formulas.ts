import type { PricingGroupOption } from './catalog'

export interface PricingDisplayConfig {
  fxRmbPerUsd: number
  rechargeUsdPerCny: number
}

export interface TokenPricingDisplayRow {
  model: string
  displayName?: string
  official: {
    input?: number
    output?: number
    cacheWrite?: number
    cacheRead?: number
  }
  officialRmb: {
    input?: number
    output?: number
    cacheWrite?: number
    cacheRead?: number
  }
  ourRmb: {
    input?: number
    output?: number
    cacheWrite?: number
    cacheRead?: number
  }
}

export interface ImagePricingDisplayRow {
  model: string
  size: '1K' | '2K' | '4K'
  officialPriceUsd: number
  officialPriceRmb: number
  ourPriceRmb: number
}

export function normalizePricingDisplayConfig(config?: Partial<PricingDisplayConfig>): PricingDisplayConfig {
  const fx = Number(config?.fxRmbPerUsd)
  const recharge = Number(config?.rechargeUsdPerCny)
  return {
    fxRmbPerUsd: Number.isFinite(fx) && fx > 0 ? fx : 7,
    rechargeUsdPerCny: Number.isFinite(recharge) && recharge > 0 ? recharge : 1,
  }
}

export function officialUsdToRmb(officialUsd: number | undefined, config: PricingDisplayConfig): number | undefined {
  if (officialUsd == null || !Number.isFinite(officialUsd)) {
    return undefined
  }
  return officialUsd * config.fxRmbPerUsd
}

export function ourUsdToRmb(ourUsd: number | undefined, config: PricingDisplayConfig): number | undefined {
  if (ourUsd == null || !Number.isFinite(ourUsd)) {
    return undefined
  }
  return ourUsd / config.rechargeUsdPerCny
}

export function computeTokenOurUsd(officialUsd: number | undefined, multiplier: number): number | undefined {
  if (officialUsd == null || !Number.isFinite(officialUsd)) {
    return undefined
  }
  return officialUsd * multiplier
}

export function computeImageBaseUsd(size: '1K' | '2K' | '4K', officialUsd: number, group: PricingGroupOption | null): number {
  if (group) {
    if (size === '1K' && group.imagePrice1K != null) return group.imagePrice1K
    if (size === '2K' && group.imagePrice2K != null) return group.imagePrice2K
    if (size === '4K' && group.imagePrice4K != null) return group.imagePrice4K
  }
  return officialUsd
}

export function resolveEffectiveMultiplier(group: PricingGroupOption | null, mode: 'token' | 'image'): number {
  if (!group) return 1
  if (mode === 'image' && group.imageRateIndependent) {
    return group.imageRateMultiplier
  }
  return group.rateMultiplier
}

export function computeDiscountRatio(ourPriceRmb: number | undefined, officialPriceRmb: number | undefined): number | undefined {
  if (
    ourPriceRmb == null || officialPriceRmb == null ||
    !Number.isFinite(ourPriceRmb) || !Number.isFinite(officialPriceRmb) ||
    officialPriceRmb <= 0
  ) {
    return undefined
  }
  return ourPriceRmb / officialPriceRmb
}

export function formatDiscountLabel(discountRatio: number | undefined, locale: string): string {
  if (discountRatio == null || !Number.isFinite(discountRatio) || discountRatio <= 0) {
    return locale.toLowerCase().startsWith('zh') ? '0折' : '0%'
  }
  if (locale.toLowerCase().startsWith('zh')) {
    return `${(discountRatio * 10).toFixed(1)}折`
  }
  return `${(discountRatio * 100).toFixed(0)}%`
}

export function computeSavingsRatio(discountRatio: number | undefined): number | undefined {
  if (discountRatio == null || !Number.isFinite(discountRatio)) {
    return undefined
  }
  return 1 - discountRatio
}

export function formatSavingsLabel(discountRatio: number | undefined, locale: string): string {
  const savingsRatio = computeSavingsRatio(discountRatio)
  if (savingsRatio == null || !Number.isFinite(savingsRatio)) {
    return locale.toLowerCase().startsWith('zh') ? '--' : '--'
  }
  if (locale.toLowerCase().startsWith('zh')) {
    return savingsRatio >= 0
      ? `省 ${(savingsRatio * 100).toFixed(0)}%`
      : `贵 ${(Math.abs(savingsRatio) * 100).toFixed(0)}%`
  }
  return savingsRatio >= 0
    ? `Save ${(savingsRatio * 100).toFixed(0)}%`
    : `+${(Math.abs(savingsRatio) * 100).toFixed(0)}%`
}
