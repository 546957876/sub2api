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
  'custom.pricingPage.exchangeRateLabel': 'RMB:USDT汇率',
  'custom.pricingPage.exchangeRateHint': 'fx hint',
  'custom.pricingPage.multiplierLabel': '分组倍率',
  'custom.pricingPage.multiplierHint': 'hint',
  'custom.pricingPage.rulesTitle': '计价规则',
  'custom.pricingPage.rulesLine1': '官方价格（人民币） = 官方 USDT 价格 × 7',
  'custom.pricingPage.rulesLine2': '平台价格（人民币） = 平台实际扣费（USDT） ÷ 充值汇率',
  'custom.pricingPage.rulesLine3': '折扣 = 我们价格 ÷ 官方价格',
  'custom.pricingPage.activeMultiplier': '当前倍率',
  'custom.pricingPage.officialPricePrefix': '官方价格',
  'custom.pricingPage.columns.model': '模型 ID',
  'custom.pricingPage.columns.inputPrice': '输入价格',
  'custom.pricingPage.columns.outputPrice': '输出价格',
  'custom.pricingPage.columns.cacheWritePrice': '缓存创建',
  'custom.pricingPage.columns.cacheReadPrice': '缓存读取',
  'custom.pricingPage.columns.multiplier': '倍率',
  'custom.pricingPage.columns.discount': '相当于官方',
  'custom.pricingPage.columns.savings': '节省幅度',
  'custom.pricingPage.categoryTitles.claude': 'Claude Code 价格列表',
  'custom.pricingPage.categoryDescriptions.claude': 'claude desc',
  'custom.pricingPage.categoryTitles.codex': 'Codex 价格列表',
  'custom.pricingPage.categoryDescriptions.codex': 'codex desc',
  'custom.pricingPage.categoryTitles.gemini': 'Gemini 价格列表',
  'custom.pricingPage.categoryDescriptions.gemini': 'gemini desc',
  'custom.pricingPage.codexLabels.standard': '标准',
  'custom.pricingPage.imageTableTitle': 'GPT Image 2 生图价格',
  'custom.pricingPage.perImageUnit': '张',
  'custom.pricingPage.columns.imageModel': '图片模型 ID',
  'custom.pricingPage.columns.imageSize': '图片大小',
  'custom.pricingPage.columns.ourPrice': '我们价格',
}

vi.mock('vue-i18n', async () => {
  const actual = await vi.importActual<typeof import('vue-i18n')>('vue-i18n')
  return {
    ...actual,
    useI18n: () => ({
      locale: { value: 'zh' },
      t: (key: string, params?: Record<string, string | number>) => {
        const template = translations[key] ?? key
        if (!params) return template
        return template.replace(/\{(\w+)\}/g, (_, name: string) => String(params[name] ?? ''))
      },
    }),
  }
})

describe('PricingView', () => {
  it('shows the latest Claude models including fable 5 and opus 4.8 by default', () => {
    const wrapper = mount(PricingView, {
      global: {
        stubs: {
          Icon: {
            template: '<span class="icon-stub" />',
          },
        },
      },
    })

    const text = wrapper.text()
    expect(text).toContain('claude-fable-5')
    expect(text).toContain('Claude Fable 5')
    expect(text).toContain('claude-opus-4-8')
    expect(text).toContain('Claude Opus 4.8')
  })

  it('shows standard Codex text pricing plus a fixed gpt-image-2 image table', async () => {
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
    expect(text).toContain('GPT Image 2 生图价格')
    expect(text).toContain('1K')
    expect(text).toContain('2K')
    expect(text).toContain('4K')
    expect(text).toContain('¥0.300/张')
    expect(text).toContain('¥0.500/张')
    expect(text).toContain('¥0.700/张')
    expect(text).not.toContain('gpt-5.3-codex')
    expect(text).not.toContain('gpt-5.2')
    expect(text).toContain('1.4折')
    expect(text).toContain('省 86%')
  })
})
