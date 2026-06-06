export default {
  custom: {
    nav: {
      home: 'Home',
      integrationDocs: 'Documentation',
      modelPricing: 'Model Pricing'
    },
    home: {
      viewPricing: 'View Pricing'
    },
    pricingPage: {
      kicker: 'Official vs platform pricing',
      title: 'Model Pricing',
      description: 'Compare official model pricing with your platform pricing in RMB. The multiplier defaults to 1.0 and can be adjusted freely for direct comparison.',
      tabs: {
        claude: 'Claude Code',
        codex: 'Codex',
        gemini: 'Gemini'
      },
      multiplierLabel: 'Group Multiplier',
      multiplierHint: 'Platform price = official USDT price × multiplier. This input is only for display and comparison and does not change system settings.',
      rulesTitle: 'Pricing Rules',
      rulesLine1: 'Official RMB price = official USDT price × 7',
      rulesLine2: 'Platform RMB price = official USDT price × group multiplier',
      activeMultiplier: 'Active Multiplier',
      columns: {
        model: 'Model ID',
        inputPrice: 'Input Price',
        outputPrice: 'Output Price',
        cacheWritePrice: 'Cache Write',
        cacheReadPrice: 'Cache Read',
        multiplier: 'Multiplier',
        discount: 'Equivalent Discount'
      },
      categoryTitles: {
        claude: 'Claude Code Pricing',
        codex: 'Codex Pricing',
        gemini: 'Gemini Pricing'
      },
      categoryDescriptions: {
        claude: 'Displays the official Claude coding-related prices and converts them into platform pricing using the current multiplier.',
        codex: 'Displays official Codex pricing and helps compare effective cost under different multipliers.',
        gemini: 'Displays official Gemini pricing so you can compare everything in RMB under one view.'
      }
    }
  }
}
