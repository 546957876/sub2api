import { describe, expect, it } from 'vitest'
import { i18n, loadLocaleMessages } from '../index'

describe('custom locale merge', () => {
  it('merges zh custom override messages into the shared locale tree', async () => {
    await loadLocaleMessages('zh')

    const messages = i18n.global.getLocaleMessage('zh') as Record<string, any>
    expect(messages.custom.nav.integrationDocs).toBe('接入文档')
    expect(messages.custom.pricingPage.title).toBe('模型价格')
    expect(messages.nav.dashboard).toBe('仪表盘')
  })

  it('merges en custom override messages into the shared locale tree', async () => {
    await loadLocaleMessages('en')

    const messages = i18n.global.getLocaleMessage('en') as Record<string, any>
    expect(messages.custom.nav.modelPricing).toBe('Model Pricing')
    expect(messages.custom.pricingPage.title).toBe('Model Pricing')
    expect(messages.nav.dashboard).toBe('Dashboard')
  })
})
