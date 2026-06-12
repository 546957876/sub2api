import { mount } from '@vue/test-utils'
import { describe, expect, it, vi } from 'vitest'
import PricingView from '../PricingView.vue'

const translations: Record<string, string> = {
  'custom.pricingPage.kicker': '官方价格与平台价格对比',
  'custom.pricingPage.title': '模型价格',
  'custom.pricingPage.description': 'desc',
  'custom.pricingPage.tabs.claude': 'Claude Code',
  'custom.pricingPage.tabs.codex': 'Codex',
  'custom.pricingPage.tabs.gemini': 'Gemini',
  'custom.pricingPage.multiplierLabel': '分组倍率',
  'custom.pricingPage.multiplierHint': 'hint',
  'custom.pricingPage.rulesTitle': '计价规则',
  'custom.pricingPage.rulesLine1': '官方价格（人民币） = 官方 USD 价格 × 7',
  'custom.pricingPage.rulesLine2': '平台价格（人民币） = 官方 USD 价格 × 7 × 分组倍率',
  'custom.pricingPage.activeMultiplier': '当前倍率',
  'custom.pricingPage.columns.model': '模型 ID',
  'custom.pricingPage.columns.inputPrice': '输入价格',
  'custom.pricingPage.columns.outputPrice': '输出价格',
  'custom.pricingPage.columns.cacheWritePrice': '缓存创建',
  'custom.pricingPage.columns.cacheReadPrice': '缓存读取',
  'custom.pricingPage.columns.multiplier': '倍率',
  'custom.pricingPage.columns.discount': '相当于官方',
  'custom.pricingPage.categoryTitles.claude': 'Claude Code 价格列表',
  'custom.pricingPage.categoryDescriptions.claude': 'claude desc',
  'custom.pricingPage.categoryTitles.codex': 'Codex 价格列表',
  'custom.pricingPage.categoryDescriptions.codex': 'codex desc',
  'custom.pricingPage.categoryTitles.gemini': 'Gemini 价格列表',
  'custom.pricingPage.categoryDescriptions.gemini': 'gemini desc',
  'custom.pricingPage.codexLabels.standard': '标准',
  'custom.pricingPage.codexLabels.priority': 'Priority',
  'custom.pricingPage.codexLabels.textTokens': 'Text tokens',
  'custom.pricingPage.codexLabels.imageTokens': 'Image tokens',
}

vi.mock('vue-i18n', async () => {
  const actual = await vi.importActual<typeof import('vue-i18n')>('vue-i18n')
  return {
    ...actual,
    useI18n: () => ({
      locale: { value: 'zh' },
      t: (key: string) => translations[key] ?? key,
    }),
  }
})

describe('PricingView', () => {
  it('shows current Codex models instead of deprecated gpt-5.2 / gpt-5.3-codex entries', async () => {
    const wrapper = mount(PricingView, {
      global: {
        stubs: {
          Icon: {
            template: '<span class="icon-stub" />',
          },
        },
      },
    })

    await wrapper.findAll('button').find((button) => button.text().includes('Codex'))?.trigger('click')

    const text = wrapper.text()
    expect(text).toContain('gpt-5.5')
    expect(text).toContain('gpt-5.4')
    expect(text).toContain('gpt-5.4-mini')
    expect(text).toContain('gpt-image-2')
    expect(text).not.toContain('gpt-5.3-codex')
    expect(text).not.toContain('gpt-5.2')
    expect(text).toContain('10.0折')
  })
})
