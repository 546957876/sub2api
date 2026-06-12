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
      description: '统一按人民币展示官方价格与平台价格，方便直接比较模型成本。倍率默认 1.0，可随时调整查看不同倍率下的平台价格。',
      tabs: {
        claude: 'Claude Code',
        codex: 'Codex',
        gemini: 'Gemini'
      },
      codexLabels: {
        standard: '标准'
      },
      exchangeRateLabel: 'RMB:USDT汇率',
      exchangeRateHint: '用于把官方 USDT 成本换算成官方人民币展示价。默认 1 USDT = 7 RMB，可按需要临时调整。',
      multiplierLabel: '分组倍率',
      multiplierHint: '倍率只决定平台要扣多少 USDT 余额，不直接等于页面上的折扣。这里的输入仅用于展示与对比，不会写入系统设置。',
      rulesTitle: '计价规则',
      rulesLine1: '官方价格（人民币） = 官方 USDT 价格 × {rate}',
      rulesLine2: '平台价格（人民币） = 平台实际扣费（USDT） ÷ 充值汇率（当前 1 RMB = {rate} USDT 余额）',
      rulesLine3: '折扣 = 我们价格 ÷ 官方价格；倍率只决定扣多少 USDT 余额，不直接等于折扣。',
      activeMultiplier: '当前倍率',
      imageTableTitle: 'GPT Image 2 生图价格',
      perImageUnit: '张',
      officialPricePrefix: '官方价格',
      columns: {
        model: '模型 ID',
        inputPrice: '输入价格',
        outputPrice: '输出价格',
        cacheWritePrice: '缓存创建',
        cacheReadPrice: '缓存读取',
        multiplier: '倍率',
        discount: '相当于官方',
        savings: '节省幅度',
        imageModel: '图片模型 ID',
        imageSize: '图片大小',
        ourPrice: '我们价格'
      },
      categoryTitles: {
        claude: 'Claude Code 价格列表',
        codex: 'Codex 价格列表',
        gemini: 'Gemini 价格列表'
      },
      categoryDescriptions: {
        claude: '展示 Claude 编程相关模型的官方价格，并按当前倍率实时换算平台价格。',
        codex: '展示当前 Codex 相关模型价格，并单独列出 GPT Image 2 的固定单张售价，便于和 Claude、Gemini 按同一成本口径比较。',
        gemini: '展示 Gemini 系列模型的官方价格，便于统一按人民币口径比较。'
      }
    }
  }
}
