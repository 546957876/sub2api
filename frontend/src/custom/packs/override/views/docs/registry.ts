import type { Component } from 'vue'
import DocsNodeView from './DocsNodeView.vue'
import DocsCcSwitchView from './DocsCcSwitchView.vue'
import DocsCodexView from './DocsCodexView.vue'
import DocsClaudeCodeView from './DocsClaudeCodeView.vue'
import DocsGeminiCliView from './DocsGeminiCliView.vue'
import DocsOpenClawView from './DocsOpenClawView.vue'
import DocsHermesView from './DocsHermesView.vue'

export type DocsRegistryGroup = 'setup' | 'management' | 'tools'

export interface DocsRegistryItem {
  key: string
  label: string
  group: DocsRegistryGroup
  summary: string
  component: Component
  enabled: boolean
  recommended?: boolean
}

export const docsRegistry: DocsRegistryItem[] = [
  {
    key: 'nodejs',
    label: 'Node.js 环境',
    group: 'setup',
    summary: '先把 Node.js / npm 装好，再继续后面的 CLI 接入。',
    component: DocsNodeView,
    enabled: true,
    recommended: true
  },
  {
    key: 'cc-switch',
    label: 'CC Switch',
    group: 'management',
    summary: '适合同时管理 Claude Code、Codex、Gemini CLI 的用户。',
    component: DocsCcSwitchView,
    enabled: true,
    recommended: true
  },
  {
    key: 'codex-openai',
    label: 'Codex (OpenAI)',
    group: 'tools',
    summary: '用 OpenAI / Responses 风格地址接入 Codex。',
    component: DocsCodexView,
    enabled: true
  },
  {
    key: 'claude-code',
    label: 'Claude Code',
    group: 'tools',
    summary: '用 Anthropic 风格地址接入 Claude Code。',
    component: DocsClaudeCodeView,
    enabled: true
  },
  {
    key: 'gemini-cli',
    label: 'Gemini CLI',
    group: 'tools',
    summary: '手动写环境变量，直接走站点根地址。',
    component: DocsGeminiCliView,
    enabled: true
  },
  {
    key: 'openclaw',
    label: 'OpenClaw',
    group: 'tools',
    summary: '适合需要 Claude / Codex 双协议示例配置的用户。',
    component: DocsOpenClawView,
    enabled: true
  },
  {
    key: 'hermes',
    label: 'Hermes',
    group: 'tools',
    summary: '按 `config.yaml` 示例接入，适合已有 Hermes 用户。',
    component: DocsHermesView,
    enabled: true
  }
]
