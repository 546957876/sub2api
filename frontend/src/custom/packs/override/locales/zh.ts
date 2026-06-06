export default {
  custom: {
    nav: {
      home: '首页',
      integrationDocs: '接入文档',
      modelPricing: '模型价格'
    },
    home: {
      viewPricing: '查看模型价格'
    },
    pricingPage: {
      kicker: '官方价格与平台价格对比',
      title: '模型价格',
      description: '统一按人民币展示官方价格与平台价格，方便直接比较模型成本。倍率默认 1.0，可随时调整查看不同分组价格。',
      tabs: {
        claude: 'Claude Code',
        codex: 'Codex',
        gemini: 'Gemini'
      },
      multiplierLabel: '分组倍率',
      multiplierHint: '平台价格 = 官方 USDT 价格 × 倍率。这里的倍率仅用于展示与对比，不会写入系统设置。',
      rulesTitle: '计价规则',
      rulesLine1: '官方价格（人民币） = 官方 USDT 价格 × 7',
      rulesLine2: '平台价格（人民币） = 官方 USDT 价格 × 分组倍率',
      activeMultiplier: '当前倍率',
      columns: {
        model: '模型 ID',
        inputPrice: '输入价格',
        outputPrice: '输出价格',
        cacheWritePrice: '缓存创建',
        cacheReadPrice: '缓存读取',
        multiplier: '倍率',
        discount: '相当于官方'
      },
      categoryTitles: {
        claude: 'Claude Code 价格列表',
        codex: 'Codex 价格列表',
        gemini: 'Gemini 价格列表'
      },
      categoryDescriptions: {
        claude: '展示 Claude 编程相关模型的官方价格，并按当前倍率实时换算平台价格。',
        codex: '展示 Codex 系列模型的官方价格，适合用于对比不同倍率下的实际消耗。',
        gemini: '展示 Gemini 系列模型的官方价格，便于统一按人民币口径比较。'
      }
    }
  }
}
