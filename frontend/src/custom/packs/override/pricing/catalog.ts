import type { Group, GroupPlatform } from '@/types'

export type PricingProductKey = 'claude' | 'codex' | 'gemini'

export interface TokenPricingCatalogRow {
  model: string
  displayName?: string
  platform: GroupPlatform
  official: {
    input?: number
    output?: number
    cacheWrite?: number
    cacheRead?: number
  }
}

export interface ImagePricingCatalogRow {
  model: string
  size: '1K' | '2K' | '4K'
  ourPriceRmb: number
}

export interface PricingCategoryCatalog {
  key: PricingProductKey
  rows: TokenPricingCatalogRow[]
  imageRows?: ImagePricingCatalogRow[]
}

export interface PricingGroupOption {
  id: number
  name: string
  description: string | null
  rateMultiplier: number
  imageRateIndependent: boolean
  imageRateMultiplier: number
  imagePrice1K: number | null
  imagePrice2K: number | null
  imagePrice4K: number | null
}

const catalog: PricingCategoryCatalog[] = [
  {
    key: 'claude',
    rows: [
      {
        model: 'claude-fable-5',
        displayName: 'Claude Fable 5',
        platform: 'anthropic',
        official: { input: 10, output: 50, cacheWrite: 12.5, cacheRead: 1 },
      },
      {
        model: 'claude-opus-4-8',
        displayName: 'Claude Opus 4.8',
        platform: 'anthropic',
        official: { input: 5, output: 25, cacheWrite: 6.25, cacheRead: 0.5 },
      },
      {
        model: 'claude-opus-4-7',
        displayName: 'Claude Opus 4.7',
        platform: 'anthropic',
        official: { input: 5, output: 25, cacheWrite: 6.25, cacheRead: 0.5 },
      },
      {
        model: 'claude-opus-4-6',
        displayName: 'Claude Opus 4.6',
        platform: 'anthropic',
        official: { input: 5, output: 25, cacheWrite: 6.25, cacheRead: 0.5 },
      },
      {
        model: 'claude-sonnet-4-6',
        displayName: 'Claude Sonnet 4.6',
        platform: 'anthropic',
        official: { input: 3, output: 15, cacheWrite: 3.75, cacheRead: 0.3 },
      },
      {
        model: 'claude-haiku-4-5',
        displayName: 'Claude Haiku 4.5',
        platform: 'anthropic',
        official: { input: 1, output: 5, cacheWrite: 1.25, cacheRead: 0.1 },
      },
    ],
  },
  {
    key: 'codex',
    rows: [
      {
        model: 'gpt-5.5',
        displayName: 'GPT-5.5',
        platform: 'openai',
        official: { input: 5, output: 30, cacheRead: 0.5 },
      },
      {
        model: 'gpt-5.4',
        displayName: 'GPT-5.4',
        platform: 'openai',
        official: { input: 2.5, output: 15, cacheRead: 0.25 },
      },
      {
        model: 'gpt-5.4-mini',
        displayName: 'GPT-5.4 Mini',
        platform: 'openai',
        official: { input: 0.75, output: 4.5, cacheRead: 0.075 },
      },
    ],
    imageRows: [
      { model: 'gpt-image-2', size: '1K', ourPriceRmb: 0.3 },
      { model: 'gpt-image-2', size: '2K', ourPriceRmb: 0.5 },
      { model: 'gpt-image-2', size: '4K', ourPriceRmb: 0.7 },
    ],
  },
  {
    key: 'gemini',
    rows: [
      {
        model: 'gemini-2.5-pro',
        displayName: 'Google Gemini 2.5 Pro',
        platform: 'gemini',
        official: { input: 1.25, output: 10, cacheRead: 0.31 },
      },
      {
        model: 'gemini-2.5-flash',
        displayName: 'Google Gemini 2.5 Flash',
        platform: 'gemini',
        official: { input: 0.3, output: 2.5, cacheRead: 0.07 },
      },
      {
        model: 'gemini-2.5-flash-lite',
        displayName: 'Google Gemini 2.5 Flash Lite',
        platform: 'gemini',
        official: { input: 0.1, output: 0.4, cacheRead: 0.03 },
      },
    ],
  },
]

export function getPricingCategoryCatalog(key: PricingProductKey): PricingCategoryCatalog | undefined {
  return catalog.find((item) => item.key === key)
}

export function buildPricingGroupOptions(groups: Group[], platform: GroupPlatform): PricingGroupOption[] {
  return groups
    .filter((group) => group.platform === platform && group.status === 'active')
    .map((group) => ({
      id: group.id,
      name: group.name,
      description: group.description,
      rateMultiplier: group.rate_multiplier > 0 ? group.rate_multiplier : 1,
      imageRateIndependent: Boolean(group.image_rate_independent),
      imageRateMultiplier: group.image_rate_multiplier >= 0 ? group.image_rate_multiplier : 1,
      imagePrice1K: group.image_price_1k,
      imagePrice2K: group.image_price_2k,
      imagePrice4K: group.image_price_4k,
    }))
}
