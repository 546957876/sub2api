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
      codexLabels: {
        standard: 'Standard'
      },
      exchangeRateLabel: 'RMB:USDT Rate',
      exchangeRateHint: 'Used to convert the official USDT cost into an official RMB display price. Defaults to 1 USDT = 7 RMB and can be adjusted here when needed.',
      multiplierLabel: 'Group Multiplier',
      multiplierHint: 'The multiplier only affects how much USDT balance we deduct. It does not directly equal the discount shown against the official RMB price.',
      rulesTitle: 'Pricing Rules',
      rulesLine1: 'Official RMB price = official USDT price × {rate}',
      rulesLine2: 'Platform RMB price = platform USDT charge ÷ recharge rate (currently 1 RMB = {rate} USDT balance)',
      rulesLine3: 'Discount = our price ÷ official price. The multiplier only determines the USDT balance deduction and should not be treated as the discount directly.',
      activeMultiplier: 'Active Multiplier',
      imageTableTitle: 'GPT Image 2 Generation Pricing',
      perImageUnit: 'image',
      officialPricePrefix: 'Official price',
      columns: {
        model: 'Model ID',
        inputPrice: 'Input Price',
        outputPrice: 'Output Price',
        cacheWritePrice: 'Cache Write',
        cacheReadPrice: 'Cache Read',
        multiplier: 'Multiplier',
        discount: 'Equivalent Discount',
        savings: 'Savings',
        imageModel: 'Image Model ID',
        imageSize: 'Image Size',
        ourPrice: 'Our Price'
      },
      categoryTitles: {
        claude: 'Claude Code Pricing',
        codex: 'Codex Pricing',
        gemini: 'Gemini Pricing'
      },
      categoryDescriptions: {
        claude: 'Displays the official Claude coding-related prices and converts them into platform pricing using the current multiplier.',
        codex: 'Displays current Codex-related model pricing and a separate fixed per-image price table for GPT Image 2, so Codex can be compared on the same cost basis as Claude and Gemini.',
        gemini: 'Displays official Gemini pricing so you can compare everything in RMB under one view.'
      }
    }
  }
}
