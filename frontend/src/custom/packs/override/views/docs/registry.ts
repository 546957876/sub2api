import type { Component } from 'vue'
import DocsNodeView from './DocsNodeView.vue'

export interface DocsRegistryItem {
  key: string
  label: string
  component: Component
}

export const docsRegistry: DocsRegistryItem[] = [
  {
    key: 'nodejs',
    label: 'Node.js 环境安装教程',
    component: DocsNodeView
  }
]
