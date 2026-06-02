import type { RouteRecordRaw } from 'vue-router'
import type { CustomPack } from '@/custom/core/types'

const routes: RouteRecordRaw[] = [
  {
    path: '/pricing',
    name: 'Pricing',
    component: () => import('@/views/public/PricingView.vue'),
    meta: {
      requiresAuth: false,
      title: 'Pricing'
    }
  }
]

const peiqiPack: CustomPack = {
  id: 'peiqi',
  displayName: 'Peiqi',
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
    }
  ]
}

export default peiqiPack
