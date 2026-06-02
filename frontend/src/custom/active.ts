import defaultPack from '@/custom/packs/default'
import peiqiPack from '@/custom/packs/peiqi'
import type { CustomNavEntry, CustomNavScope, CustomPack } from '@/custom/core/types'

const packRegistry: Record<string, CustomPack> = {
  default: defaultPack,
  peiqi: peiqiPack,
}

const requestedPackId = (import.meta.env.VITE_UI_PACK || 'peiqi').trim()

export const activeCustomPack = packRegistry[requestedPackId] ?? peiqiPack

export function getCustomRoutes() {
  return activeCustomPack.routes ?? []
}

export function getCustomNavItems(scope: CustomNavScope): CustomNavEntry[] {
  return (activeCustomPack.navItems ?? [])
    .filter((item) => item.scope === scope)
    .sort((a, b) => (a.order ?? 0) - (b.order ?? 0))
}
