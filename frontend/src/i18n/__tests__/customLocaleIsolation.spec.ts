import { describe, expect, it } from 'vitest'

import en from '../locales/en'
import zh from '../locales/zh'

describe('custom locale isolation', () => {
  it('keeps override-only pricing copy out of shared locale roots', () => {
    expect('pricingPage' in zh).toBe(false)
    expect('pricingPage' in en).toBe(false)
    expect(zh.home.viewPricing).toBeUndefined()
    expect(en.home.viewPricing).toBeUndefined()
  })

  it('keeps override navigation labels out of shared nav locale roots', () => {
    expect(zh.nav.integrationDocs).toBeUndefined()
    expect(zh.nav.modelPricing).toBeUndefined()
    expect(en.nav.integrationDocs).toBeUndefined()
    expect(en.nav.modelPricing).toBeUndefined()
  })
})
