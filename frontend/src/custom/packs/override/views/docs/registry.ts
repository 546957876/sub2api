import type { Component } from 'vue'
import DocsNodeView from './DocsNodeView.vue'
import DocsCcSwitchView from './DocsCcSwitchView.vue'
import DocsCodexView from './DocsCodexView.vue'
import DocsClaudeCodeView from './DocsClaudeCodeView.vue'
import DocsGeminiCliView from './DocsGeminiCliView.vue'
import DocsOpenClawView from './DocsOpenClawView.vue'
import DocsHermesView from './DocsHermesView.vue'

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
    key: 'cc-switch',
    label: 'CC Switch 使用教程',
    component: DocsCcSwitchView,
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
    component: DocsClaudeCodeView,
    enabled: true
  },
  {
    key: 'gemini-cli',
    label: 'Gemini CLI 配置教程',
    component: DocsGeminiCliView,
    enabled: true
  },
  {
    key: 'openclaw',
    label: 'OpenClaw 配置教程',
    component: DocsOpenClawView,
    enabled: true
  },
  {
    key: 'hermes',
    label: 'Hermes 配置教程',
    component: DocsHermesView,
    enabled: true
  }
]
