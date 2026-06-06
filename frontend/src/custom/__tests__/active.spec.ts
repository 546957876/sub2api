import { describe, expect, it } from 'vitest'
import {
  activeCustomPack,
  getCustomLocaleMessages,
  getCustomNavItems,
  getCustomPageOverride,
  getCustomRoutes
} from '../active'

describe('custom override integration', () => {
  it('keeps override pack active with custom routes and page overrides', () => {
    expect(activeCustomPack.id).toBe('override')
    expect(getCustomRoutes().map((route) => route.path)).toEqual(
      expect.arrayContaining(['/docs', '/pricing'])
    )
    expect(getCustomPageOverride('home')).not.toBeNull()
  })

  it('exposes custom navigation entries through the active pack', () => {
    expect(getCustomNavItems('user').map((item) => item.path)).toEqual(
      expect.arrayContaining(['/docs', '/pricing'])
    )
    expect(getCustomNavItems('personal').map((item) => item.path)).toEqual(
      expect.arrayContaining(['/docs', '/pricing'])
    )
  })

  it('provides isolated locale messages for custom-only keys', () => {
    const zh = getCustomLocaleMessages('zh')
    const en = getCustomLocaleMessages('en')

    expect(zh?.custom.nav.integrationDocs).toBe('接入文档')
    expect(zh?.custom.pricingPage.title).toBe('模型价格')
    expect(en?.custom.nav.modelPricing).toBe('Model Pricing')
    expect(en?.custom.pricingPage.tabs.codex).toBe('Codex')
  })
})
