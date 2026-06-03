import defaultPack from '@/custom/packs/default'
import overridePack from '@/custom/packs/override'
import type { CustomNavEntry, CustomNavScope, CustomPack } from '@/custom/core/types'

const packRegistry: Record<string, CustomPack> = {
  default: defaultPack,
  override: overridePack,
}

const requestedPackId = (import.meta.env.VITE_UI_PACK || 'override').trim()

export const activeCustomPack = packRegistry[requestedPackId] ?? overridePack

export function getCustomRoutes() {
  return activeCustomPack.routes ?? []
}

export function getCustomNavItems(scope: CustomNavScope): CustomNavEntry[] {
  return (activeCustomPack.navItems ?? [])
    .filter((item) => item.scope === scope)
    .sort((a, b) => (a.order ?? 0) - (b.order ?? 0))
}

export function getCustomPageOverride(name: keyof NonNullable<CustomPack['pageOverrides']>) {
  return activeCustomPack.pageOverrides?.[name] ?? null
}

export function getCustomAppOverlays() {
  return activeCustomPack.appOverlays ?? []
}
