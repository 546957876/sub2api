import type { Component } from 'vue'
import DocsNodeView from './DocsNodeView.vue'
import DocsCodexView from './DocsCodexView.vue'

export interface DocsRegistryItem {
  key: string
  label: string
  component: Component
  enabled: boolean
}

export const docsRegistry: DocsRegistryItem[] = [
  {
    key: 'nodejs',
    label: 'Node.js 环境安装教程',
    component: DocsNodeView,
    enabled: true
  },
  {
    key: 'codex-openai',
    label: 'Codex (OpenAI) 配置教程',
    component: DocsCodexView,
    enabled: true
  },
  {
    key: 'claude-code',
    label: 'Claude Code 配置教程',
    component: DocsNodeView,
    enabled: false
  },
  {
    key: 'gemini-cli',
    label: 'Gemini CLI 配置教程',
    component: DocsNodeView,
    enabled: false
  }
]
