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
      codexLabels: {
        standard: '标准'
      },
      multiplierLabel: '分组倍率',
      multiplierHint: '平台价格（人民币） = 官方美元价格 × 7 × 倍率。这里的倍率仅用于展示与对比，不会写入系统设置。',
      rulesTitle: '计价规则',
      rulesLine1: '官方价格（人民币） = 官方 USD 价格 × 7',
      rulesLine2: '平台价格（人民币） = 官方 USD 价格 × 7 × 分组倍率',
      activeMultiplier: '当前倍率',
      imageTableTitle: 'GPT Image 2 生图价格',
      imageTableDescription: '单独按单张图片展示 1K、2K、4K 三档价格，方便直接对照官方成本与我们自己的售价。',
      perImageUnit: '张',
      columns: {
        model: '模型 ID',
        inputPrice: '输入价格',
        outputPrice: '输出价格',
        cacheWritePrice: '缓存创建',
        cacheReadPrice: '缓存读取',
        multiplier: '倍率',
        discount: '相当于官方',
        imageModel: '图片模型 ID',
        imageSize: '图片大小',
        officialPrice: '官方价格',
        ourPrice: '我们价格'
      },
      categoryTitles: {
        claude: 'Claude Code 价格列表',
        codex: 'Codex 价格列表',
        gemini: 'Gemini 价格列表'
      },
      categoryDescriptions: {
        claude: '展示 Claude 编程相关模型的官方价格，并按当前倍率实时换算平台价格。',
        codex: '展示当前 Codex 相关模型与 GPT Image 2 的官方 OpenAI API 定价，便于和 Claude、Gemini 按同一成本口径比较。',
        gemini: '展示 Gemini 系列模型的官方价格，便于统一按人民币口径比较。'
      }
    }
  }
}
