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
      multiplierLabel: 'Group Multiplier',
      multiplierHint: 'Platform RMB price = official USD price × 7 × multiplier. This input is only for display and comparison and does not change system settings.',
      rulesTitle: 'Pricing Rules',
      rulesLine1: 'Official RMB price = official USD price × 7',
      rulesLine2: 'Platform RMB price = official USD price × 7 × group multiplier',
      activeMultiplier: 'Active Multiplier',
      imageTableTitle: 'GPT Image 2 Generation Pricing',
      imageTableDescription: 'A separate per-image table for 1K, 2K, and 4K outputs, showing both the official cost and our price for one generated image.',
      perImageUnit: 'image',
      columns: {
        model: 'Model ID',
        inputPrice: 'Input Price',
        outputPrice: 'Output Price',
        cacheWritePrice: 'Cache Write',
        cacheReadPrice: 'Cache Read',
        multiplier: 'Multiplier',
        discount: 'Equivalent Discount',
        imageModel: 'Image Model ID',
        imageSize: 'Image Size',
        officialPrice: 'Official Price',
        ourPrice: 'Our Price'
      },
      categoryTitles: {
        claude: 'Claude Code Pricing',
        codex: 'Codex Pricing',
        gemini: 'Gemini Pricing'
      },
      categoryDescriptions: {
        claude: 'Displays the official Claude coding-related prices and converts them into platform pricing using the current multiplier.',
        codex: 'Displays official OpenAI API pricing for current Codex-related models and GPT Image 2 token rates, so Codex can be compared on the same cost basis as Claude and Gemini.',
        gemini: 'Displays official Gemini pricing so you can compare everything in RMB under one view.'
      }
    }
  }
}
