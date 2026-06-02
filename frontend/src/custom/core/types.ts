import type { Component } from 'vue'
import type { RouteRecordRaw } from 'vue-router'

export type CustomNavScope = 'user' | 'personal' | 'admin'

export type CustomNavIcon =
  | 'dashboard'
  | 'key'
  | 'chart'
  | 'gift'
  | 'user'
  | 'users'
  | 'folder'
  | 'channel'
  | 'credit-card'
  | 'recharge-subscription'
  | 'globe'
  | 'server'
  | 'bell'
  | 'ticket'
  | 'cog'
  | 'signal'
  | 'shield'
  | 'price-tag'
  | 'order'
  | 'order-list'
  | 'book'

export interface CustomNavEntry {
  path: string
  label: string
  labelKey?: string
  icon: CustomNavIcon
  scope: CustomNavScope
  externalUrl?: string
  hideInSimpleMode?: boolean
  order?: number
}

export interface CustomPack {
  id: string
  displayName: string
  routes?: RouteRecordRaw[]
  navItems?: CustomNavEntry[]
  pageOverrides?: Partial<Record<'home', Component>>
}
