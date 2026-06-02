import { defineAsyncComponent } from 'vue'
import type { RouteRecordRaw } from 'vue-router'
import type { CustomPack } from '@/custom/core/types'

const routes: RouteRecordRaw[] = [
  {
    path: '/docs',
    name: 'Docs',
    component: () => import('@/custom/packs/override/views/DocsView.vue'),
    meta: {
      requiresAuth: false,
      title: 'Docs'
    }
  },
  {
    path: '/pricing',
    name: 'Pricing',
    component: () => import('@/custom/packs/override/views/PricingRouteView.vue'),
    meta: {
      requiresAuth: false,
      title: 'Pricing'
    }
  }
]

const overridePack: CustomPack = {
  id: 'override',
  displayName: 'Override',
  routes,
  navItems: [
    {
      path: '/pricing',
      label: 'Model Pricing',
      labelKey: 'nav.modelPricing',
      icon: 'price-tag',
      scope: 'user',
      order: 100
    },
    {
      path: '/pricing',
      label: 'Model Pricing',
      labelKey: 'nav.modelPricing',
      icon: 'price-tag',
      scope: 'personal',
      order: 100
    },
    {
      path: '/docs',
      label: 'Documentation',
      icon: 'book',
      scope: 'user',
      order: 110
    },
    {
      path: '/docs',
      label: 'Documentation',
      icon: 'book',
      scope: 'personal',
      order: 110
    }
  ],
  pageOverrides: {
    home: defineAsyncComponent(() => import('@/custom/packs/override/views/HomeView.vue'))
  }
}

export default overridePack
